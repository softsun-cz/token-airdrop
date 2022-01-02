import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HomepageComponent } from 'src/pages/homepage/homepage.component';
import { AddressLinkPipe } from 'src/pipe/addressLink.pipe';
import { TransactionLinkPipe } from 'src/pipe/transactionLink.pipe';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

@NgModule({
  declarations: [	
    AppComponent,
    HomepageComponent,
    TransactionLinkPipe,
    AddressLinkPipe
   ],
  imports: [
    BrowserModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
