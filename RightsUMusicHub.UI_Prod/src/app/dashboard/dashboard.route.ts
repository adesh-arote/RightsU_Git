import {DashboardComponent} from './dashboard/dashboard.component';
import {ChangePasswordComponent} from '../ui/change-password/change-password.component';
import { AuthGuardService } from '../auth-guard.service';
import { NotificationListComponent} from '../ui/notification-list/notification-list.component';
import { QuickSelectionComponent } from './quick-selection/quick-selection.component';
export const DashboardRoutes=[
    { path: '', redirectTo: 'Home', pathMatch: 'full' },
    { path: 'Home', component: DashboardComponent },
    
    { path: 'quick-selection', component: QuickSelectionComponent }
        //   { path: 'new-request', component: NewRequestComponent, canActivate: [AuthGuardService]}
]