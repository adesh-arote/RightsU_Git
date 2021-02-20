import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute, ParamMap, NavigationEnd } from '@angular/router';
import { RequisitionService } from '../../requisition/requisition.service';
import { ComParentChildService } from '../../shared/services/comparentchild.service'
declare var $: any;


const TAB_NAME = "TAB_NAME";
const MHPLAYLIST_CODE = "MHPLAYLIST_CODE";

@Component({
  selector: 'app-quick-selection',
  templateUrl: './quick-selection.component.html',
  styleUrls: ['./quick-selection.component.css'],
  providers: [RequisitionService, ComParentChildService],
})
export class QuickSelectionComponent implements OnInit {
  public newMusicConsumptionRequest;
  public componentData;
  public playListDetail;
  public componentType = "quickSelection"
  public gridvalue;
  public componentLoad: boolean = false;
  public getChannelList;
  public showlistdata;
  public load: boolean = false;
  public mindatevalue;
  public MaxEpisode = 0;
  public MinEpisode = 0;
  public displayalertMessage: Boolean = false;
  public messageData: any;
  public showPlayList: boolean = false;
  public selected: string = "playList";
  public setMHPlaylistCode: any;
  public tabHeaders: string;
  public showdetail: boolean = false;
  public showTabdata: boolean = false;
  public listDetail1: any = [];
  public toplist: any[] = [];
  public newSearchRequest;
  public isDateSame: any;
  public slideConfig:any;
  public showDeletedialog:boolean=false;

  constructor(private _requisitionService: RequisitionService, private router: Router, private comparentchildservice: ComParentChildService) {
    this.mindatevalue = new Date();
    this.router.routeReuseStrategy.shouldReuseRoute = function () {
      return false;
    }

    this.router.events.subscribe((evt) => {
      if (evt instanceof NavigationEnd) {
        // trick the Router into believing it's last link wasn't previously loaded
        this.router.navigated = false;
        // if you need to scroll back to top, here is the right place
        window.scrollTo(0, 0);
      }
    });
  }

