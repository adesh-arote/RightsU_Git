import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import {FilterPipe,FilterTitlePipe} from '../pipes/filter.pipes';
import { DialogModule } from 'primeng/dialog';
import { ButtonModule } from 'primeng/button';
import { DataTableModule } from 'primeng/datatable';
import { DropdownModule } from 'primeng/dropdown';
import { CartGridComponent } from './cart-grid/cart-grid.component';
import { MessageBoxComponent } from './message-box/message-box.component';
import {TooltipModule} from 'primeng/tooltip';
import { PieChartComponent } from './pie-chart/pie-chart.component';
import { ColumnChartComponent } from './column-chart/column-chart.component';
import {GoogleChartsModule} from 'angular-google-charts'
@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    DialogModule,
    ButtonModule,
    DataTableModule,
    DropdownModule,
    TooltipModule,
    GoogleChartsModule
  ],
  declarations: [CartGridComponent, MessageBoxComponent,FilterPipe,FilterTitlePipe,PieChartComponent, ColumnChartComponent],
  exports:[CartGridComponent, MessageBoxComponent,FilterPipe,FilterTitlePipe,PieChartComponent, ColumnChartComponent],
  // schemas:[CUSTOM_ELEMENTS_SCHEMA,NO_ERRORS_SCHEMA]
})
export class CommonUiModule { }
