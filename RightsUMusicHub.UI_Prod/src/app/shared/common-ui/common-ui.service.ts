import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { BaseService } from '../services/base.service';

import { Jsonp } from '@angular/http';

@Injectable()
export class CommonUiService extends BaseService {

  public getMusicLabels(musicLabelBody): Observable<any> {
    let body=JSON.stringify(musicLabelBody);
    return super.post('RequisitionModule/GetMusicLabel', body);
  }
  public getGenre():Observable<any>{
    let dataObj:Object={};
    return super.post('RequisitionModule/GetGenre',dataObj);
  }
  public getRecommendations(body:any):Observable<any>{
    let obj=JSON.stringify(body);
    return super.post('RequisitionModule/GetMusicTrackList',obj);
  }
  public createPlayList(newplaylist):Observable<any>{
    let body=JSON.stringify(newplaylist);
    return super.post('RequisitionModule/CreatePlayList',body);
  }
  public getPlayList(playlistbody):Observable<any>{
    let body=JSON.stringify(playlistbody);
    return super.post('RequisitionModule/GetPlayList',body);
  }
  public createPlayListSong(createlistsong):Observable<any>{
    let body=JSON.stringify(createlistsong);
    return super.post('RequisitionModule/CreatePlayListSong',body);
  }
  public submitMusicConsumptionRequest(body:any):Observable<any>{
    let obj=JSON.stringify(body);
    return super.post('RequisitionModule/MusicConsumptionRequest',obj);
  }
  public getMusicLanguage(musicLanguage): Observable<any> {
    let obj=JSON.stringify(musicLanguage);
    return super.post('RequisitionModule/GetMusicLanguage', obj);
  }
}
