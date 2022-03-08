import { Injectable } from '@angular/core';
import { BigNumber, ethers } from 'ethers';
import { AppState, StateToken } from 'src/appState';
import { Config } from 'src/config';
import { Web3ModalService } from './web3-modal.service';

@Injectable({
  providedIn: 'root'
})
export class PoolService {
  private notLoggedContract : ethers.Contract | undefined;
  private contractInterface = [
    "function token () view returns (uint)",
    "function userInfo(address)",
    "function tokensPerBlock () view returns (uint)",
    "function startBlock () view returns (uint)",
  ];
  public token = new StateToken("/assets/token.png");

  constructor(web3ModalService: Web3ModalService) {
    this.notLoggedContract = new ethers.Contract(Config.main.addressPool, this.contractInterface, web3ModalService.notLoggedProvider);
    this.notLoggedContract.token().then((address : BigNumber) => {
      this.token.initialize(address.toHexString());
    });    
    
  }
}
