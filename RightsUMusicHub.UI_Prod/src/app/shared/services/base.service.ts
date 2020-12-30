import { Injectable, ReflectiveInjector } from '@angular/core';
import {
  BrowserXhr, ConnectionBackend, XHRBackend, Http, Headers, Response, RequestOptions,
  ResponseOptions, BaseRequestOptions, BaseResponseOptions, XSRFStrategy, CookieXSRFStrategy
} from '@angular/http';
// import { Router, ActivatedRoute, ParamMap } from '@angular/router';

//Added By Sachin ----------- Start ------
import { Router } from '@angular/router';
import { Observable, throwError } from 'rxjs';
import { map, catchError } from 'rxjs/operators'
import { environment } from '../../../environments/environment';
const AUTH_TOKEN = "AUTH_TOKEN";
const SESSION_EXPIRE_TIME = "SESSION_EXPIRE_TIME";
const REFRESH_TOKEN = "REFRESH_TOKEN";
const USER_NAME = "USER_NAME";
const EXPIRE_TIME = "EXPIRE_TIME";
const USER_SESSION = "USER_SESSION";
const PAGINATION_COUNT = "PAGINATION_COUNT";

//Added By Sachin ----------- END ------

@Injectable({
  providedIn: 'root'
})
export abstract class BaseService {

  private _http: Http;
  private LoginEndpointURL = 'http://localhost:50422/Api/Login/GetUserLogin'//'http://192.168.0.114/musichubapi/Api/Login/GetUserLogin'


  //Added By Sachin ----------- Start ------
  private requestOptions: RequestOptions = null;

  // private OauthLoginEndPointUrl = 'http://163.182.171.194:8091/connect/token';
  // private OauthLoginRevokeUrl = 'http://163.182.171.194:8091/connect/';
  private OauthLoginEndPointUrl = 'http://localhost:8654/connect/token';
  private OauthLoginRevokeUrl =   'http://localhost:8654/connect/';

  //private OauthLoginEndPointUrl = 'https://spnadsvaluuat.setindia.com:88/connect/token';
  //private OauthLoginRevokeUrl = 'https://spnadsvaluuat.setindia.com:88/connect/revocation';
  private clientId = 'rightsumusichub';
  private clientSecret = 'secret';
  private scope = 'offline_access';


  constructor() {
    //Added By Sachin ----------- END ------

    //let injector: ReflectiveInjector = ReflectiveInjector.resolveAndCreate([
    //  BrowserXhr,
    //  { provide: ResponseOptions, useClass: BaseResponseOptions },
    //  { provide: XSRFStrategy, useFactory: () => new CookieXSRFStrategy() },
    //  { provide: RequestOptions, useClass: BaseRequestOptions },
    //  { provide: ConnectionBackend, useClass: XHRBackend },
    //  Http
    //]);

    this._http = new Http(new XHRBackend(new BrowserXhr(), new BaseResponseOptions(), new CookieXSRFStrategy()), new BaseRequestOptions());


    //Added By Sachin ----------- Start ------
    let headers = new Headers();
    headers.append('Content-Type', 'application/x-www-form-urlencoded');
    if (sessionStorage.getItem("AUTH_TOKEN")) {
      headers.append('Authorization', 'Bearer ' + sessionStorage.getItem("AUTH_TOKEN"));
    }
    this.requestOptions = new RequestOptions({ headers: headers });
    //Added By Sachin ----------- END ------
  }



  //Added By Sachin ----------- Start ------

  /**
   * Performs a request with `post` http method.
   * @param service - name of the REST controller service
   * @param body - POST body request (used for creating new entities in service)
   * @returns {Observable<>}
   */
  protected post(service: string, body: any): Observable<any> {
    debugger;
    let headers = new Headers();
    if (sessionStorage.getItem("AUTH_TOKEN")) {
      headers.append('Authorization', 'Bearer ' + sessionStorage.getItem("AUTH_TOKEN"));
      headers.append('token', 'Bearer ' + sessionStorage.getItem(REFRESH_TOKEN));
      if (sessionStorage.getItem(USER_SESSION)) {
        var user = JSON.parse(sessionStorage.getItem(USER_SESSION));
        console.log(user.Users_Code);
        headers.append('userCode', 'Bearer ' + user.Users_Code);
      }
      headers.append('Content-Type', 'application/json');
    }
    else {
      debugger;
      if (localStorage.getItem('passwordExpire')) {
        headers.append('Content-Type', 'application/json');
      }
      else {
        headers.append('Content-Type', 'application/x-www-form-urlencoded');
      }
    }
    this.requestOptions = new RequestOptions({ headers: headers });
    debugger
    return this._http.post(this.getFullUrl(service), body, this.requestOptions).pipe(
      map((response) => {
        debugger;
        return response.json();
      }),
      catchError(this.handleError));
  }

