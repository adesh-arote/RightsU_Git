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
import {GoogleChartsModule} from 'angular-google-charts';
import { MessagesModule } from 'primeng/messages';
import { RadioButtonModule } from 'primeng/radiobutton';
import { CommonMusicTrackComponent } from './common-music-track/common-music-track.component';
import { CommonMovieAlbumComponent } from './common-movie-album/common-movie-album.component';
import { CommonMusicAssignmentComponent } from './common-music-assignment/common-music-assignment.component';
import {ContextMenuModule} from 'primeng/primeng';
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
    GoogleChartsModule,
    RadioButtonModule,
    MessagesModule,
    ContextMenuModule
    
  ],
  declarations: [CartGridComponent, MessageBoxComponent,FilterPipe,FilterTitlePipe,PieChartComponent, ColumnChartComponent, CommonMusicTrackComponent, CommonMovieAlbumComponent, CommonMusicAssignmentComponent],
  exports:[CartGridComponent, MessageBoxComponent,FilterPipe,FilterTitlePipe,PieChartComponent, ColumnChartComponent,CommonMusicTrackComponent,CommonMovieAlbumComponent,CommonMusicAssignmentComponent],
  // schemas:[CUSTOM_ELEMENTS_SCHEMA,NO_ERRORS_SCHEMA]
})
export class CommonUiModule { }
