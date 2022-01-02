import { Component, OnInit } from '@angular/core';
import { AppState, IPresale } from 'src/appState';
import { Config } from 'src/config';

@Component({
  selector: 'app-presale',
  templateUrl: './presale.component.html',
  styleUrls: ['./presale.component.scss']
})
export class PresaleComponent implements OnInit {

  constructor() { }

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
}
