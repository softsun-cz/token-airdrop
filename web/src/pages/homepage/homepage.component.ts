import { Component, OnDestroy, OnInit } from '@angular/core';
import { interval, Subscription } from 'rxjs';
import { Config } from 'src/config';
import { takeWhile } from 'rxjs/operators';
import { Web3ModalService } from 'src/services/web3-modal.service';
import { AppState, IPresale, StateToken } from 'src/appState';
import { ethers } from 'ethers';

@Component({
  selector: 'app-homepage',
  templateUrl: './homepage.component.html',
  styleUrls: ['./homepage.component.scss']
})
export class HomepageComponent implements OnInit, OnDestroy {
  initialized: boolean = false;
  subscription: Subscription | null = null;

  constructor(private web3ModalService: Web3ModalService) { 

  }

  ngOnInit(): void {
    this.loadData();
    this.subscription = interval(Config.main.updateInterval * 1000)
    .pipe(takeWhile(() => this.initialized))
    .subscribe(() => {
      this.loadData();
    });
  }

  ngOnDestroy(): void {
    this.initialized = false;
  }

  walletConnected(): boolean{
    return AppState.walletConnected();
  }

  tokenInstance(): StateToken{
    return AppState.token;
  }

  token(): string{
    if(!AppState.token.isReady())
      return "";
    if(AppState.token.totalSupply == -1)
      this.loadData();
    return AppState.token.name + " (" + AppState.token.symbol + ")"
  }

  private loadData(){
    if(AppState.token.totalSupply == -1)
      AppState.token.updateTotalSupply();
    AppState.token.updateBalance();
    AppState.token.updateBurned();
  }

  presale() : IPresale{
    return AppState.getPresale();
  }
}

