import { Injectable } from '@angular/core';
import { CanActivate, Router, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { AuthenticationService } from './shared/services/authentication.service';

const AUTH_TOKEN = "AUTH_TOKEN";
const USER_SESSION = "USER_SESSION";


@Injectable()
export class AuthGuardService implements CanActivate{
  
  userPreferences: any =  [];
  
  constructor(private authService: AuthenticationService, private router: Router) {
    //Get User preferences
  
  }

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): boolean {
    let url: string = state.url;
    return this.checkLogin(url);
  }

  checkLogin(url: string): boolean {
    if (sessionStorage.getItem(AUTH_TOKEN) && localStorage.getItem(USER_SESSION)) { //this.authService.isLoggedIn && 
        
      return true; 
    }
    else{
    // Store the attempted URL for redirecting
      this.authService.redirectUrl = url;

    // Navigate to the login page with extras
    this.router.navigate(['/login']);
    return false;
    }

  }

}
