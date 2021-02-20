import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { AuthGuardService } from './auth-guard.service';

import { DashboardComponent } from './dashboard/dashboard/dashboard.component';
import { AppFrameComponent } from './app.component'
import { LoginComponent } from './login/login.component'
import { NewRequestComponent } from './requisition/new-request/new-request.component'
import { NewMusicTrackComponent } from './requisition/new-music-track/new-music-track.component'
import { MusicAssignmentComponent } from './music-assignment/music-assignment/music-assignment.component'
import { AuthorizedMusicComponent } from './reports/authorized-music/authorized-music.component';
import { QuickSelectionComponent } from './dashboard/quick-selection/quick-selection.component';
import {NotificationListComponent} from'./ui/notification-list/notification-list.component';
import {ChangePasswordComponent} from './ui/change-password/change-password.component';
const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  // { path:'app',loadChildren:'../app/dashboard/dashboard.module#DashboardModule'},
  
  // ,
  {
    path: 'app', component: AppFrameComponent,
    children: [
      { path:'dashboard',loadChildren:'../app/dashboard/dashboard.module#DashboardModule', canActivate: [AuthGuardService]},   
      { path: 'requisition',loadChildren:"../app/requisition/requisition.module#RequisitionModule", canActivate: [AuthGuardService]},
     {path:'music-assignment',loadChildren:"./music-assignment/music-assignment.module#MusicAssignmentModule", canActivate: [AuthGuardService]} ,
     {path:'reports',loadChildren:'./reports/reports.module#ReportsModule', canActivate: [AuthGuardService]}   ,
     { path:'changepswd',component:ChangePasswordComponent, canActivate: [AuthGuardService]  },
    {path:'notification-list',component:NotificationListComponent, canActivate: [AuthGuardService]},
    {path:'playlist-details',loadChildren:"./playlist-details/playlist-details.module#PlaylistDetailsModule", canActivate: [AuthGuardService]} ,
    ]
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes, { useHash: true})],
  exports: [RouterModule]
})


export class AppRoutingModule {

}
