import { Injectable } from '@angular/core';
import { Observable, Observer } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { BaseService } from './base.service';

@Injectable({
  providedIn: 'root'
})
export class NotificationEngineService extends BaseService {

  constructor(public _router: Router,public http: HttpClient) {
    super(_router,http);
  }

  public GetConfiguration(dataObj: any): Observable<any> {
    return super.post('Notification/NEGetConfiguration', dataObj)
  }

  public GetListData(dataObj: any): Observable<any> {
    return super.post('Notification/NEGetMessageStatus', dataObj)
  }

  public GetMasterData(dataObj: any): Observable<any> {
    return super.post('Notification/NEGetMasters', dataObj)
  }

  public saveConfiguration(dataObj: any): Observable<any> {
    return super.post('Notification/NESaveConfiguration', dataObj)
  }

  public resendData(dataObj: any): Observable<any> {
    return super.post('Notification/NEUpdateMessageStatus', dataObj)
  }

}
