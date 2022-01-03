import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HomepageComponent } from 'src/pages/homepage/homepage.component';
import { PresaleComponent } from 'src/pages/presale/presale.component';
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
    PresaleComponent,
    TransactionLinkPipe,
    AddressLinkPipe,
    NumberLocalePipe,
    DateTimeLocalePipe
   ],
  imports: [
    BrowserModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
