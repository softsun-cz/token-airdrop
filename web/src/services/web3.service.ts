import { Injectable } from '@angular/core';
import { Config } from 'src/config';
import Web3 from 'web3';
import BN from 'bn.js';
import { BlockNumber } from 'web3-core';

@Injectable({
  providedIn: 'root'
})
export class Web3Service {
  web3Instance: Web3;
  airdropToken: any;
  taxToken: any;
  maxUint256: string;
  tokenPrices: Array<{price: boolean | BN, address: string}>;
  tokenDecimals: number = 0;
  tokenDecimalsPromise: Promise<number>;

  constructor() { 
    this.tokenPrices = [];
    this.maxUint256 = '115792089237316195423570985008687907853269984665640564039457584007913129639935';
    //this.web3Instance = new Web3(window.ethereum && window.ethereum.networkVersion == Config.main.chainID ? window.ethereum : Config.main.network);
    this.web3Instance = new Web3(Config.main.network);
    this.taxToken = new this.web3Instance.eth.Contract(Config.main.tokenTexAbi, Config.main.addressTokenTax);
    this.tokenDecimalsPromise = this.taxToken.methods.decimals().call();
    this.tokenDecimalsPromise.then((value: number) => {
      this.tokenDecimals = value;
    });

    this.airdropToken = new this.web3Instance.eth.Contract( Config.main.airdropAbi,  Config.main.addressAirdrop);
  }

  private async reduceNumberDecimals(number: number) : Promise<number>{
    await this.tokenDecimalsPromise;
    return number / (10 ** this.tokenDecimals);
  }

  getTokenName() {
    return this.airdropToken.methods.name().call();
   }
  
   getTokenSymbol() {
    return this.airdropToken.methods.symbol().call();
   }
  
   getCurrentBlock() {
    return this.web3Instance.eth.getBlockNumber();
   }
  
   getBlock(number: BlockNumber) {
    return this.web3Instance.eth.getBlock(number);
   }

   async getAmountOfTokens() : Promise<number>{
    return new Promise(async (resolve) => {
      const ret = await this.airdropToken.methods.amountOfTokens().call();
      resolve(this.reduceNumberDecimals(ret));
    });
   }

   async getRemainingTokens() : Promise<number>{
    return new Promise(async (resolve) => {
      const ret = await this.airdropToken.methods.remainingTokens().call();
      resolve(this.reduceNumberDecimals(ret));
    });
   }

   async getTotalClaimed() : Promise<number>{
    return new Promise(async (resolve) => {
      const ret = await this.airdropToken.methods.totalClaimed().call();
      resolve(this.reduceNumberDecimals(ret));
    });
   }

   async getTokenAddress() : Promise<string>{
    return await this.airdropToken.methods.token().call();
   }
}
