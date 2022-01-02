import { Injectable } from '@angular/core';
import Web3Modal, { IProviderOptions } from "web3modal";
import { Config } from 'src/config';
import { BigNumber, Contract, ethers, providers, Signer } from 'ethers'
import WalletConnectProvider from '@walletconnect/web3-provider';
import { AppState } from 'src/appState';
import { Web3Provider, JsonRpcProvider } from '@ethersproject/providers';

@Injectable({
  providedIn: 'root'
})
export class Web3ModalService {
  web3Provider: Web3Provider | null = null
  signer: Signer | null = null
  airdropContract: Contract | null = null;

  notLoggedProvider: JsonRpcProvider
  airdropNotLoggedContract: Contract;
  taxTokenNotLoggedContract: Contract | null = null;

  tokenDecimals: number = 0;
  tokenDecimalsPromise: Promise<boolean>;

  constructor() {
    this.notLoggedProvider = new JsonRpcProvider(Config.main.network);
    this.airdropNotLoggedContract = new ethers.Contract(Config.main.addressAirdrop, Config.main.airdropContractInterface, this.notLoggedProvider);

    this.tokenDecimalsPromise = new Promise(async (resolve) => {
      this.airdropNotLoggedContract.token().then(async (value: BigNumber) => {
        AppState.addressToken = value.toHexString();
        this.taxTokenNotLoggedContract = new ethers.Contract( AppState.addressToken , Config.main.tokenTaxContractInterface, this.notLoggedProvider);
        this.taxTokenNotLoggedContract.name().then((value: string) => {
          AppState.tokenName = value;
        });
        this.taxTokenNotLoggedContract.symbol().then((value: string) => {
          AppState.tokenSymbol = value;
        });
        const decimals: BigNumber = await this.taxTokenNotLoggedContract.decimals();
        this.tokenDecimals = decimals.toNumber();
        resolve(true);
      });
    });
    this.tryConnect();
  }

  
  private async reduceNumberDecimals(number: BigNumber) : Promise<number>{
    await this.tokenDecimalsPromise;
    return Number(number.toBigInt()) / (10 ** this.tokenDecimals);
  }


  tryConnect(){
    const cahckedproviderJson = localStorage.getItem("WEB3_CONNECT_CACHED_PROVIDER");
    if(cahckedproviderJson){
      this.web3Modal();
    }
  }

  private getWeb3ModalConnector(): Web3Modal{
    const INFURA_ID = 'c22c90a767684c5fbd7257da57802b35'
    const providerOptions : IProviderOptions = {
      walletconnect: {
        package: WalletConnectProvider, // required
        options: {
          infuraId: INFURA_ID,
          rpc: {
            137: 'https://rpc-mainnet.matic.quiknode.pro',
            80001: 'https://matic-mumbai.chainstacklabs.com'
          }
        },
      }
    }
    const web3ModalConnector = new Web3Modal({
      //network: "matic",
      cacheProvider: true, // optional
      providerOptions: providerOptions // required,
    });
    return web3ModalConnector; 
  }

  web3Modal(){
    const web3ModalConnector = this.getWeb3ModalConnector();
    web3ModalConnector.connect().then(provider => {
      this.initializeProvider(provider);

      this.web3Provider = new providers.Web3Provider(provider)
      this.signer = this.web3Provider.getSigner()
      this.airdropContract = new ethers.Contract(Config.main.addressAirdrop, Config.main.airdropContractInterface, this.signer);
      let network : ethers.providers.Network;
      
      const networkPromise = this.web3Provider?.getNetwork().then( value => {
        network = value;
      });

      this.signer?.getAddress().then( async address => {
        await networkPromise;
        AppState.selectedAddress = address;  
        AppState.chainId = network.chainId;
        if(AppState.chainId == Config.main.chainID){     
          this.airdropNotLoggedContract.addressReceived(AppState.selectedAddress).then((value: boolean) => {
            AppState.airdropRecieved = value;
          });
        }
      });
    }, reason => {
      console.log(reason);
    });
  }

  airdrop(): Promise<ethers.Transaction> {
    return this.airdropContract?.airdrop();
  }


  private getWalletAddress(provider: any) : string{
    console.log(provider);
    provider.enable()
    if(provider.accounts && provider.accounts.length > 0)
      return provider.accounts[0];
    if(provider.selectedAddress)
      return provider.selectedAddress;
    return "UnknownAddress";
  }

  private initializeProvider(provider: any){
    provider.on("accountsChanged", (accounts: string[]) => {
      console.log("accountsChanged");
      console.log(accounts);
      AppState.selectedAddress = this.getWalletAddress(provider);
    });
    
    // Subscribe to chainId change
    provider.on("chainChanged", (chainId: number) => {
      location.reload();
    });
    
    // Subscribe to provider connection
    provider.on("connect", (info: { chainId: number }) => {
      console.log("connect" + info.chainId);
      AppState.selectedAddress = this.getWalletAddress(provider);
    });
    
    // Subscribe to provider disconnection
    provider.on("disconnect", (error: { code: number; message: string }) => {
      this.getWeb3ModalConnector().clearCachedProvider();
      AppState.selectedAddress = null;
      AppState.chainId = null;
      AppState.airdropRecieved = null;
      this.airdropContract = null
    });
  }
  
   getCurrentBlock():  Promise<Number> {
    return this.notLoggedProvider.getBlockNumber();
   }
  
   async getAmountOfTokens() : Promise<number>{
    return new Promise(async (resolve) => {
      const ret: BigNumber = await this.airdropNotLoggedContract.amountOfTokens();
      resolve(this.reduceNumberDecimals(ret));
    });
   }

   async getRemainingTokens() : Promise<number>{
    return new Promise(async (resolve) => {
      const ret: BigNumber  = await this.airdropNotLoggedContract.remainingTokens();
      resolve(this.reduceNumberDecimals(ret));
    });
   }

   async getTotalClaimed() : Promise<number>{
    return new Promise(async (resolve) => {
      const ret: BigNumber  = await this.airdropNotLoggedContract.totalClaimed();
      resolve(this.reduceNumberDecimals(ret));
    });
   }

   async getAirdropsCount() : Promise<number>
   {
    return new Promise(async (resolve) => {
      const ret: BigNumber = await this.airdropNotLoggedContract.airdropsCount();
      resolve(ret.toNumber());
    });
   }



}
