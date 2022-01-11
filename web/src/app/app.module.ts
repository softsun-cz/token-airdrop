import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { CountdownModule } from 'ngx-countdown';
import { AddTokenToWalletComponent } from 'src/component/add-token-to-wallet/add-token-to-wallet.component';
import { LoaderComponent } from 'src/component/loader/loader.component';
import { AirdropComponent } from 'src/pages/airdrop/airdrop.component';
import { HomepageComponent } from 'src/pages/homepage/homepage.component';
import { PresaleComponent } from 'src/pages/presale/presale.component';
import { WhitepaperComponent } from 'src/pages/whitepaper/whitepaper.component';
import { AddressLinkPipe } from 'src/pipe/addressLink.pipe';
import { DateTimeLocalePipe } from 'src/pipe/dateTimeLocale.pipe';
import { NumberLocalePipe } from 'src/pipe/numberLocale.pipe';
import { TransactionLinkPipe } from 'src/pipe/transactionLink.pipe';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

@NgModule({
  declarations: [	
    AppComponent,
    HomepageComponent,
    AirdropComponent,
    PresaleComponent,
    WhitepaperComponent,
    LoaderComponent,
    AddTokenToWalletComponent,
    TransactionLinkPipe,
    AddressLinkPipe,
    NumberLocalePipe,
    DateTimeLocalePipe
   ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    CountdownModule 
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
