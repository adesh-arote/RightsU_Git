import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute, ParamMap, NavigationEnd } from '@angular/router';
import { RequisitionService } from '../../requisition/requisition.service';
import {ComParentChildService} from '../../shared/services/comparentchild.service'
declare var $: any;
@Component({
  selector: 'app-quick-selection',
  templateUrl: './quick-selection.component.html',
  styleUrls: ['./quick-selection.component.css'],
  providers: [RequisitionService,ComParentChildService],
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
  public MaxEpisode=0;
  public MinEpisode=0;
  constructor(private _requisitionService: RequisitionService, private router: Router,private comparentchildservice: ComParentChildService) {
    this.mindatevalue=new Date();
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

    this.showlistdata = JSON.parse(localStorage.getItem('showData'));
    console.log(this.showlistdata)
    var showValue = {
      "Title_Code": this.showlistdata.Title_Code
    }
    console.log(JSON.stringify(showValue));
    this._requisitionService.getTitleEpisode(showValue).subscribe(response => {
      console.log(response);
      this.MaxEpisode=response.MaxEpisode;
      this.MinEpisode=response.MinEpisode;
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
    var playlistbody =
      {
        "TitleCode": this.showlistdata.Title_Code
      }
    this.load = true;
    this.addBlockUI();
    this._requisitionService.getPlayList(playlistbody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      this.playListDetail = response.MHPlayList;
      $(document).ready(function () {
        $('.your-class ').slick({
          slidesToShow: 3,
          slidesToScroll: 3,
          arrows: true,
          infinite:false,
          prevArrow: $('.slick-prev'),
          nextArrow: $('.slick-next'),          
        });
      });
      // $("`"+this.playlistdivid+"`").css("border","1px solid blue")
      this.componentData = {
        "showName": this.showlistdata.Title_Name,
        "titleCode": this.showlistdata.Title_Code,
        'episodeType':this.episodeType,
        "listview": this.playListDetail
      }
      this.componentLoad = true;
      console.log("List body");
      console.log(this.componentData);
      console.log(this.playListDetail.length);
      this.gridvalue = this.playListDetail.length==0?'':this.playListDetail[0];
    }, error => { this.handleResponseError(error) })

    this.load = true;
    this.addBlockUI();
    this._requisitionService.getChannel().subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      this.getChannelList = response.Channel;
      this.getChannelList.unshift({ "Channel_Name": "Please Select", "Channel_Code": 0 });
      this.newMusicConsumptionRequest.ChannelCode = this.getChannelList[0];


    }, error => { this.handleResponseError(error) })
  }
  public episodeType = 'tentative';
    public episodeNo;
  public episodeDate;
  public showrbtndiv: boolean = true;

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
        'episodeType':val,
        "listview": this.playListDetail
      }
      // this.componentLoad = true;
      
    }
    else {
      this.showrbtndiv = false;
      this.componentData = {
        "showName": this.showlistdata.Title_Name,
        "titleCode": this.showlistdata.Title_Code,
        'episodeType':val,
        "listview": this.playListDetail
      }
      // this.componentLoad = true;
      
    }

  }
  public playlistdivid="0"
  getlist(data,id) {
    console.log("getlist click")
    console.log(data);
   if(this.gridvalue.MHPlayListCode==data.MHPlayListCode){
    this.comparentchildservice.publish('playlist-grid');
   }
   else{
    this.gridvalue = data;

   }
  }

  getNewList(newListData: any) {
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
      self.getlist(newListData[newListData.length - 1],newListData.length - 1);
    });


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
    if (errorCode == 403 ) {
      this.load = false;
      this.removeBlockUI();
    sessionStorage.clear();
    localStorage.clear();
      this.router.navigate(['/login']);
    }
  }
}
