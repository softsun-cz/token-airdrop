import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomepageComponent } from 'src/pages/homepage/homepage.component';
import { PresaleComponent } from 'src/pages/presale/presale.component';

const routes: Routes = [
  { path: '', component: HomepageComponent },
  { path: 'presale', component: PresaleComponent},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
