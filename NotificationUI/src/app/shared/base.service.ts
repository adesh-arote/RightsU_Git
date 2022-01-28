
import { Injectable, ReflectiveInjector } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';
import { Observable, throwError } from 'rxjs';
import { map, catchError } from 'rxjs/operators'
import { environment } from 'src/environments/environment';
const AUTH_TOKEN = "AUTH_TOKEN";

@Injectable({
  providedIn: 'root'
})
export abstract class BaseService {

  private requestOptions: any;

  private clientId = 'rightsumusichub';
  private clientSecret = 'secret';
  private scope = 'offline_access';


  constructor(public _router: Router, public http: HttpClient) {
  }

  /**
   * Performs a request with `post` http method.
   * @param service - name of the REST controller service
   * @param body - POST body request (used for creating new entities in service)
   * @returns {Observable<>}
   */
  protected post(service: string, body: any, flag?: string): Observable<any> {
    let headers:  HttpHeaders = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append('Access-Control-Allow-Origin', '*'); 
   // headers = headers.append('AuthKey', 'Bearer ' +  'xVKOCD5ty5HMFm2xbaAWRA==');
    headers = headers.append('AuthKey', 'EalzbkJtZSdV1PydZ9xVzQ==');
    headers = headers.append('Service', 'false'); 
    this.requestOptions = { headers: headers };
    let url = this.getFullUrl(service, flag);
    return this.http.post(url, body, this.requestOptions).pipe(
      map((response) => {
        return response;
      }),
      catchError(this.handleError));
  }


  protected get(service: string, body: any, flag?: string): Observable<any> {
    let headers:  HttpHeaders = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json');
    headers = headers.append('Access-Control-Allow-Origin', '*'); 
    this.requestOptions = { headers: headers };
    let url = this.getFullUrl(service, flag);
    return this.http.get(url, body).pipe(
      map((response) => {
        return response;
      }),
      catchError(this.handleError));
  }


  protected getBaseUrl() {
    return environment.BASE_URL;
  }


  protected getApiUrl(flag?: string) {

      return this.getBaseUrl() + '/api/';
  }

  /**
  * Returns the complete REST service URL
  */
  private getFullUrl(service: string, flag?: string): string {
    return this.getApiUrl(flag) + service;
  }
  
  private handleData(res: Response) {
    let body = res;
    return body;
  }

  protected handleError(error: Response, request?: Observable<any>) {
    // in a real world app, we may send the error to some remote logging infrastructure
    // instead of just logging it to the console
    let msg = '';

    if (error.status) {
      let data: any = error.status;
      msg = data.status;
      if (data) {
        if (data == 1001) {
          msg = '1001';
        }
        else if (data == 1002) {
          msg = '1002';
        }
        else if (data == 1003) {
          msg = '1003';
        }
        else if (data == 1004) {
          msg = '1004';
        }
        else if (data == 1005) {
          msg = '1005';
        }
        else if (data == 403) {
          msg = '403';
        }
        else if (data == 401) {
          msg = '401';
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






}
