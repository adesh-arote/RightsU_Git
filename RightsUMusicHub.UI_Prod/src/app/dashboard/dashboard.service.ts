import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { BaseService } from '../shared/services/base.service';
@Injectable()
export class DashboardService extends BaseService{

  constructor() {
    super();
   }

  public getRequestList(body:any):Observable<any>{
    let dataObj=JSON.stringify(body);
    return super.post('RequisitionModule/GetConsumptionRequestList',dataObj);
  }
  
  public checkPlayList(body:any):Observable<any>{
    let dataObj=JSON.stringify(body);
    return super.post('RequisitionModule/CheckPlayList',dataObj);
  }

  public getPieChartData(pieChartBody):Observable<any>{
    // let dataObj:Object={};
    let body=JSON.stringify(pieChartBody);
    return super.post('Dashboard/GetPieChartData',body);
  }

  public getBarChartData(barChartBody):Observable<any>{
    // let dataObj:Object={};
    let body=JSON.stringify(barChartBody);
    return super.post('Dashboard/GetBarChartData',body);
  }
  

  public getLabelWiseUsage(body:any):Observable<any>{
    let dataObj=JSON.stringify(body);
    return super.post('Dashboard/GetLabelWiseUsage',dataObj);
  }
}
