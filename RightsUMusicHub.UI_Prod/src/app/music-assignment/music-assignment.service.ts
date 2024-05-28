import { Injectable } from '@angular/core';
import { BaseService } from '../shared/services/base.service';
import { Observable } from 'rxjs';

@Injectable()
export class MusicAssignmentService extends BaseService{

  constructor() { 
    super();
  }


  public uploadFile(fileData: FormData): Observable<any> {
    
    return super.postUpload('CueSheet/UploadCueSheet', fileData);
  }
  public getCueSheetList(cuesheetbody): Observable<any> {
    let body=JSON.stringify(cuesheetbody);
    return super.post('CueSheet/GetCueSheetList', body);
  }
  public getExportCueSheetList(exportcuesheetbody):Observable<any>{
    let body=JSON.stringify(exportcuesheetbody);
    return super.post('CueSheet/ExportCueSheetList',body);
  }
  public DownloadFile():string{
    let dataObj:Object={};
    return super.getBaseUrl()+'/Temp/';
    // (dataObj);

  }
  
  public getCueSheetSongDetails(body:any): Observable<any> {
    let obj=JSON.stringify(body);
    // console.log("Cuesheet");
    // console.log(obj);
    return super.post('CueSheet/GetCueSheetSongDetails', obj);
  }
  public getCueSheetStatus(body:any): Observable<any> {
    let obj=JSON.stringify(body);
    // console.log("Cuesheet");
    // console.log(obj);
    return super.post('CueSheet/GetCueSheetStatus', obj);
  }

  public cuesheetSubmit(body:any): Observable<any> {
    let obj=JSON.stringify(body);
    return super.post('CueSheet/CuesheetSubmit', obj);
  }

  public DownloadCuesheet(body:any): Observable<any> {
    let obj=JSON.stringify(body);
    return super.post('Cuesheet/DownloadCuesheet', obj);
  }

  public DownloadFileNew():string{
    return super.getBaseUrl() + '/Uploads/';  
  }

}
