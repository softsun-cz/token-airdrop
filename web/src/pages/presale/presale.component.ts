import { Component, OnInit } from '@angular/core';
import { AppState, IPresale } from 'src/appState';
import { Config } from 'src/config';
import { Web3ModalService } from 'src/services/web3-modal.service';

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
}
