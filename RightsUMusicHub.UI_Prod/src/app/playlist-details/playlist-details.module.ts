import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PlaylistDetailsRoutes } from './playlist.route'
import { RouterModule } from '@angular/router';
import { DataTableModule } from 'primeng/datatable';
import { DialogModule } from 'primeng/dialog';
import { TooltipModule } from 'primeng/tooltip';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { PlaylistDetailsComponent } from '../playlist-details/playlist-details.component';

@NgModule({
  imports: [
    CommonModule,
    DataTableModule,
    DialogModule,
    TooltipModule,
    FormsModule,
    ReactiveFormsModule,
    RouterModule.forChild(PlaylistDetailsRoutes)
  ],
  declarations: [PlaylistDetailsComponent]
})
export class PlaylistDetailsModule { }
