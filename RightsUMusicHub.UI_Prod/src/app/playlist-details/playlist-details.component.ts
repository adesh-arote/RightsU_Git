import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { RequisitionService } from '../requisition/requisition.service';
import { CommonUiService } from '../shared/common-ui/common-ui.service'

const MHPLAYLIST_CODE = "MHPLAYLIST_CODE";
@Component({
  selector: 'app-playlist-details',
  templateUrl: './playlist-details.component.html',
  styleUrls: ['./playlist-details.component.css'],
  providers: [RequisitionService, CommonUiService]
})
export class PlaylistDetailsComponent implements OnInit {

  public load: boolean = false;
  public showplaylistDetails: boolean = false;
  public showFullplaylistdialog: boolean = false;
  public showUpdatebutton: boolean = false;
  public showDeletedialog: boolean = false;
  public deleterowdata: boolean = false;
  public playList: any = [];
  public sortBy: any;
  public order: any;
  public searchList: any = [];
  public MHPlayListSongCode: any;
  public setMHPlaylistCode: any;
  public playListname: any;
  public sortF: any;
  public sortO: any;
  public indexValue: any;
  public searchText: string;


  constructor(private _requisitionService: RequisitionService, private router: Router, private _CommonUiService: CommonUiService) { }

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

  vieweditPlaylist(data, action, index) {
    debugger;
    this.showplaylistDetails = true;
    this.searchList = [];
    this.sortBy = "MusicTrack";
    this.order = "ASC";
    this.sortO = "";
    this.sortF = "";
    this.searchText = "";
    this.indexValue = index;
    this.playListname = data.PlaylistName;
    this.setMHPlaylistCode = data.MHPlayListCode;
    if (this.deleterowdata == false) {
      sessionStorage.setItem(MHPLAYLIST_CODE, this.setMHPlaylistCode);
    }
    if (action == 'edit' && this.deleterowdata == false) {
      this.showUpdatebutton = true;
    }
    else if (action == 'edit' && this.deleterowdata == true) {
      this.setMHPlaylistCode = data;
    }
    else {
      this.showUpdatebutton = false;
    }
    this.load = true;
    var body = {
      'MusicLabelCode': '',
      'MusicTrack': '',
      'MovieName': '',
      'GenreCode': 0,
      'TalentName': '',
      'Tag': '',
      'MHPlayListCode': this.setMHPlaylistCode,
      'PaginRequired': 'N',
      'PageSize': '25',
      'PageNo': '1',
      'ChannelCode': '',
      'TitleCode': '',
      'MusicLanguageCode': '',
      "SortBy": this.sortBy,
      "Order": this.order
    }
    this._CommonUiService.getRecommendations(body).subscribe(response => {
      this.load = false;
      this.searchList = response.Show;
    }, error => { this.handleResponseError(error) });
  }

  updatePlaylist() {
    debugger;
    this.playListname;
    let dataObj = {
      "MHPlayListCode": this.setMHPlaylistCode,
      "PlaylistName": this.playListname
    }
    this._requisitionService.UpdatePlaylist(dataObj).subscribe(response => {
      this.showplaylistDetails = false;
      this.getPlayList();
    }, error => { this.handleResponseError(error) });

  }

  changeSort(event) {
    debugger;
    this.sortF = event.field;
    this.sortO = event.order
  }

  deleteFullPlaylist(data) {
    debugger;
    this.showFullplaylistdialog = true;
    this.setMHPlaylistCode = data.MHPlayListCode;
  }

  deletePlaylist() {
    let dataObj = {
      "MHPlayListCode": this.setMHPlaylistCode,
    }
    this._requisitionService.DeletePlayList(dataObj).subscribe(response => {
      let Return = response.Return
      if (Return.IsSuccess == true) {
        this.showFullplaylistdialog = false;
        this.getPlayList();
      }
    }, error => { this.handleResponseError(error) });
  }

  onRowSelect(event) {
    debugger;
    if (this.showUpdatebutton == true) {
      this.showDeletedialog = true;
      this.MHPlayListSongCode = event.data.MHPlayListSongCode;
      return false
    }
  }

  deletePlayListSong() {
    debugger;
    this.setMHPlaylistCode = JSON.parse(sessionStorage.getItem('MHPLAYLIST_CODE'));
    this.deleterowdata = true;
    let dataObj = {
      "MHPlayListCode": this.setMHPlaylistCode,
      "MHPlayListSong": [
        {
          "MHPlayListSongCode": this.MHPlayListSongCode
        }
      ]
    }
    this._CommonUiService.DeletePlayListSong(dataObj).subscribe(response => {
      let Return = response.Return
      if (Return.IsSuccess == true) {
        this.showDeletedialog = false;
        this.vieweditPlaylist(this.setMHPlaylistCode, 'edit', "");
      }
    }, error => { this.handleResponseError(error) });

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
