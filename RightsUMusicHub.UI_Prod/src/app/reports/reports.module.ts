import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { DataTableModule } from 'primeng/datatable';
import { DialogModule } from 'primeng/dialog';
import { BlockUIModule } from 'primeng/blockui';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
import {TooltipModule} from 'primeng/tooltip';
import { ButtonModule } from 'primeng/button';
import { AuthorizedMusicComponent } from './authorized-music/authorized-music.component';

import {SidebarModule} from 'primeng/sidebar';
import { MessagesModule } from 'primeng/messages';
import { MessageModule } from 'primeng/message';
import { GrowlModule } from 'primeng/growl';


import { DropdownModule } from 'primeng/dropdown';
import { AutoCompleteModule } from 'primeng/autocomplete';
import { RadioButtonModule } from 'primeng/radiobutton';
import {CalendarModule} from 'primeng/calendar';
import {MultiSelectModule} from 'primeng/multiselect';
import {TieredMenuModule} from 'primeng/tieredmenu';
// import {FilterPipe } from '../shared/pipes/filter.pipes'
import {CommonUiModule} from '../shared/common-ui/common-ui.module';
import { RouterModule } from '@angular/router';
import {ReportRoutes} from './reports.route'
@NgModule({
  imports: [
    CommonModule,
    DataTableModule,
    DialogModule,
    FormsModule,
    ReactiveFormsModule,
    BlockUIModule,
    ProgressSpinnerModule,
    TooltipModule,
    ButtonModule,
    MessagesModule,
    MessageModule,
    GrowlModule,
    DropdownModule,
    AutoCompleteModule,
    RadioButtonModule,
    CalendarModule,
    MultiSelectModule,
    TieredMenuModule,
    CommonUiModule,
    SidebarModule,
    RouterModule.forChild(ReportRoutes)
  ],
  declarations: [AuthorizedMusicComponent]
})
export class ReportsModule { }
