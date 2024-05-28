import { BrowserModule } from '@angular/platform-browser';
import { NgModule,CUSTOM_ELEMENTS_SCHEMA,NO_ERRORS_SCHEMA } from '@angular/core';
import { HttpModule } from '@angular/http'
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { AuthGuardService } from './auth-guard.service';

import { DashboardModule } from './dashboard/dashboard.module';
import { RequisitionModule } from './requisition/requisition.module';
import { CommonUiModule } from './shared/common-ui/common-ui.module';
import { MusicAssignmentModule } from './music-assignment/music-assignment.module';
import { ReportsModule } from './reports/reports.module';
import { AppComponent, AppFrameComponent } from './app.component';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { HeaderComponent } from './ui/header/header.component';
import { SidebarComponent } from './ui/sidebar/sidebar.component';
import { AppRoutingModule } from './/app-routing.module';
import { LoginComponent } from './login/login.component';
import { InputTextModule } from 'primeng/inputtext';
import { ButtonModule } from 'primeng/button';
import { ChartModule } from 'primeng/chart';
import { PanelModule } from 'primeng/panel';
import { GrowlModule } from 'primeng/growl';
import { MessagesModule } from 'primeng/messages';
import { MessageModule } from 'primeng/message';
import {DialogModule} from 'primeng/dialog';
import { ConfirmDialogModule } from 'primeng/confirmdialog';
import { NotificationListComponent } from './ui/notification-list/notification-list.component';
import { DataTableModule } from 'primeng/datatable';
import {TableModule} from 'primeng/table';
import {TimeAgoPipe} from 'time-ago-pipe';
import { ChangePasswordComponent } from './ui/change-password/change-password.component';

@NgModule({
  declarations: [
    AppComponent,
    AppFrameComponent,
    HeaderComponent,
    SidebarComponent,
    LoginComponent,
    NotificationListComponent,
    TimeAgoPipe,
    ChangePasswordComponent

  ],
  imports: [
    BrowserModule,
    NgbModule.forRoot(),
    // DashboardModule,
    TableModule,
    // RequisitionModule,
    CommonUiModule,
    AppRoutingModule,
    FormsModule,
    HttpModule,
    ReactiveFormsModule,
    InputTextModule,
    ButtonModule,
    DataTableModule,
    GrowlModule,
    ChartModule,
    PanelModule,
    BrowserAnimationsModule,
    MessagesModule,
    MessageModule,
    DialogModule,
    ConfirmDialogModule,
    MusicAssignmentModule,
    ReportsModule

  ],
  providers: [AuthGuardService],
  bootstrap: [AppComponent]
})
export class AppModule { }
