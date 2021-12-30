import { Component, OnDestroy, OnInit } from '@angular/core';
import { interval, Subscription } from 'rxjs';
import { Config } from 'src/config';
import { Web3Service } from 'src/services/web3.service';
import { takeWhile } from 'rxjs/operators';

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
  constructor( private web3Service: Web3Service) { 

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

  private loadData(){
    this.amountOfTokens = this.remainingTokens = this.totalClaimed = -1;
    this.tokenAddress = null;
    this.web3Service.getTokenAddress().then(value => {
      this.tokenAddress = value;
    });
    this.web3Service.getTotalClaimed().then(value => {
      this.totalClaimed = this.web3Service.reduceNumberDecimals(value);
      ;
    });
    this.web3Service.getAmountOfTokens().then(value => {
      this.amountOfTokens = this.web3Service.reduceNumberDecimals(value);
    });
    this.web3Service.getRemainingTokens().then(value => {
      this.remainingTokens = this.web3Service.reduceNumberDecimals(value);
    });
  }
}

