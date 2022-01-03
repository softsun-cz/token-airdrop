import { Component, OnInit } from '@angular/core';
import { AppState, IPresale } from 'src/appState';
import { Config } from 'src/config';
import { Web3ModalService } from 'src/services/web3-modal.service';

@Component({
  selector: 'app-presale',
  templateUrl: './presale.component.html',
  styleUrls: ['./presale.component.scss']
})
export class PresaleComponent implements OnInit {

  constructor(private web3ModalSevice: Web3ModalService) { }

  ngOnInit() {
  }

  presale() : IPresale{
    return AppState.getPresale();
  }

  presaleContractAddress(): string{
    return Config.main.addressPresale;
  }

  ourToken(): string{
    if(this.presale().tokenOur.name == "" || this.presale().tokenOur.symbol == "")
      return "";
    return this.presale().tokenOur.name + " (" + this.presale().tokenOur.symbol + ")"
  }

  theirToken(): string{
    if(this.presale().tokenTheir.name == "" || this.presale().tokenTheir.symbol == "")
      return "";
    return this.presale().tokenTheir.name + " (" + this.presale().tokenTheir.symbol + ")"
  }

  walletAddress(): string{
    return AppState.selectedAddress == null ? "" : AppState.selectedAddress;
  }

  checkClaimed(address: string){
    this.web3ModalSevice.presaleClaimed(address).then(value => {
      alert("Claimed: " + value + " "+ AppState.presale.tokenOur.symbol);
    });
  }

  checkDeposited(address: string){
    this.web3ModalSevice.presaleDeposited(address).then(value => {
      alert("Deposited: " + value + " "+ AppState.presale.tokenTheir.symbol);
    });
  }
}
