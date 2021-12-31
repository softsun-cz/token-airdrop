import { Injectable } from '@angular/core';
import Web3Modal, { IProviderOptions } from "web3modal";
import { Config } from 'src/config';
import Web3 from 'web3';
import WalletConnectProvider from '@walletconnect/web3-provider';
import { AppState } from 'src/appState';

@Injectable({
  providedIn: 'root'
})
export class Web3ModalService {
  web3Proviter: Web3 | null = null
  constructor() { 
    //this.tryConnect();
  }

  tryConnect(){
    const cahckedproviderJson = localStorage.getItem("WEB3_CONNECT_CACHED_PROVIDER");
    if(cahckedproviderJson){
      this.web3Modal();
    }
  }

  private getWeb3ModalConnector(): Web3Modal{
    const INFURA_ID = '460f40a260564ac4a4f4b3fffb032dad'
    const providerOptions : IProviderOptions = {
      walletconnect: {
        package: WalletConnectProvider, // required
        options: {
          infuraId: INFURA_ID, // required
          networkUrl: Config.main.network,
          chainId: Config.main.chainID,
        },
      }
    }
    const web3ModalConnector = new Web3Modal({
      cacheProvider: true, // optional
      providerOptions: providerOptions // required,
    });
    return web3ModalConnector; 
  }

  async web3Modal(){
    const web3ModalConnector = this.getWeb3ModalConnector();
    web3ModalConnector.connect().then(provider => {
      this.initializeProvider(provider);
      this.web3Proviter = new Web3(provider);
      AppState.walletConnected = true;
    }, reason => {
      // rejection
      console.log(reason);
    });
  }

  private initializeProvider(provider: any){
    provider.on("accountsChanged", (accounts: string[]) => {
      console.log(accounts);
    });
    
    // Subscribe to chainId change
    provider.on("chainChanged", (chainId: number) => {
      console.log(chainId);
    });
    
    // Subscribe to provider connection
    provider.on("connect", (info: { chainId: number }) => {
      AppState.walletConnected = true;
    });
    
    // Subscribe to provider disconnection
    provider.on("disconnect", (error: { code: number; message: string }) => {
      this.getWeb3ModalConnector().clearCachedProvider();
      AppState.walletConnected = false;
    });
  }
}
