import { Component, OnInit } from '@angular/core';
import { ethers } from 'ethers';
import { CountdownConfig } from 'ngx-countdown';
import { AppState, IPresale } from 'src/appState';
import { Config } from 'src/config';
import { Web3ModalService } from 'src/services/web3-modal.service';
import { isNumber } from 'util';

@Component({
  selector: 'app-presale',
  templateUrl: './presale.component.html',
  styleUrls: ['./presale.component.scss']
})
export class PresaleComponent implements OnInit {

  constructor(private web3ModalSevice: Web3ModalService) { }

  ngOnInit() {
  }

  presale() : IPresale{
    return AppState.getPresale();
  }

  presaleContractAddress(): string{
    return Config.main.addressPresale;
  }

  ourToken(): string{
    if(this.presale().tokenOur.name == "" || this.presale().tokenOur.symbol == "")
      return "";
    return this.presale().tokenOur.name + " (" + this.presale().tokenOur.symbol + ")"
  }

  theirToken(): string{
    if(this.presale().tokenTheir.name == "" || this.presale().tokenTheir.symbol == "")
      return "";
    return this.presale().tokenTheir.name + " (" + this.presale().tokenTheir.symbol + ")"
  }

  walletAddress(): string{
    return AppState.selectedAddress == null ? "" : AppState.selectedAddress;
  }

  walletSigned(): boolean{
    const ret = AppState.walletSigned();
    if(!ret){
      this.presaleApproved = null;
      this.presaleApprovedWaiting = this.presaleApproveWaiting = false;
    }
    return ret;
  }

  checkClaimedResult: number = -1;
  checkClaimedLoading: boolean = false;
  checkClaimed(address: string){
    if(this.checkClaimedLoading)
      return;
    this.checkClaimedResult = -1;
    this.checkClaimedLoading = true;
    this.web3ModalSevice.presaleClaimed(address).then(value => {
      this.checkClaimedResult = value;
      this.checkClaimedLoading = false;
    });
  }

  checkDepositedResult: number = -1;
  checkDepositedLoading: boolean = false;
  checkDeposited(address: string){
    if(this.checkDepositedLoading)
      return;
    this.checkDepositedResult = -1;
    this.checkDepositedLoading = true;
    this.web3ModalSevice.presaleDeposited(address).then(value => {
      this.checkDepositedResult = value;
      this.checkDepositedLoading = false;
    });
  }

  timestampToTimeout(timestamp: number) : number{
    return timestamp - (Date.now() / 1000) + AppState.reduceActualTimestamp;
  }

  timeOutConfig(timestamp: number): CountdownConfig {
    return {
      leftTime: this.timestampToTimeout(timestamp),
      format: 'dd:HH:mm:ss',
      prettyText: (text) => {
        let ret = "";
        const sp = text.split(':');
        const symbols = ["d","h","m","s"];
        sp.forEach((val, idx) => {
          if(idx == 0)
            val = (Number(val) - 1).toLocaleString( undefined, {minimumIntegerDigits: 2})
          if(ret != "" || val != "00")
            ret += '<span class="item">' + val + '' + symbols[idx] + '</span>'
        });
        return ret;
      }
    };
  }
  depositTransactionHash: string | undefined;
  depositError: string | null = null;
  depositLoading: boolean = false;
  deposit(amountString: string){
    const amount = Number(amountString);
    this.depositLoading = true;
    this.depositTransactionHash = undefined;
    this.depositError = null;
    this.web3ModalSevice.presaleDeposit(amount).then(tr => {
      this.depositLoading = false;
      this.depositTransactionHash = tr.hash;
    }, (reject) => {
      console.log(reject);
      if(reject.message)
        this.depositError = reject.message;
      else
        this.depositError = reject;
      this.depositLoading = false;
    })
  }

  claimTransactionHash: string | undefined;
  claimError: string | null = null;
  claimLoading: boolean = false;
  claim(){
    this.claimLoading = true;
    this.claimTransactionHash = undefined;
    this.claimError = null;
    this.web3ModalSevice.presaleClaim().then(tr => {
      this.claimLoading = false;
      this.claimTransactionHash = tr.hash;
    }, (reject) => {
      console.log(reject);
      if(reject.message)
        this.claimError = reject.message;
      else
        this.claimError = reject;
      this.claimLoading = false;
    })
  }

  presaleApprovedWaiting: boolean = false;
  presaleApproved: boolean | null = null;
  ispresaleApproved() : boolean | null{
    if(this.presaleApproved == null && !this.presaleApprovedWaiting){
      this.presaleApprovedWaiting = true;
      AppState.presale.tokenTheir.isApproved(Config.main.addressPresale).then(value => {
        this.presaleApproved = value;
        this.presaleApprovedWaiting = false;
        this.presaleApproveWaiting = false;
      });
    }
    return this.presaleApproved;
  }

  presaleApproveWaiting: boolean = false;
  presaleApprove(){
    if(this.presaleApproveWaiting)
      return;
    this.presaleApproveWaiting = true;
    AppState.presale.tokenTheir.approve(Config.main.addressPresale).then(value => {
      console.log(value);
      if(value == false) {
        this.presaleApproved = value;
        this.presaleApproveWaiting = false;
      } else {
        const t = value as ethers.Transaction;
        if(t.hash){
          this.depositTransactionHash = t.hash;
          this.web3ModalSevice.notLoggedProvider.waitForTransaction(this.depositTransactionHash).then(value => {
            this.presaleApprovedWaiting = false;
            this.presaleApproved = true;
            this.ispresaleApproved();
          });
        }
      }
    });
  }
}
