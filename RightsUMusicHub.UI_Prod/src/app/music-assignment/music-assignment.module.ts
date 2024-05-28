import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MusicAssignmentComponent } from './music-assignment/music-assignment.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { DataTableModule } from 'primeng/datatable';
import { DialogModule } from 'primeng/dialog';
import { BlockUIModule } from 'primeng/blockui';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
import {TooltipModule} from 'primeng/tooltip';
import { ButtonModule } from 'primeng/button';
import {SidebarModule} from 'primeng/sidebar';
import {CalendarModule} from 'primeng/calendar';
import {DropdownModule} from 'primeng/dropdown';
import {MultiSelectModule} from 'primeng/multiselect';
import {CommonUiModule} from '../shared/common-ui/common-ui.module';
import {OverlayPanelModule} from 'primeng/overlaypanel';
import {MusicAssignmentRoutes} from './music-assignment.route'
import { RouterModule } from '@angular/router';
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
    OverlayPanelModule,
    ButtonModule,
    CalendarModule,
    SidebarModule,
    DropdownModule,
    MultiSelectModule,
    CommonUiModule,
    RouterModule.forChild(MusicAssignmentRoutes)
  ],
  declarations: [MusicAssignmentComponent],

})
export class MusicAssignmentModule { }
