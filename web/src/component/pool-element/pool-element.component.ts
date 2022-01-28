import { Component, Input, OnInit } from '@angular/core';
import { ethers } from 'ethers';
import { AppState } from 'src/appState';
import { PoolService, PoolState } from 'src/services/pool.service';
import { Web3ModalService } from 'src/services/web3-modal.service';

@Component({
  selector: 'app-pool-element',
  templateUrl: './pool-element.component.html',
  styleUrls: ['./pool-element.component.scss']
})
export class PoolElementComponent implements OnInit {
  @Input() pool!: PoolState;
  @Input() contractAddress!: string;
  @Input() poolId!: number;

  private isApproved: boolean | null = null;
  approveTransactionHash: string= "";
  approveWaiting: boolean = false;

  constructor(private web3ModalSevice: Web3ModalService, private poolService: PoolService) { }

  ngOnInit() {

  }

  walletSigned(): boolean{
    return AppState.walletSigned();
  }

  isTokenDepositApproved() : boolean | null{
    if(this.isApproved == null && !this.approveWaiting && this.pool.tokenDeposit.isReady()){
      this.approveWaiting = true;
      this.pool.tokenDeposit.isApproved(this.contractAddress).then(val => {
        this.isApproved = val;
        this.approveWaiting = false;
      });
    }
    return this.isApproved;
  }

  approve(){
    if(this.approveWaiting)
      return;
    this.approveWaiting = true;
    this.pool.tokenDeposit.approve(this.contractAddress).then(value => {
      if(value == false) {
        this.isApproved = value;
        this.approveWaiting = false;
      } else {
        const t = value as ethers.Transaction;
        if(t.hash){
          this.approveTransactionHash = t.hash;
          this.web3ModalSevice.notLoggedProvider.waitForTransaction(this.approveTransactionHash).then(value => {
            this.approveWaiting = false;
            this.isApproved = true;
          });
        }
      }
    });
  }

  depositTransactionHash: string | undefined;
  depositError: string | null = null;
  depositLoading: boolean = false;
  deposit(amountString: string){
    const amount = Number(amountString);
    this.depositLoading = true;
    this.depositTransactionHash = undefined;
    this.depositError = null;
    this.poolService.deposit(this.poolId, amount).then(tr => {
      this.depositLoading = false;
      this.depositTransactionHash = tr.hash;
    }, (reject) => {
      if(reject.data != null && reject.data.message != null)
        this.depositError = reject.data.message;
      else if(reject.message != null)
        this.depositError = reject.message;
      else
        this.depositError = reject;
      this.depositLoading = false;
    })
  }
}
