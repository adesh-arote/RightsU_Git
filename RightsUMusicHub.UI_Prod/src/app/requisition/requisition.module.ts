import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NewMusicTrackComponent } from './new-music-track/new-music-track.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NewRequestComponent } from './new-request/new-request.component'
import { MessagesModule } from 'primeng/messages';
import { MessageModule } from 'primeng/message';
import { GrowlModule } from 'primeng/growl';
import {SidebarModule} from 'primeng/sidebar';
import { DialogModule } from 'primeng/dialog';
import { ButtonModule } from 'primeng/button';
import { DataTableModule } from 'primeng/datatable';
import { DropdownModule } from 'primeng/dropdown';
import { AutoCompleteModule } from 'primeng/autocomplete';
import { RadioButtonModule } from 'primeng/radiobutton';
import {CalendarModule} from 'primeng/calendar';
import {MultiSelectModule} from 'primeng/multiselect';
import {TieredMenuModule} from 'primeng/tieredmenu';
import {OverlayPanelModule} from 'primeng/overlaypanel';
import {TooltipModule} from 'primeng/tooltip';
import {CheckboxModule} from 'primeng/checkbox';
// import {FilterPipe } from '../shared/pipes/filter.pipes'
import {CommonUiModule} from '../shared/common-ui/common-ui.module';
import {RequsitionRoutes} from './requisition.route';
import { RouterModule } from '@angular/router';
// import { SlimScroll } from 'angular-io-slimscroll';
@NgModule({
  imports: [
    CommonModule,
    CommonUiModule,
    FormsModule,
    GrowlModule,
    CheckboxModule,
    OverlayPanelModule,
    MessagesModule,
    MessageModule,
    DialogModule,
    ButtonModule,
    DataTableModule,
    DropdownModule,
    TooltipModule,
    AutoCompleteModule,
    RadioButtonModule,
    CalendarModule,
    MultiSelectModule,
    TieredMenuModule,
    SidebarModule,
    RouterModule.forChild(RequsitionRoutes)
  ],
  declarations: [NewMusicTrackComponent, NewRequestComponent,
    // FilterPipe
    // ,SlimScroll
  ],
  exports: [NewMusicTrackComponent]
})
export class RequisitionModule { }
