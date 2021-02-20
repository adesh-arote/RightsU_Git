import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { RequisitionService } from '../requisition/requisition.service'

@Component({
  selector: 'app-playlist-details',
  templateUrl: './playlist-details.component.html',
  styleUrls: ['./playlist-details.component.css'],
  providers: [RequisitionService]
})
export class PlaylistDetailsComponent implements OnInit {

  public load: boolean = false;
  public playList: any = [];

  constructor(private _requisitionService: RequisitionService, private router: Router) { }

  ngOnInit() {
    this.getPlayList();
  }

  getPlayList() {
    var playlistbody =
    {
      "TitleCode": 0
    }
    this.load = true;
    this._requisitionService.getPlayList(playlistbody).subscribe(response => {
      this.load = false;
      this.playList = response.MHPlayList;
    }, error => { this.handleResponseError(error) }
    )
  }

  handleResponseError(errorCode) {
    this.load = false;
    if (errorCode == 403) {
      sessionStorage.clear();
      localStorage.clear();
      this.router.navigate(['/login']);
    }
  }

}
