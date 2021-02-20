import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { BaseService } from '../shared/services/base.service';
import { Jsonp } from '@angular/http';

@Injectable()
export class RequisitionService extends BaseService {

  constructor() {
    super();
  }

  public getMusicLabels(musicLabelBody): Observable<any> {
    let body=JSON.stringify(musicLabelBody);
    return super.post('RequisitionModule/GetMusicLabel', body);
  }

  public getShowName(channelCodeBody):Observable<any>{
    // let dataObj:Object={channelCodeBody};
  let body=JSON.stringify(channelCodeBody);
    return super.post('RequisitionModule/GetShowNameList',body);
  }

  public getGenre():Observable<any>{
    let dataObj:Object={};
    return super.post('RequisitionModule/GetGenre',dataObj);
  }
  public GetMusicSongType():Observable<any>{
    let dataObj:Object={};
    return super.post('RequisitionModule/GetMusicSongType ',dataObj);
  }
  public getChannel():Observable<any>{
    let dataObj:Object={};
    return super.post('RequisitionModule/GetChannel',dataObj);
  }
  public save(body:any):Observable<any>{
    let obj=JSON.stringify(body);
    return super.post('RequisitionModule/MusicTitleRequest',obj);
  }

  public getRecommendations(body:any):Observable<any>{
    let obj=JSON.stringify(body);
    return super.post('RequisitionModule/GetMusicTrackList',obj);
  }

  public submitMusicConsumptionRequest(body:any):Observable<any>{
    let obj=JSON.stringify(body);
    return super.post('RequisitionModule/MusicConsumptionRequest',obj);
  }
  public getMusicAlbumLabels(): Observable<any> {
    let dataObj: Object = {};
    return super.post('RequisitionModule/GetMusicAlbum', dataObj);
  }
  public saveMusicRequest(savebody:any):Observable<any>{
    let body=JSON.stringify(savebody);
    return super.post('RequisitionModule/MusicTrackRequest',body);
  }
  public saveAlbumRequest(savebody:any):Observable<any>{
    let body=JSON.stringify(savebody);
    return super.post('RequisitionModule/MusicAlbumRequest',body);
  }
  public getRequestList(consumtionListBody):Observable<any>{
    let body=JSON.stringify(consumtionListBody);
    return super.post('RequisitionModule/GetConsumptionRequestList',body);
  }
  
  public getexportConsumptionList(exportConsumtionListBody):Observable<any>{
    let body=JSON.stringify(exportConsumtionListBody);
    return super.post('RequisitionModule/ExportConsumptionList',body);
  }

  public getExportMovieAlbumMusicList(exportMovieAlbumMusicBody):Observable<any>{
    let body=JSON.stringify(exportMovieAlbumMusicBody);
    return super.post('RequisitionModule/ExportMovieAlbumMusicList',body);
  }
  public DownloadFile():string{
    let dataObj:Object={};
    return super.getBaseUrl()+'/Temp/';
    // (dataObj);

  }
  public GetMovieAlbumMusicList(listbody:any):Observable<any>{
    let body=JSON.stringify(listbody);
    return super.post('RequisitionModule/GetMovieAlbumMusicList',body);
  }

  public getRequestCountDetails(body:any):Observable<any>{
    let obj=JSON.stringify(body);
    return super.post('RequisitionModule/GetConsumptionRequestDetails',obj);
  }
  public GetMusicTrackRequestDetails(musicRequestbody:any):Observable<any>{
    let body=JSON.stringify(musicRequestbody);
    return super.post('RequisitionModule/GetMusicTrackRequestDetails',body);
  }
  public GetMovieAlbumRequestDetails(albumRequestbody:any):Observable<any>{
    let body=JSON.stringify(albumRequestbody);
    return super.post('RequisitionModule/GetMovieAlbumRequestDetails',body);
  }
  public getMusicAlbumTextSearch(musicAlbumSearchBody):Observable<any>{
    let body=JSON.stringify(musicAlbumSearchBody);
    return super.post('RequisitionModule/GetMusicAlbumTextSearch',body);
  }
  public getTalents(singStarCastSearchBody):Observable<any>{
    let body=JSON.stringify(singStarCastSearchBody);
    return super.post('RequisitionModule/GetTalents',body);
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
  public getTitleEpisode(titleEpisode):Observable<any>{
    let body=JSON.stringify(titleEpisode);
    return super.post('RequisitionModule/GetTitleEpisode',body);
  }
  public cueSheetSaveManually(cueSheetBody):Observable<any>{
    let body=JSON.stringify(cueSheetBody);
    return super.post('CueSheet/CueSheetSaveManually',body);
  }
  
  public GetNotificationHeader(obj):Observable<any>{
    let body=JSON.stringify(obj);
    return super.post('RequisitionModule/GetNotificationHeader',obj);
  }

  public ExportConsumptionDetailList(obj):Observable<any>{
    let body=JSON.stringify(obj);
    return super.post('RequisitionModule/ExportConsumptionDetailList',obj);
  }

  public ExportMovieAlbumMusicDetailsList(obj):Observable<any>{
    let body=JSON.stringify(obj);
    return super.post('RequisitionModule/ExportMovieAlbumMusicDetailsList',obj);
  }

  public DeletePlayList(obj):Observable<any>{
    let body=JSON.stringify(obj);
    return super.post('RequisitionModule/DeletePlayList',obj);
  }

}
