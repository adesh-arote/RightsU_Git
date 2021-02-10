import { Component, OnInit, Input } from '@angular/core';
import { RequisitionService } from '../../../requisition/requisition.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-common-movie-album',
  templateUrl: './common-movie-album.component.html',
  styleUrls: ['./common-movie-album.component.css']
})
export class CommonMovieAlbumComponent implements OnInit {

  public requestAlbumList: any = [];
  public isMusicDetail: boolean = false;
  public isAlbumDetail: boolean = false;
  public musicReuestHeader;
  public load: boolean = false;
  public dialogRequestDetail: boolean = false;
  public albumDetailFilterList: any = [];
  public totalAlbumDetailCount: number;

  @Input() set moviealbumDetails(data) {
    debugger;
    this.requestAlbumList = data;
  }

  constructor(private _requisitionService: RequisitionService, private router: Router) { }


  ngOnInit() { }

  albumRequestDetail(albumRequestedDetail: any) {
    debugger;
    this.isMusicDetail = false;
    this.isAlbumDetail = true;
    this.musicReuestHeader = "Movie / Album Detail for : " + albumRequestedDetail.RequestID;
    this.dialogRequestDetail = true;
    let body = {
      'MHRequestCode': albumRequestedDetail.RequestCode
    }
    this.load = true;
    this._requisitionService.GetMovieAlbumRequestDetails(body).subscribe(response => {
      this.load = false;
      this.albumDetailFilterList = response.RequestDetails;
      this.totalAlbumDetailCount = response.RequestDetails.length;
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
