import { Component } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { Router } from '@angular/router';
import { AppState } from 'src/appState';
import { Config } from 'src/config';
import { Web3ModalService } from 'src/services/web3-modal.service';
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {

  title = 'airdrop';
  actualYear: string = "";
  
  constructor(private router: Router, private Web3ModalService: Web3ModalService, private titleService: Title){
    this.actualYear = new Date().getFullYear().toString();
    this.titleService.setTitle(this.projectName());
  }

  public projectName(): string{
    return Config.main.project;
  }

  public tokenName(): string{
    return AppState.tokenName;
  }

  public tokenSYmbol(): string{
    return AppState.tokenSymbol;
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
}
