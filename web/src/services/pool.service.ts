import { Token } from '@angular/compiler/src/ml_parser/lexer';
import { Injectable } from '@angular/core';
import { BigNumber, ethers } from 'ethers';
import { AppState, StateToken } from 'src/appState';
import { Config } from 'src/config';
import { Web3ModalService } from './web3-modal.service';

@Injectable({
  providedIn: 'root'
})
export class PoolService {

  private notLoggedContract : ethers.Contract;
  private contractInterface = [
    "function token () view returns (uint)",
    "function userInfo(address)",
    "function tokensPerBlock () view returns (uint)",
    "function startBlock () view returns (uint)",
    "function deposit (uint256, uint256)",
    "function pools(uint256) view returns (tuple(address tokenDeposit,address tokenEarn,uint256 tokensEarnPerBlock,uint256 lastRewardBlock,uint256 accTokenPerShare,uint256 fee) pool)"
  ];
  private state : PoolServiceState = {
    token: new StateToken("/assets/token.png"),
    pools: []
  }

  public getState() : PoolServiceState{
    return this.state;
  }

  constructor(private web3ModalService: Web3ModalService) {
    this.notLoggedContract = new ethers.Contract(Config.main.addressPool, this.contractInterface, web3ModalService.notLoggedProvider);
    //this.notLoggedContract.token().then((address : BigNumber) => {
    //  this.state.token.initialize(address.toHexString());
    //});    
    this.loadData();
  }

  private getSignedContract() : ethers.Contract{
    if(this.web3ModalService.signer)
      return new ethers.Contract(Config.main.addressPool, this.contractInterface, this.web3ModalService.signer);
    return this.notLoggedContract;
  }

  public loadData() {
    for(var i = 0; i <= 2;i++){
      const that = this;
      const idx = i;
      this.notLoggedContract.pools(idx).then((pool: PoolData) => {
        that.state.pools[idx] = new PoolState(pool);
      });
    }
  }
  
  deposit(poolId: number, amount: number): Promise<ethers.Transaction> {
    const b = BigInt(amount * (10 ** this.state.pools[poolId].tokenDeposit.decimals));
    const bn = BigNumber.from(b);
    console.log("deposit("+ poolId + "," + bn.toString() + ")");
    return this.getSignedContract().deposit(poolId, bn);
  }
}

interface PoolServiceState {
  token: StateToken,
  pools: Array<PoolState>
}

export class PoolState {
  public data: PoolData
  public tokenDeposit : StateToken;
  public tokenEarn : StateToken;
  constructor(poolData: PoolData) {
    this.data = poolData;
    this.tokenDeposit = new StateToken("/assets/token.png", poolData.tokenDeposit);
    this.tokenEarn = new StateToken("/assets/token.png", poolData.tokenEarn);
  }
  public feePercent() : number{
    return this.data.fee.toNumber() / 100;
  }
}

interface PoolData {
  tokenDeposit: string, //address
  tokenEarn: string, //   address :  0x9b6452d8EE8B79605F3F73d04F5f43D7A9Df59A3
  tokensEarnPerBlock: BigNumber, //   uint256 :  200000000000000000
  lastRewardBlock: BigNumber, //   uint256 :  0
  accTokenPerShare: BigNumber, //   uint256 :  0
  fee: BigNumber, //   uint256 :  400
}
