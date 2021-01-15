import { Injectable } from '@angular/core';
import {
  BrowserXhr, ConnectionBackend, XHRBackend, Http, Headers, Response, RequestOptions,
  ResponseOptions, BaseRequestOptions, BaseResponseOptions, XSRFStrategy, CookieXSRFStrategy
} from '@angular/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators'
import {BaseService} from './base.service'
@Injectable()
export class AuthenticationService extends BaseService {
  isLoggedIn: boolean;
  redirectUrl: string;// store the URL so we can redirect after logging in
  constructor() {
    super()
   }
   protected get service():string {
    return "";
  }
   public login(username: string, password: string): Observable<Response> {
    debugger;
   
    
    let credentials: Object = { 'UserName': username, 'Password': password };
     return super.login(username,password);
    
}

  public logout(body){
    let obj=JSON.stringify(body);
    console.log("Logout body");
    console.log(obj);
    return super.post('Login/LogoutAccount',obj);
  }
  public releaseAccount(body){
    let obj=JSON.stringify(body);
    console.log("Logout body");
    console.log(obj);
return super.releaseAccount(obj);
    // return super.post('Login/LogoutAccount',obj);
  }
  public getNotificationRequestList(notificationBody){
    let body=JSON.stringify(notificationBody);
    return super.post('Notification/GetNotificationRequestList',body);
  }

  public readNotification(notifyDetailBody){
    let body=JSON.stringify(notifyDetailBody);
    return super.post('Notification/ReadNotification',body);

  }

  public forgotPassword(forgotBody){
    let obj=JSON.stringify(forgotBody);
    return super.forgotPassword(obj);
  }

  public uploadImage(fileData: FormData): Observable<any> {
    return super.postUpload('Login/UploadImage', fileData);
  }

  public GetSystemVersions(dataObj): Observable<any> {
    return super.post('Login/GetSystemVersions', dataObj)
  }
  
}
