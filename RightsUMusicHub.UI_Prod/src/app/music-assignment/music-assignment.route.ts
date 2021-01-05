import {MusicAssignmentComponent} from './music-assignment/music-assignment.component';
import { AuthGuardService } from '../auth-guard.service';
export const MusicAssignmentRoutes=[
    // { path: 'music-assignment', component: MusicAssignmentComponent, canActivate: [AuthGuardService] }
    { path: 'cuesheet', component: MusicAssignmentComponent}
]