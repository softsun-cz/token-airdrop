import { Component, OnDestroy, OnInit } from '@angular/core';
import { interval, Subscription } from 'rxjs';
import { Config } from 'src/config';
import { takeWhile } from 'rxjs/operators';
import { Web3ModalService } from 'src/services/web3-modal.service';
import { AppState } from 'src/appState';
import { ethers } from 'ethers';

@Component({
  selector: 'app-homepage',
  templateUrl: './homepage.component.html',
  styleUrls: ['./homepage.component.scss']
})
export class HomepageComponent implements OnInit, OnDestroy {
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

  token(): string{
    if(AppState.tokenName == "" || AppState.tokenSymbol == "")
      return "";
    return AppState.tokenName + " (" + AppState.tokenSymbol + ")"
  }

  airdropTokenAddress() : string{
    return Config.main.addressAirdrop.toLowerCase();
  }

  walletConnected(): boolean{
    return AppState.walletConnected();
  }

  badChainId(): boolean{
    return AppState.badChainId();
  }

  walletAddress(): string{
    return AppState.selectedAddress == null ? "" : AppState.selectedAddress;
  }

  tokenAddress(): string{
    return AppState.addressToken;
  }

  airdropsCountString(): string | null{
    if(this.remainingTokens == -1 || this.amountOfTokens == -1 || this.airdropsCount == -1)
      return null;
    return this.airdropsCount + " / " + ((this.remainingTokens  / this.amountOfTokens) + this.airdropsCount);
  }

  airdropTransctionHash: string | undefined;
  airdropRecieved(): boolean | null{
    if(AppState.badChainId())
      return null;
    return AppState.airdropRecieved;
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

  connect(){
    this.web3ModalService.web3Modal();
  }
}