  protected postUpload(service: string, formData: any): Observable<any> {
    debugger;
    debugger;
    let headers = new Headers();
    if (sessionStorage.getItem("AUTH_TOKEN")) {
      headers.append('Authorization', 'Bearer ' + sessionStorage.getItem("AUTH_TOKEN"));
      headers.append('token', 'Bearer ' + sessionStorage.getItem(REFRESH_TOKEN));
      if (sessionStorage.getItem(USER_SESSION)) {
        var user = JSON.parse(sessionStorage.getItem(USER_SESSION));
        headers.append('userCode', 'Bearer ' + user.Users_Code);
      }
   //   headers.append('Content-Type', 'application/json');
   headers.append('enctype', 'multipart/form-data');
   headers.append('Accept', 'application/json');
    }
    else {
      if (localStorage.getItem('passwordExpire')) {
        headers.append('Content-Type', 'application/json');
      }
      else {
        headers.append('Content-Type', 'application/x-www-form-urlencoded');
      }
    }
    let options = new RequestOptions({ headers: headers });
    return this._http.post(this.getFullUrl(service), formData, options).pipe(map((res) => {
      return res.json()
    }),
    catchError(this.handleError));
  }

  public login(username: string, password: string): Observable<Response> {
    debugger;
    let headers = new Headers();
    headers.append('Content-Type', 'application/x-www-form-urlencoded');
    this.requestOptions = new RequestOptions({ headers: headers });
    let credentials = "client_id=" + this.clientId + "&client_secret=" + this.clientSecret + "&grant_type=password&scope=" + this.scope + "&username=" + username + "&password=" + password;


    let options = new RequestOptions({ headers: headers, withCredentials: true });
    // let credentials: Object = { 'UserName': username, 'Password': password };
    return this._http.post(this.OauthLoginEndPointUrl, credentials, { headers: headers })
      .pipe(
        map(this.handleData),
        catchError(this.handleError));

  }
  protected getBaseUrl() {
    return environment.BASE_URL;
  }
  protected getApiUrl() {
    return this.getBaseUrl() + '/api/';
  }

  /**
  * Returns the complete REST service URL
  */
  private getFullUrl(service: string): string {
    return this.getApiUrl() + service;
  }
  //Added By Sachin ----------- End ------

  private handleData(res: Response) {
    debugger;
    let body = res.json();
    return body;
  }
  //   private handleData(res: Response) {
  //     let body = res.json();
  //     return body;
  // }
  //Added By Sachin ----------- Start ------
  public GetList(): Observable<any> {
    let data: Object = {};
    return this.post('Login/GetUserList', data);
  }
 
  public validateLogin(): Observable<any> {
    debugger;
    let data: Object = { Login_Name: sessionStorage.getItem("USER_NAME") };
    return this.post('Login/GetLoginDetails', data);
    // ._http.post(this.getFullUrl('Login/GetLoginDetails'), '').pipe(
    //    map((response) => {
    //      return response;
    //  }));
  }
  public changePassword(changePasswordBody): Observable<any> {
    debugger;
    let body=JSON.stringify(changePasswordBody)
    return this.post('Login/ChangePassword', body);
    // ._http.post(this.getFullUrl('Login/GetLoginDetails'), '').pipe(
    //    map((response) => {
    //      return response;
    //  }));
  }
  //Added By Sachin ----------- End ------

  //Added By Sachin ----------- Start ------
  //Clear access token
  public clearAccessToken(): Observable<any> {
    let headers = new Headers();
    headers.append('Content-Type', 'application/x-www-form-urlencoded');
    this.requestOptions = new RequestOptions({ headers: headers });
    let authToken = sessionStorage.getItem(AUTH_TOKEN);
    let credentials = "token=" + authToken + "&token_type_hint=access_token&client_id=" + this.clientId + "&client_secret=" + this.clientSecret;
    return this._http.post(this.OauthLoginRevokeUrl, credentials, { headers: headers }).pipe(
      map((Response) => {
      }));
  }

  //Clear refresh token
  public clearRefreshToken(): Observable<any> {
    let headers = new Headers();
    headers.append('Content-Type', 'application/x-www-form-urlencoded');
    this.requestOptions = new RequestOptions({ headers: headers });
    let authToken = sessionStorage.getItem(AUTH_TOKEN);
    let credentials = "token=" + authToken + "&token_type_hint=refresh_token&client_id=" + this.clientId + "&client_secret=" + this.clientSecret;
    return this._http.post(this.OauthLoginRevokeUrl, credentials, { headers: headers }).pipe(
      map((Response) => {
      }));
  }

