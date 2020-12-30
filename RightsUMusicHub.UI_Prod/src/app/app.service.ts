import { Injectable } from '@angular/core';
import {AuthenticationService} from './shared/services/authentication.service'
//Added By Sachin ----------- Start ------
import {Observable,throwError} from 'rxjs';
//Added By Sachin ----------- End ------

@Injectable({
  providedIn: 'root'
})
export class AppService {

  constructor(private _authenticationservice :AuthenticationService) {

   }

   public applogin(username: string, password: string){
     debugger;
     return this._authenticationservice.login(username, password);
   }
   //Added By Sachin ----------- Start ------
   public validateLogin():Observable<any> {
     debugger;
    return this._authenticationservice.validateLogin();
 }
 public changePassword(changePswdBody):Observable<any> {
  debugger;
 return this._authenticationservice.changePassword(changePswdBody);
}

 public GetList():Observable<any> {
  debugger;
 return this._authenticationservice.GetList();
}
 //Added By Sachin ----------- End ------


 public appForgotPassword(forgotBody):Observable<any>{
  return this._authenticationservice.forgotPassword(forgotBody);
}
}
