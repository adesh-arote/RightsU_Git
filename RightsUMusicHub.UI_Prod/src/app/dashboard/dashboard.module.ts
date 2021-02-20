import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule} from '@angular/router'
import { DashboardComponent } from './dashboard/dashboard.component';
import { InputTextModule } from 'primeng/inputtext';
import { ButtonModule } from 'primeng/button';
import { ChartModule } from 'primeng/chart';
import { PanelModule } from 'primeng/panel';
import { GrowlModule } from 'primeng/growl';
import { CommonUiModule } from '../shared/common-ui/common-ui.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { QuickSelectionComponent } from './quick-selection/quick-selection.component';
import { DialogModule } from 'primeng/dialog';
import { DataTableModule } from 'primeng/datatable';
import { DropdownModule } from 'primeng/dropdown';
import {CalendarModule} from 'primeng/calendar';
import {GalleriaModule} from 'primeng/galleria';
import {FilterPipe} from '../shared/pipes/filter.pipes';
import { ConfirmDialogModule } from 'primeng/confirmdialog';
import {TooltipModule} from 'primeng/tooltip';
import {DataGridModule} from 'primeng/primeng';
import {TabViewModule} from 'primeng/primeng';
import {VarDirective} from '../shared/directives/variable-declartion';
import{DashboardRoutes} from './dashboard.route';
import { SlickCarouselModule } from 'ngx-slick-carousel';
@NgModule({
  imports: [
    CommonModule,
    InputTextModule,
    ButtonModule,
    GrowlModule,
    ChartModule,
    PanelModule,
    CommonUiModule,
    DialogModule,
    ButtonModule,
    DataTableModule,
    // TableModule,
    DropdownModule,
    GalleriaModule,
    ConfirmDialogModule,
    // RadioButtonModule,
    TooltipModule,
    CalendarModule,
    FormsModule,
    DataGridModule,
    TabViewModule,
    SlickCarouselModule,
    RouterModule.forChild(DashboardRoutes)
  ],
  declarations: [DashboardComponent, QuickSelectionComponent,VarDirective
    // ,ChangePasswordComponent,NotificationListComponent,TimeAgoPipe
  ],
  // exports:[FilterPipe]

})
export class DashboardModule { }
