import { Component } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { Router } from '@angular/router';
import { AppState } from 'src/appState';
import { Config } from 'src/config';
import { Web3Service } from 'src/services/web3.service';
import WalletConnectSDK from 'walletconnect';
import Web3 from "web3";

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {

  title = 'airdrop';
  actualYear: string = "";
  
  constructor(private router: Router, private web3Service: Web3Service, private titleService: Title){
    this.actualYear = new Date().getFullYear().toString();
    this.titleService.setTitle(this.projectName());
    //this.web3Modal();
    //this.connectToWallet();
  }

  public projectName(): string{
    return Config.main.project;
  }

  public goToHomepage(event: any){
    this.router.navigateByUrl("");
    event.preventDefault();
  }

  public mobileMenuVisible() : boolean{
    return AppState.mobileMenuVisible;
  }
  
  public toogleMobileMenuVisible(){
    AppState.mobileMenuVisible = !AppState.mobileMenuVisible;
  }
  

  async web3Modal(){

    const providerOptions = {
      walletconnect: {
        options: {
          infuraId: "27e484dcd9e3efcfd25a83a78777cdf1",
          qrcodeModalOptions: {
            mobileLinks: [
              "rainbow",
              "metamask",
              "argent",
              "trust",
              "imtoken",
              "pillar",
            ],
            desktopLinks: [
              "encrypted ink",
            ]
          }
        }
      }
    };
    
  }

  async connectToWallet(){
    //  Create WalletConnect SDK instance
    const wc = new WalletConnectSDK();

    //  Connect session (triggers QR Code modal)
    const connector = await wc.connect();

    //  Get your desired provider

    const web3Provider = await wc.getWeb3Provider({
      infuraId: "<INSERT_INFURA_APP_ID>",
    });

    const channelProvider = await wc.getChannelProvider();

    const starkwareProvider = await wc.getStarkwareProvider({
      contractAddress: "<INSERT_CONTRACT_ADDRESS>",
    });

    const threeIdProvider = await wc.getThreeIdProvider();
  }
}
