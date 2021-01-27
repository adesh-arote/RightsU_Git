import { Component, OnInit, Input } from '@angular/core';
import { RequisitionService } from '../../../requisition/requisition.service'
import { Router } from '@angular/router';

@Component({
  selector: 'app-common-music-track',
  templateUrl: './common-music-track.component.html',
  styleUrls: ['./common-music-track.component.css']
})
export class CommonMusicTrackComponent implements OnInit {

  public totalMusicDetailCount: number;
  public requestMusicList: any = [];
  public musicReuestHeader;
  public load: boolean = false;
  public dialogRequestDetail: boolean = false;
  public isMusicDetail: boolean = false;
  public isAlbumDetail: boolean = false;
  public musicDetailFilterList: any = [];

  @Input() set musictrackDetails(data) {
    debugger;
    this.requestMusicList = data;
  }

  
  constructor(private _requisitionService: RequisitionService, private router: Router) { }

  ngOnInit() {

  }

  musicRequestDetail(musicRequestedDetail: any) {
    debugger;
    this.musicReuestHeader = "Music Detail for : " + musicRequestedDetail.RequestID;
    this.dialogRequestDetail = true;
    this.isMusicDetail = true;
    this.isAlbumDetail = false;
    let body = {
      'MHRequestCode': musicRequestedDetail.RequestCode
    }
    this.load = true;
    this._requisitionService.GetMusicTrackRequestDetails(body).subscribe(response => {
      this.load = false;
      this.musicDetailFilterList = response.RequestDetails
      this.totalMusicDetailCount = response.RequestDetails.length;
    }, error => { this.handleResponseError(error) });
  }

  close() {
    this.dialogRequestDetail = false;
  }


  handleResponseError(errorCode) {
    if (errorCode == 403) {
      this.load = false;
      sessionStorage.clear();
      localStorage.clear();
      this.router.navigate(['/login']);
    }
  }

}