  //Clear refresh token
  public clearauthToken(authToken): Observable<any> {
    let headers = new Headers();
    headers.append('Content-Type', 'application/x-www-form-urlencoded');
    this.requestOptions = new RequestOptions({ headers: headers });
    //let authToken = sessionStorage.getItem(AUTH_TOKEN);
    let credentials = "token=" + authToken + "&token_type_hint=access_token&client_id=" + this.clientId + "&client_secret=" + this.clientSecret;
    return this._http.post(this.OauthLoginRevokeUrl, credentials, { headers: headers }).pipe(
      map((Response) => {
      }));
  }

  //Clear refresh token
  public clearrefreshToken(refreshtoken): Observable<any> {
    let headers = new Headers();
    headers.append('Content-Type', 'application/x-www-form-urlencoded');
    this.requestOptions = new RequestOptions({ headers: headers });
    //let authToken = sessionStorage.getItem(AUTH_TOKEN);
    let credentials = "token=" + refreshtoken + "&token_type_hint=refresh_token&client_id=" + this.clientId + "&client_secret=" + this.clientSecret;
    return this._http.post(this.OauthLoginRevokeUrl, credentials, { headers: headers }).pipe(
      map((Response) => {
      }));
  }

  //Get refresh token
  public getRefreshToken() {
    let headers = new Headers();
    headers.append('Content-Type', 'application/x-www-form-urlencoded');
    this.requestOptions = new RequestOptions({ headers: headers });
    let credentials = "client_id=" + this.clientId + "&client_secret=" + this.clientSecret + "&grant_type=refresh_token&scope=" + this.scope + "&refresh_token=" + sessionStorage.getItem(REFRESH_TOKEN);
    return this._http.post(this.OauthLoginEndPointUrl, credentials, { headers: headers });
  }



  protected handleError(error: Response, request?: Observable<any>) {
    debugger;
    // in a real world app, we may send the error to some remote logging infrastructure
    // instead of just logging it to the console
    let msg = '';

    if (error.json()) {
      let data = error.json();
      msg = data.error_description;
      // if(data=="SessionExpired"){
      //   // this.router.navigate(['/login']);
      //   return (JSON.stringify('SessionExpired'));
      // }
      // else 
      if (data.error_description) {
        if (data.error_description.includes(1001)) {
          msg = '1001';
        }
        else if (data.error_description.includes(1002)) {
          msg = '1002';
        }
        else if (data.error_description.includes(1003)) {
          msg = '1003';
        }
        else if (data.error_description.includes(1004)) {
          msg = '1004';
        }
        else if (data.error_description.includes(1005)) {
          msg = '1005';
        }
      }
      else {
        switch (error.status) {
          case 200:
            msg = '200';
            break;
          case 401:
            msg = '401';
            break;
          case 404:
            msg = '404';
            break;
          case 500:
            msg = '500';
            break;
          case 403:
            msg = '403';
            break;

        }
      }
    }
    return throwError(msg);
  }

  //Added By Sachin ----------- End ------

  public forgotPassword(forgotbody): Observable<any> {
    let headers = new Headers();
    headers.append('Content-Type', 'application/json');
    this.requestOptions = new RequestOptions({ headers: headers });
    // let authToken = sessionStorage.getItem(AUTH_TOKEN);
    // let credentials = "token=" + authToken + "&token_type_hint=refresh_token&client_id=" + this.clientId + "&client_secret=" + this.clientSecret;
    return this._http.post( this.getFullUrl('Login/ForgotPassword'),forgotbody, { headers: headers }).pipe(
      map((Response) => {
        return Response.json();
      }),
      catchError(this.handleError));
  }
  public releaseAccount(releaseBody):Observable<any>{
    let headers = new Headers();
    headers.append('Content-Type', 'application/json');
    this.requestOptions = new RequestOptions({ headers: headers });
    // let authToken = sessionStorage.getItem(AUTH_TOKEN);
    // let credentials = "token=" + authToken + "&token_type_hint=refresh_token&client_id=" + this.clientId + "&client_secret=" + this.clientSecret;
    return this._http.post( this.getFullUrl('Login/Logout'),releaseBody, { headers: headers }).pipe(
      map((Response) => {
        return Response.json();
      }),
      catchError(this.handleError));
  }
  public Download(body):Observable<any>{
    let headers = new Headers();
    headers.append('Content-Type', 'application/json');
    this.requestOptions = new RequestOptions({ headers: headers });
    // let authToken = sessionStorage.getItem(AUTH_TOKEN);
    // let credentials = "token=" + authToken + "&token_type_hint=refresh_token&client_id=" + this.clientId + "&client_secret=" + this.clientSecret;
    return this._http.post( this.getBaseUrl()+'/Temp/',body, { headers: headers }).pipe(
      map((Response) => {
        return Response.json();
      }),
      catchError(this.handleError));
  }
}
