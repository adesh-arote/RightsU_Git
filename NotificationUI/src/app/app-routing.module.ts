import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';


import { MenuComponent } from './menu/menu.component';

const routes: Routes = [
  {
    path: "",
    redirectTo: "menu",
    pathMatch: "prefix",
  },
  {
    path: "",
    component: MenuComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes, { useHash: true })],
  exports: [RouterModule]
})
export class AppRoutingModule { }
