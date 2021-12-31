import { Component, OnDestroy, OnInit } from '@angular/core';
import { interval, Subscription } from 'rxjs';
import { Config } from 'src/config';
import { Web3Service } from 'src/services/web3.service';
import { takeWhile } from 'rxjs/operators';
import Web3 from 'web3';
import { Web3ModalService } from 'src/services/web3-modal.service';
import { AppState } from 'src/appState';

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
  totalClaimed: number = -1;
  tokenAddress: string | null = null;
  constructor( private web3Service: Web3Service, private web3ModalService: Web3ModalService) { 

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

  walletConnected(): boolean{
    return AppState.walletConnected;
  }

  private loadData(){
    this.amountOfTokens = this.remainingTokens = this.totalClaimed = -1;
    this.tokenAddress = null;
    this.web3Service.getTokenAddress().then(value => {
      this.tokenAddress = value;
    });
    this.web3Service.getTotalClaimed().then(value => {
      this.totalClaimed = value;
      ;
    });
    this.web3Service.getAmountOfTokens().then(value => {
      this.amountOfTokens = value;
    });
    this.web3Service.getRemainingTokens().then(value => {
      this.remainingTokens = value;
    });
  }

  connect(){
    this.web3ModalService.web3Modal();
  }
}

