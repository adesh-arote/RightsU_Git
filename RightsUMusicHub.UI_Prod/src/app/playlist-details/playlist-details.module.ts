import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {PlaylistDetailsRoutes} from './playlist.route'
import { RouterModule } from '@angular/router';
import { DataTableModule } from 'primeng/datatable';
import {PlaylistDetailsComponent} from '../playlist-details/playlist-details.component';

@NgModule({
  imports: [
    CommonModule,
    DataTableModule,
    RouterModule.forChild(PlaylistDetailsRoutes)
  ],
  declarations: [PlaylistDetailsComponent]
})
export class PlaylistDetailsModule { }
