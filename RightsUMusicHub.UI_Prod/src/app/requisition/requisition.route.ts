import {NewMusicTrackComponent} from './new-music-track/new-music-track.component';
import {NewRequestComponent} from './new-request/new-request.component';
import { AuthGuardService } from '../auth-guard.service';
export const RequsitionRoutes=[
    // {path:'requisition',children:[
        { path: 'new-music-track', component: NewMusicTrackComponent},
        { path: 'new-request', component: NewRequestComponent}
    // ]}
    
]