  ngOnInit() {
    debugger;

    this.showlistdata = JSON.parse(localStorage.getItem('showData'));
    console.log(this.showlistdata)
    var showValue = {
      "Title_Code": this.showlistdata.Title_Code
    }
    console.log(JSON.stringify(showValue));
    this._requisitionService.getTitleEpisode(showValue).subscribe(response => {
      console.log(response);
      this.MaxEpisode = response.MaxEpisode;
      this.MinEpisode = response.MinEpisode;
    }, error => { this.handleResponseError(error) }
    )
    this.newMusicConsumptionRequest = {
      TitleCode: this.showlistdata,
      EpisodeFrom: '',
      EpisodeTo: '',
      TelecastFrom: '',
      TelecastTo: '',
      Remarks: '',
      ChannelCode: '',
      MHRequestDetails: []
    }
    this.getPlayList();

    // var playlistbody =
    // {
    //   "TitleCode": 0
    // }
    // this.load = true;
    // this.addBlockUI();
    // this._requisitionService.getPlayList(playlistbody).subscribe(response => {
    //   this.load = false;
    //   this.removeBlockUI();
    //   this.playListDetail = response.MHPlayList;
    //   this.listDetail1 = response.MHPlayList;

    //   this.filterlist();
      // $("`"+this.playlistdivid+"`").css("border","1px solid blue")
      this.componentData = {
        "showName": this.showlistdata.Title_Name,
        "titleCode": this.showlistdata.Title_Code,
        'episodeType': this.episodeType,
        "listview": this.playListDetail
      }
      this.componentLoad = true;
      console.log("List body");
      console.log(this.componentData);
      // console.log(this.playListDetail.length);
     
  //  }, error => { this.handleResponseError(error) })
    this.slideConfig = { "slidesToShow": 3, "slidesToScroll": 3 ,"infinite": false};
    this.load = true;
    this.addBlockUI();
    this._requisitionService.getChannel().subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      this.getChannelList = response.Channel;
      // this.getChannelList.unshift({ "Channel_Name": "Please Select", "Channel_Code": 0 });
      // this.newMusicConsumptionRequest.ChannelCode = this.getChannelList[0];


    }, error => { this.handleResponseError(error) })
  }
  public episodeType = 'tentative';
  public episodeNo;
  public episodeDate;
  public showrbtndiv: boolean = true;
  getPlayList() {
    var playlistbody =
    {
      "TitleCode": 0
    }
    this.load = true;
    this.addBlockUI();
    this._requisitionService.getPlayList(playlistbody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      this.playListDetail = response.MHPlayList;
      this.listDetail1 = response.MHPlayList;
      this.gridvalue = this.playListDetail.length == 0 ? '' : this.playListDetail[0];
      this.filterlist();
    }, error => { this.handleResponseError(error) }
    )
  }

  filterlist() {
    this.toplist = []
    for (let i = 0; i < 3 && i < this.listDetail1.length; i++) {
      this.toplist.push(this.listDetail1[i]);
    }

    for (let i = 0; i < 3; i++) {
      this.listDetail1 = this.listDetail1.filter(x => x != this.toplist[i]);

    }

  }

  EpisodeNocheck(val: string) {
    this.episodeType = val;
    this.newMusicConsumptionRequest.EpisodeFrom = '';
    this.newMusicConsumptionRequest.EpisodeTo = '';
    this.newMusicConsumptionRequest.TelecastFrom = '';
    this.newMusicConsumptionRequest.TelecastTo = '';
    this.episodeDate = '';
    this.episodeNo = '';
    if (val == 'tentative') {
      this.showrbtndiv = true;
      this.componentData = {
        "showName": this.showlistdata.Title_Name,
        "titleCode": this.showlistdata.Title_Code,
        'episodeType': val,
        "listview": this.playListDetail
      }
      this.showPlayList = false;
      this.showTabdata = false;
      // this.componentLoad = true;

    }
    else {
      this.showrbtndiv = false;
      this.componentData = {
        "showName": this.showlistdata.Title_Name,
        "titleCode": this.showlistdata.Title_Code,
        'episodeType': val,
        "listview": this.playListDetail
      }
      this.showPlayList = false;
      this.showTabdata = false;
      // this.componentLoad = true;

    }

  }
  public playlistdivid = "0"
  getlist(data, id) {
    console.log("getlist click")
    console.log(data);
    if (this.gridvalue.MHPlayListCode == data.MHPlayListCode) {
      this.comparentchildservice.publish('playlist-grid');
    }
    else {
      this.gridvalue = data;

    }
  }

  getNewList(newListData: any) {
    debugger;
    console.log("event is fired");
    console.log(newListData[newListData.length - 1]);
    $('.your-class').slick('slickAdd', `<div class="info-box" >
    <div id="`+ (newListData.length - 1) + `">
    <span class="info-box-icon bg-aqua"><i class="fa fa-music"></i></span>

    <div class="info-box-content">
      <span class="info-box-text">`+ newListData[newListData.length - 1].PlaylistName + `</span>
      <!-- <span class="info-box-number" ><a  id="btnFavourites">15</a><small></small></span> -->
    </div>
    </div>
  </div>`);
    var self = this;
    $('#' + (newListData.length - 1)).on('click', function () {
      self.getlist(newListData[newListData.length - 1], newListData.length - 1);
    });


  }

  showRecommendations() {
    debugger;
    if (this.episodeType == 'range') {
      let fromdate = this.newMusicConsumptionRequest.TelecastFrom
      let todate = this.newMusicConsumptionRequest.TelecastTo
      if (fromdate > todate) {
        this.displayalertMessage = true;
        this.messageData = {
          'header': "Error",
          'body': "From Date should be Less Than To Date"
        }
      }
      else {
        console.log(JSON.stringify(this.componentData));
        console.log(JSON.stringify(this.newMusicConsumptionRequest));
      }
      if(this.tabHeaders == "PlayList" || this.tabHeaders == undefined){
      this.showPlayList = true;
      this.showTabdata = true;
      this.componentLoad = false;
      }
      else{
        this.componentLoad = true;
        this.showPlayList = false;
        this.showTabdata = true;
      }
    }
    else {
      console.log(JSON.stringify(this.componentData));
      console.log(JSON.stringify(this.newMusicConsumptionRequest));
      if(this.tabHeaders == "PlayList" || this.tabHeaders == undefined){
      this.showPlayList = true;
      this.showTabdata = true;
      this.componentLoad = false;
      }
      else{
        this.componentLoad = true;
        this.showPlayList = false;
        this.showTabdata = true;
      }
    }

  }

  getMusictrackList(data) {
    debugger;
    this.tabHeaders = "PlayList";
    this.setMHPlaylistCode = data.MHPlayListCode;
    sessionStorage.setItem(TAB_NAME, this.tabHeaders);
    sessionStorage.setItem(MHPLAYLIST_CODE, this.setMHPlaylistCode);
    this.componentLoad = true;
    this.componentData = {
      "showName": this.showlistdata.Title_Name,
      "titleCode": this.showlistdata.Title_Code,
      'episodeType': this.episodeType,
      "listview": this.playListDetail
    }
  }

  onTabChange(event) {
    debugger;
    if (event.index == 0) {
      this.tabHeaders = 'PlayList';
      this.showPlayList = true;
      this.showTabdata = true;
      this.componentLoad = false;
      sessionStorage.setItem(TAB_NAME, this.tabHeaders);
      sessionStorage.setItem(MHPLAYLIST_CODE, this.setMHPlaylistCode);
      this.componentData = {
        "showName": this.showlistdata.Title_Name,
        "titleCode": this.showlistdata.Title_Code,
        'episodeType': this.episodeType,
        "listview": this.playListDetail
      }
    }
    else if (event.index == 1) {
      this.showPlayList = false;
      this.tabHeaders = 'PlayListSearch';
      this.showTabdata = true;
      this.componentLoad = true;
      this.setMHPlaylistCode = 0;
      sessionStorage.setItem(TAB_NAME, this.tabHeaders);
      sessionStorage.setItem(MHPLAYLIST_CODE, this.setMHPlaylistCode);
      this.componentData = {
        "showName": this.showlistdata.Title_Name,
        "titleCode": this.showlistdata.Title_Code,
        'episodeType': this.episodeType,
        "listview": this.playListDetail,
        'toplist': this.toplist,
        'listview1': this.listDetail1,
      }
   

    }
  }

  telcastFromDateChnge() {
    debugger;

    let fromdate = new Date(this.newMusicConsumptionRequest.TelecastFrom)
    let todate = new Date(this.newMusicConsumptionRequest.TelecastTo)

    if (fromdate >= todate) {
      this.isDateSame = "Y";
      this.displayalertMessage = true;
      this.messageData = {
        'header': "Error",
        'body': "From Date should be Less Than To Date"
      }
    }
    else {
      this.isDateSame = "N";
    }

  }

  deleteFullPlaylist() {
    this.showDeletedialog = true;
  }

  deletePlaylist(){
    let dataObj = {
      "MHPlayListCode": this.setMHPlaylistCode,
    }
    this._requisitionService.DeletePlayList(dataObj).subscribe(response => {
    let Return = response.Return
    if(Return.IsSuccess == true){
      this.showDeletedialog=false;
      this.getPlayList();
      // this.componentData = {
      //   'showName': this.newMusicConsumptionRequest.TitleCode.Title_Name, 'episodeType': this.episodeType,
      //   'listview': this.listdetail, 'listview1': this.listDetail1, 'toplist': this.toplist
      // }
    }
    }, error => { this.handleResponseError(error) });
  }

  addBlockUI() {
    $('body').addClass("overlay");
    $('body').on("keydown keypress keyup", false);
  }
  removeBlockUI() {
    $('body').removeClass("overlay");
    $('body').off("keydown keypress keyup", false);
  }

  handleResponseError(errorCode) {
    if (errorCode == 403) {
      this.load = false;
      this.removeBlockUI();
      sessionStorage.clear();
      localStorage.clear();
      this.router.navigate(['/login']);
    }
  }
}
