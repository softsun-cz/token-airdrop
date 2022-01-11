import { Component, OnDestroy, OnInit } from '@angular/core';
import { interval, Subscription } from 'rxjs';
import { Config } from 'src/config';
import { takeWhile } from 'rxjs/operators';
import { Web3ModalService } from 'src/services/web3-modal.service';
import { AppState, StateToken } from 'src/appState';
import { ethers } from 'ethers';

@Component({
  selector: 'app-airdrop',
  templateUrl: './airdrop.component.html',
  styleUrls: ['./airdrop.component.scss']
})
export class AirdropComponent implements OnInit, OnDestroy {

  initialized: boolean = false;
  subscription: Subscription | null = null;
  amountOfTokens : number = -1;
  remainingTokens: number = -1;
  airdropsCount: number = -1;
  totalClaimed: number = -1;
  constructor(private web3ModalService: Web3ModalService) { 

  }

  ngOnDestroy(): void {
    this.initialized = false;
  }

  ngOnInit() {
    this.initialized = true;
    this.loadData();
    this.subscription = interval(Config.main.updateInterval * 1000)
    .pipe(takeWhile(() => this.initialized))
    .subscribe(() => {
      this.loadData();
    });
  }

  tokenInstance(): StateToken{
    return AppState.token;
  }

  token(): string{
    if(!AppState.token.isReady())
      return "";
    return AppState.token.name + " (" + AppState.token.symbol + ")"
  }

  tokenSymbol(): string{
    return AppState.token.symbol;
  }

  airdropTokenAddress() : string{
    return Config.main.addressAirdrop;
  }

  walletConnected(): boolean{
    return AppState.walletConnected();
  }

  tokenAddress(): string{
    return AppState.token.address;
  }

  airdropsTotal(): null | number{
    if(this.remainingTokens == -1 || this.amountOfTokens == -1 || this.airdropsCount == -1)
      return null;
    return ((this.remainingTokens  / this.amountOfTokens) + this.airdropsCount);
  }

  airdropTransctionHash: string | undefined;
  airdropRecieved(): boolean | null{
    if(AppState.badChainId() || this.tokenSymbol() == '')
      return null;
    return AppState.airdropRecieved;
  }

  isAirdropPossible(): boolean{
    if(this.airdropRecieved() || this.airdropsTotal() == null || this.remainingTokens < this.amountOfTokens)
      return false;
    return true;
  }
  
  airDropClick(){
    this.web3ModalService.airdrop().then((transaction: ethers.Transaction) => {
      this.airdropTransctionHash = transaction.hash;
      AppState.airdropRecieved = true;
    }, (error: any) => {
      //console.log(error);
    });
  }

  private loadData(){
    //this.amountOfTokens = this.remainingTokens = this.totalClaimed = this.airdropsCount = -1;
    this.web3ModalService.getTotalClaimed().then(value => {
      this.totalClaimed = value;
    });
    this.web3ModalService.getAmountOfTokens().then(value => {
      this.amountOfTokens = value;
    });
    this.web3ModalService.getRemainingTokens().then(value => {
      this.remainingTokens = value;
    });
    this.web3ModalService.getAirdropsCount().then(value => {
      this.airdropsCount = value;
    });
  }
}
