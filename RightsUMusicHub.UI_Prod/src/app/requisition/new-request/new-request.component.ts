import { Component, OnInit, Renderer2, ElementRef, ViewChild } from '@angular/core';
import { RequisitionService } from '../requisition.service'
import { Router, ActivatedRoute, ParamMap, NavigationEnd } from '@angular/router';
import { Subject } from 'rxjs';
import { DatePipe } from '@angular/common';
import { Message } from 'primeng/components/common/api';
import { MenuItem } from 'primeng/api';
import { parse } from 'querystring';
import { debug } from 'util';
import { CommonUiService } from '../../shared/common-ui/common-ui.service';
// import { Timestamp } from 'rxjs/internal/operators/timestamp';
declare var $: any;


const IS_FROMNEWREQ = "IS_FROMNEWREQ";
const TAB_NAME = "TAB_NAME";
const MHPLAYLIST_CODE = "MHPLAYLIST_CODE";
const SEARCHED_GRID = "SEARCHED_GRID";
const NEWREQ_DATA = "NEWREQ_DATA";

@Component({
  selector: 'app-new-request',
  templateUrl: './new-request.component.html',
  styleUrls: ['./new-request.component.css'],
  providers: [RequisitionService, CommonUiService]
})

export class NewRequestComponent implements OnInit {
  // public songType:boolean=true;
  public visibleSidebar2: boolean = false;
  public songTypeList;
  public remarksCueSheet: any;
  public textCueSheetRemarkCount = 0;
  public shows: any[];
  public playlist: any[];
  items: MenuItem[];
  public componentData: any;
  public messageData: any;
  public componentType = "consumption";
  public RbtnTE: string = 'TEN';
  public isTentEpN: boolean = true;
  public isshow: boolean;
  public Genre: any[];
  public musiclbel: any[];
  public Taglist: any[];
  public showrbtndiv: boolean = true;
  public showdetail: boolean = false;
  public musicLabelList;
  public showNameList: any = [];
  public getGenreList;
  public getChannelList;
  public newSearchRequest;
  //public IsCueSheet;

  public newMusicConsumptionRequest;

  public requestList: any = [];

  public showName;
  public episodeNo;
  public episodeDate;
  public episodeType = 'tentative';
  // public msgs = "Successfull";
  msgs: Message[] = [];
  public showMsg: boolean = false;
  public showRequestCountDetails: boolean = false;
  public requestCountList = [];

  public alertErrorMessage;
  public displayMessage: boolean = false;
  public displayalertMessage: Boolean = false;
  public displaysubmitalertMessage: boolean = false;

  public listdetail: any[] = [];
  public listDetail1: any[] = [];
  public Reqcount = 0;

  public toplist: any[] = [];
  public load: boolean = false;
  public mindatevalue;
  public recordCount;
  public showSearch: boolean = false;
  public Status: any = [];
  public searchStatus: any = [];
  public searchFromDate;
  public searchToDate;
  public searchRequestId;
  public exportPageSize = 10;
  public exportPageNo = 1;
  public quickSelReq: any;
  public quickSelChannelCode: any;
  defaultDate: Date = new Date('Thu Aug 30 2018 00:00:00 GMT+0530 (India Standard Time)');
  todaydate: Date = new Date();
  public termsTextFirst: string;
  public termsTextSecond: string;
  public productionHouseName;
  public order: any;
  public sortBy: any;
  public isRequestListclick: boolean = false;
  public RemarkSpecialInstruction: any = [];
  public remarksLabel: any;
  public specialRemarks: any;
  public isViewallclicked: boolean = false;
  public isNewrequest: boolean = false;
  public isDateSame: any;
  public setDuration: boolean = false;
  public showPlayList: boolean = false;
  public selected: string = "playList";
  public setMHPlaylistCode: any;
  public setMHPlaylistName: any;
  public tabHeaders: string;
  public showTabdata: boolean = false;
  public checkTabheader: any;
  public slideConfig: any;
  public showDeletedialog: boolean = false;
  public languageList: any = [];
  public sortingDefault: boolean = false;
  public searchList: any = [];
  public searchedTrack:boolean=false;


  constructor(private renderer: Renderer2, private elRef: ElementRef, private _requisitionService: RequisitionService, private router: Router, private _CommonUiService: CommonUiService) {
    this.mindatevalue = new Date();

    this.Status = [
      { label: 'Approved', value: '1' },
      { label: 'Pending', value: '2' },
      { label: 'Rejected', value: '3' },
      { label: 'Partially Approved', value: '4' }

    ];
    // console.log(this.mindatevalue);
    this.timer = setInterval(() => { this.dateCheck() }, 2000);

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
  public timeStamp;
  public timer;

  dateCheck() {
    this.todaydate = new Date();
    this.timeStamp = this.todaydate.getTime();
  }
  ngOnDestroy() {
    if (this.timer) {
      clearInterval(this.timer)
      this.isViewallclicked = false;
    }
  }
  public vendorShortName;
  ngOnInit() {
    debugger;
    this.isViewallclicked = JSON.parse(localStorage.getItem('VIEW_ALL_REQUEST'));
    if (this.isViewallclicked == false) {
      this.isNewrequest = true;
    }
    else {
      this.isNewrequest = false;
      this.showSearch = true;
    }
    this.sortingDefault = true;
    // alert(this.todaydate.getTime())
    // var a:Timestamp=new Timestamp();


    this.vendorShortName = JSON.parse(sessionStorage.getItem('USER_SESSION'));
    console.log(this.vendorShortName.VendorShortName);
    this.quickSelReq = localStorage.getItem('quickSelreq');
    console.log("Requesting");
    console.log(this.quickSelReq);
    this.quickSelChannelCode = localStorage.getItem('quickChannelCode')

    this.newMusicConsumptionRequest = {
      TitleCode: 0,
      EpisodeFrom: "",
      EpisodeTo: "",
      TelecastFrom: "",
      TelecastTo: "",
      Remarks: "",
      ChannelCode: "",
      MHRequestDetails: []
    }
    this.newSearchRequest = {
      MusicLabelCode: 0,
      MusicTrack: "",
      MovieName: "",
      GenreCode: 0,
      TalentName: "",
      Tag: ""
    }
    this.load = true;
    this.getPlayList();
    this.getMusicLanguage();
    this.getMusicLabel();
    this.slideConfig = { "slidesToShow": 3, "slidesToScroll": 3, "infinite": false };
    this.addBlockUI();


    this._requisitionService.GetMusicSongType().subscribe(response => {
      console.log("Song Type......!!!!1");
      console.log(response);
      this.songTypeList = response.SongType;
    })

    if (this.quickSelReq == 'Y') {
      var showdata = localStorage.getItem('showData')
      this.load = true;
      this.addBlockUI();
      this._requisitionService.getChannel().subscribe(response => {
        this.load = false;
        this.removeBlockUI();
        console.log("response of channel");
        console.log(response);
        this.getChannelList = response.Channel;
        var ChannelObj = this.getChannelList.filter(x => x.Channel_Code == this.quickSelChannelCode)
        // this.getChannelList.unshift({ "Channel_Name": "Please select", "Channel_Code": 0 });
        console.log(ChannelObj);
        if (ChannelObj.length == 0) {
          this.newMusicConsumptionRequest.ChannelCode = this.getChannelList[0];
        }
        else {
          this.newMusicConsumptionRequest.ChannelCode = ChannelObj[0];
        }



        this.load = true;
        this.addBlockUI();
        var channelBody = {
          'Channel_Code': this.newMusicConsumptionRequest.ChannelCode.Channel_Code == null ? '0' : this.newMusicConsumptionRequest.ChannelCode.Channel_Code
        }
        console.log("Show body Quick selection..!")
        console.log(channelBody);
        this._requisitionService.getShowName(channelBody).subscribe(response => {
          this.load = false;
          this.removeBlockUI();
          this.showNameList = response.Show;
          console.log("Show data");
          console.log(JSON.parse(showdata));
          console.log(this.showNameList);
          //this.showNameList.unshift({ "Title_Name": "Please Select", "Title_Code": 0 });
          // this.newMusicConsumptionRequest.TitleCode = ""JSON.parse(showdata)"";
          this.showChange();
          localStorage.setItem('quickSelreq', 'N');

        }, error => { this.handleResponseError(error) }
        );

      }, error => { this.handleResponseError(error) }
      )
    }
    else {
      this.load = true;
      this.addBlockUI();
      this._requisitionService.getChannel().subscribe(response => {
        this.load = false;
        this.removeBlockUI();
        console.log("response of channel");
        console.log(response.Channel)
        this.getChannelList = response.Channel;
        // this.getChannelList.unshift({ "Channel_Name": "Please select", "Channel_Code": 0 });
        this.newMusicConsumptionRequest.ChannelCode = this.getChannelList[0];


        this.load = true;
        this.addBlockUI();
        var channelBody = {
          'Channel_Code': this.newMusicConsumptionRequest.ChannelCode.Channel_Code == null ? '0' : this.newMusicConsumptionRequest.ChannelCode.Channel_Code
        }
        console.log("Show body");
        console.log(channelBody);
        this._requisitionService.getShowName(channelBody).subscribe(response => {
          this.load = false;
          this.removeBlockUI();
          this.showNameList = response.Show;
          //this.showNameList.unshift({ "Title_Name": "Please Select", "Title_Code": 0 });
          ///this.newMusicConsumptionRequest.TitleCode = this.showNameList[0];
        }, error => { this.handleResponseError(error) }
        );

      }, error => { this.handleResponseError(error) }
      )
    }



    this.load = true;
    this.addBlockUI();
    this._requisitionService.getGenre().subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      this.getGenreList = response.Music;
      this.getGenreList.unshift({ "Genres_Name": "Genres", "Genres_Code": 0 });
      this.newSearchRequest.GenreCode = this.getGenreList[0];
    }, error => { this.handleResponseError(error) }
    );
    var channelBody = {
      'Channel_Code': ''
    }

    console.log(JSON.stringify(channelBody));
    this.load = true;
    this.addBlockUI();
    this._requisitionService.getShowName(channelBody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      console.log(response);
      this.searchshowNameList = response.Show;
      // this.showNameList.unshift({ "Title_Name": "Please select", "Title_Code": 0 });
      // this.searchshowName.TitleCode = this.searchshowNameList[0];
    },
      error => { this.handleResponseError(error) });
    // this.getRequestList();

  }

  Requestlistclick() {
    debugger;
    if (this.Reqcount == 0) {
      this.isRequestListclick = true;
      this.isNewrequest = false;
      this.getRequestList(10, 1);
      this.Reqcount++;
    }
    this.showSearch = true;

  }
  newRequestClick() {
    this.showSearch = false;
  }


  ChangeRbtn() {
    if (this.RbtnTE == 'TEN') {
      this.isTentEpN = true;
    }
    else {
      this.isTentEpN = false;
    }
  }
  show() {
    this.isshow = true;
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
      this.showdetail = false;
      this.showPlayList = false;
      this.showTabdata = false;
    }
    else {
      this.showrbtndiv = false;
      this.showdetail = false;
      this.showPlayList = false;
      this.showTabdata = false;

    }

  }

  showRecommendations() {
    debugger;
    this.tabHeaders = "PlayList";
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
        // this.showName = this.newMusicConsumptionRequest.TitleCode.Title_Name;
        // this.componentData = {
        //   'showName': this.newMusicConsumptionRequest.TitleCode.Title_Name, 'episodeType': this.episodeType,
        //   'listview': this.listdetail, 'listview1': this.listDetail1, 'toplist': this.toplist
        // }
        console.log(JSON.stringify(this.componentData));
        console.log(JSON.stringify(this.newMusicConsumptionRequest));
        // this.showdetail = false;
        // this.showPlayList = true;
      }
      if (this.tabHeaders == "PlayList" || this.tabHeaders == undefined) {
        this.showdetail = false;
        this.showPlayList = true;
        this.showTabdata = true;

      }
      else {
        this.showdetail = true;
        this.showPlayList = false;
        this.showTabdata = true;
      }
      // if(this.tabHeaders == "PlayList"){
      // $(document).ready(function () {
      //   $('#your-class').slick({
      //     infinite: true,
      //     slidesToShow: 3,
      //     slidesToScroll: 3,
      //     arrows: true,
      //     prevArrow: $('.slick-prev'),
      //     nextArrow: $('.slick-next'),
      //   });
      // });
      //}
    }
    else {
      // this.showName = this.newMusicConsumptionRequest.TitleCode.Title_Name;
      // this.componentData = {
      //   'showName': this.newMusicConsumptionRequest.TitleCode.Title_Name, 'episodeType': this.episodeType,
      //   'listview': this.listdetail, 'listview1': this.listDetail1, 'toplist': this.toplist
      // }
      console.log(JSON.stringify(this.componentData));
      console.log(JSON.stringify(this.newMusicConsumptionRequest));
      if (this.tabHeaders == "PlayList" || this.tabHeaders == undefined) {
        this.showdetail = false;
        this.showPlayList = true;
        this.showTabdata = true;
      }
      else {
        this.showdetail = true;
        this.showPlayList = false;
        this.showTabdata = true;
      }
      // if(this.tabHeaders == "PlayList"){
      // $(document).ready(function () {
      //   $('#your-class').slick({
      //     infinite: true,
      //     slidesToShow: 3,
      //     slidesToScroll: 3,
      //     arrows: true,
      //     prevArrow: $('.slick-prev'),
      //     nextArrow: $('.slick-next'),
      //   });
      // });
    }
  }
  // public TotalRecords;



  // playlistclick(i)
  // {
  //   debugger;
  //   // alert(i);
  //   // $('#plylidtid'+i).removeClass('active');
  //    $('#plylidtid'+i).toggle('active');
  //   // alert('#plylidtid'+i)
  //   // $('#plylidtid'+i).style('display','block');
  // }


  episodeRangeToChange() {
    this.msgs = [];
    debugger;
    if (parseInt(this.newMusicConsumptionRequest.EpisodeTo) <= parseInt(this.newMusicConsumptionRequest.EpisodeFrom)) {
      this.newMusicConsumptionRequest.EpisodeTo = parseInt(this.newMusicConsumptionRequest.EpisodeFrom) + 1
      this.showMsg = true;
      this.msgs.push({ severity: 'error', summary: '', detail: 'Episode To should greater than Episode From' });

    }
  }
  episodeFromDateChange() {
    let fromdate = new Date(this.newMusicConsumptionRequest.TelecastFrom);
    debugger;
    if (this.newMusicConsumptionRequest.TelecastTo == '') {
      let obj1 = new Date(fromdate.setDate(fromdate.getDate() + 1));
      this.newMusicConsumptionRequest.TelecastTo = obj1;
    }
    else {
      let obj1 = new Date(fromdate.setDate(fromdate.getDate() + 1));
      this.newMusicConsumptionRequest.TelecastTo = obj1;
    }

  }
  episodeToDateChange() {
    // let fromdate=new Date()
  }
  telcastFromDateChnge() {
    debugger;
    //if (this.newMusicConsumptionRequest.TelecastFrom == null) {
    //  this.newMusicConsumptionRequest.TelecastTo = '';

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
  public requestCountFilteredList: any;

  filter(listFilter) {
    var datePipe = new DatePipe('en-GB');
    //console.log(JSON.stringify(listFilter));
    debugger;

    this.requestCountFilteredList = this.requestCountList.filter(item => (item.RequestedMusicTitle.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.MusicMovieAlbum.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.LabelName.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.IsApprove.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      // || datePipe.transform(item.RequestDate.toString(), 'dd-MMM-yyyy').toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      // || item.AdvertiserNAme.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      // || item.Startdate.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      // || item.Enddate.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
    )
    );

  }
  getRequestList(pageSize, PageNo) {
    debugger;
    this.exportPageNo = PageNo;
    this.exportPageSize = pageSize;
    this.load = true;
    this.addBlockUI();
    var consumtionListBody;
    if (this.isRequestListclick == true) {
      this.sortBy = "RequestDate";
      this.order = "DESC";
    }
    else {
      this.sortBy = this.sortBy;
      this.order = this.order;
    }
    if (this.searchClickevent == 'N') {
      this.first = 0;
      consumtionListBody = {
        "RecordFor": "L",
        "PagingRequired": "Y",
        "PageSize": pageSize,
        "PageNo": PageNo,
        "RequestID": '',
        "ChannelCode": '',
        "ShowCode": '',
        "StatusCode": '',
        "FromDate": '',
        "ToDate": '',
        "SortBy": this.sortBy,
        "Order": this.order
      }
    }
    else if (this.searchClickevent == 'Y') {
      // this.first=0;
      consumtionListBody = {
        "RecordFor": "L",
        "PagingRequired": "Y",
        "PageSize": pageSize,
        "PageNo": PageNo,
        "RequestID": this.searchconsumtionListBody.RequestID,
        "ChannelCode": this.searchconsumtionListBody.ChannelCode,
        "ShowCode": this.searchconsumtionListBody.ShowCode,
        "StatusCode": this.searchconsumtionListBody.StatusCode,
        "FromDate": this.searchconsumtionListBody.FromDate,
        "ToDate": this.searchconsumtionListBody.ToDate,
        "SortBy": this.sortBy,
        "Order": this.order
      }
      // consumtionListBody=this.searchconsumtionListBody;
    }
    console.log(JSON.stringify(consumtionListBody));
    this._requisitionService.getRequestList(consumtionListBody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      console.log("Request list");
      console.log(response);
      if (response.Return.IsSuccess == true) {
        this.recordCount = response.RecordCount
        this.requestList = response.RequestList;
        this.isRequestListclick = false;
        this.cueSheetHeader = false
        this.requestList.forEach(x => x.cueSheet = false);
        console.log(this.requestList);
      }

    }, error => { this.handleResponseError(error) }
    );
  }
  public requestCountHeader: any;
  public totalCountOfNoOfSongsDetails = 0;
  public requestCountSearch;
  requestCountDetails(rowdata, IsCueSheet) {
    debugger;
    this.requestCountSearch = null;
    this.load = true;
    this.addBlockUI();
    this._requisitionService.getRequestCountDetails({ MHRequestCode: rowdata.RequestCode, IsCueSheet: IsCueSheet }).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      this.requestCountList = response.RequestDetails;
      this.requestCountFilteredList = response.RequestDetails;
      this.totalCountOfNoOfSongsDetails = response.RequestDetails.length;
      this.RemarkSpecialInstruction = response.RemarkSpecialInstruction;
      this.remarksLabel = this.RemarkSpecialInstruction.Remarks;
      this.specialRemarks = this.RemarkSpecialInstruction.SpecialInstructions;
      this.showRequestCountDetails = true;
      this.requestCountHeader = rowdata.RequestID + ' / ' + rowdata.ChannelName + ' / ' + rowdata.Title_Name + ' ( ' + (rowdata.EpisodeFrom == rowdata.EpisodeTo ? rowdata.EpisodeFrom : rowdata.EpisodeFrom + ' To ' + rowdata.EpisodeTo) + ' )'
      this.newSearchRequest = {
        MusicLabelCode: 0,
        MusicTrack: "",
        MovieName: "",
        GenreCode: 0,
        TalentName: "",
        Tag: ""
      }
      // this.cartListCount = 0;
    }, error => { this.handleResponseError(error) }
    );
  }
  close() {
    this.showRequestCountDetails = false;
  }

  episodeChange() {


    // if(this.episodeType !='range'){
    //   if(this.episodeNo>0)
    //   {if(this.episodeNo>25){
    //     this.episodeNo=1;
    //     alert("value should be less than 25")}
    //   }
    // }
    // else{
    //   if(this.newMusicConsumptionRequest.EpisodeFrom>0){
    //     if(this.newMusicConsumptionRequest.EpisodeFrom>25){
    //       alert("Episode from should less than 25")

    //     }
    //   }

    // }

  }

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

      this.listdetail = response.MHPlayList;
      this.listDetail1 = response.MHPlayList;



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
  channelChange() {
    debugger;
    if (this.showdetail == true) {
      this.showdetail = false;
      this.showPlayList = false;
      this.showTabdata = false;
      // this.cartList = [];
      // this.cartListCount = 0;
    }
    var channelBody = {
      'Channel_Code': this.newMusicConsumptionRequest.ChannelCode.Channel_Code
    }
    console.log(JSON.stringify(channelBody));
    this.load = true;
    this.addBlockUI();
    this._requisitionService.getShowName(channelBody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      console.log(response);
      this.showNameList = response.Show;
      //this.showNameList.unshift({ "Title_Name": "Please Select", "Title_Code": 0 });
      if (this.channelChange.length > 0) {
        this.newMusicConsumptionRequest.TitleCode = this.showNameList[0];
      }
    }, error => { this.handleResponseError(error) }
    )
  }
  public MaxEpisode = 0;
  public MinEpisode = 0;
  showChange() {
    debugger;
    // this.getPlayList();
    if (this.episodeType == 'tentative') {
      this.episodeNo = 0;
      this.newMusicConsumptionRequest.EpisodeFrom = 0;
      this.newMusicConsumptionRequest.EpisodeTo = 0;
      this.showdetail = false;
      this.showPlayList = false;
      this.showTabdata = false;
    }
    else if (this.episodeType == 'range') {
      this.newMusicConsumptionRequest.EpisodeFrom = 0;
      this.newMusicConsumptionRequest.EpisodeTo = 0;
      this.showdetail = false;
      this.showPlayList = false;
      this.showTabdata = false;

    }
    if (this.showdetail == true) {
      this.showdetail = false;
      // this.cartList = [];
      // this.cartListCount = 0;
    }
    var showValue = {
      "Title_Code": this.newMusicConsumptionRequest.TitleCode.Title_Code
    }
    console.log(JSON.stringify(showValue));
    this._requisitionService.getTitleEpisode(showValue).subscribe(response => {
      console.log(response);
      this.MaxEpisode = response.MaxEpisode;
      this.MinEpisode = response.MinEpisode;
    }, error => { this.handleResponseError(error) }
    )
  }


  addBlockUI() {
    $('body').addClass("overlay");
    $('body').on("keydown keypress keyup", false);
  }
  removeBlockUI() {
    $('body').removeClass("overlay");
    $('body').off("keydown keypress keyup", false);
  }
  public rowonpage = 10;
  public first = 0;

  requestListValidation() {
    debugger;
    console.log(this.cueSheetReqList.length);
    if (this.cueSheetReqList.length == 0) {
      this.requestList.forEach(x => x.cueSheet = false);
    }
    else {
      for (let i = 0; i < this.requestList.length; i++) {
        for (let j = 0; j < this.cueSheetReqList.length; j++) {
          if (this.requestList[i].RequestCode == this.cueSheetReqList[j].RequestCode) {
            this.requestList[i].cueSheet = true;
          }
          else {
            if (this.requestList[i].cueSheet == false || this.requestList[i].cueSheet == null) {
              this.requestList[i].cueSheet = false;
            }
          }
        }
      }
    }
  }

  loadDataOnPagination(event) {
    // this.cueSheetReqList=[];
    // console.log("checklist Count");
    this.cueSheetHeader = false;
    debugger;
    var pageNo = event.first;
    var pageSize = event.rows;
    var sortBy = event.sortField;
    this.sortBy = sortBy;
    if (event.sortField == undefined) {
      this.sortBy = "RequestDate";
      event.sortOrder = -1;
    }
    else {
      this.sortBy = this.sortBy;
    }
    if (event.sortOrder == 1) {
      this.order = "ASC";
    }
    else {
      this.order = "DESC";
    }
    if (this.rowonpage != pageSize) {
      this.rowonpage = pageSize;
      if (event.first == 0) {
        this.onpagechange(pageSize, pageNo);
      }
      else {
        this.first = 0;
      }

    }
    else {
      this.first = event.first;
      if (event.first == 0) {
        pageNo = event.first + 1;
        this.onpagechange(pageSize, pageNo);
      }
      else {
        pageNo = (event.first / event.rows) + 1;
        this.onpagechange(pageSize, pageNo);
      }

    }

  }
  onpagechange(pageSize, pageNo) {
    debugger;
    this.exportPageSize = pageSize;
    this.exportPageNo = pageNo;
    // this.recordCount=0;
    this.load = true;
    this.addBlockUI();
    var consumtionListBody;
    if (this.searchClickevent == 'N') {
      consumtionListBody = {
        "RecordFor": "L",
        "PagingRequired": "Y",
        "PageSize": pageSize,
        "PageNo": pageNo,
        "RequestID": "",
        "ChannelCode": '',
        "ShowCode": '',
        "StatusCode": '',
        "FromDate": "",
        "ToDate": "",
        "SortBy": this.sortBy,
        "Order": this.order
      }
    }
    else if (this.searchClickevent == 'Y') {
      consumtionListBody = {
        "RecordFor": "L",
        "PagingRequired": "Y",
        "PageSize": pageSize,
        "PageNo": pageNo,
        "RequestID": this.searchconsumtionListBody.RequestID,
        "ChannelCode": this.searchconsumtionListBody.ChannelCode,
        "ShowCode": this.searchconsumtionListBody.ShowCode,
        "StatusCode": this.searchconsumtionListBody.StatusCode,
        "FromDate": this.searchconsumtionListBody.FromDate,
        "ToDate": this.searchconsumtionListBody.ToDate,
        "SortBy": this.sortBy,
        "Order": this.order
      }
    }

    this._requisitionService.getRequestList(consumtionListBody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      console.log("Request list");
      console.log(response);
      this.recordCount = response.RecordCount
      this.requestList = response.RequestList;
      this.isRequestListclick = false;
      console.log(this.requestList);
      this.requestListValidation();

    }, error => { this.handleResponseError(error) }
    );

  }

  public searchChannel: any = [];
  public searchshowNameList;
  public searchshowName: any = [];
  // advance search method
  searchChannelChange() {
    debugger;
    var channelcode = [];
    for (let i = 0; i < this.searchChannel.length; i++) {
      channelcode.push(this.searchChannel[i].Channel_Code);
    }
    console.log(channelcode);
    var channelBody = {
      'Channel_Code': channelcode.toString()
    }

    console.log(JSON.stringify(channelBody));
    this.load = true;
    this.addBlockUI();
    this._requisitionService.getShowName(channelBody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      console.log(response);
      this.searchshowNameList = response.Show;
      // this.showNameList.unshift({ "Title_Name": "Please select", "Title_Code": 0 });
      this.searchshowName.TitleCode = this.searchshowNameList[0];
    }, error => { this.handleResponseError(error) }
    )
  }
  public searchClickevent: any = 'N';
  public searchconsumtionListBody;
  searchClick() {
    debugger;
    var datePipe = new DatePipe('en-GB');
    // if (this.searchFromDate > this.searchToDate) {
    //   this.displayalertMessage = true;
    //   this.messageData = {
    //     'header': "Error",
    //     'body': "From date should be less than To date"
    //   }
    // }
    // else if (this.searchToDate < this.searchFromDate) {
    //   this.displayalertMessage = true;
    //   this.messageData = {
    //     'header': "Error",
    //     'body': "To date should be greater than From date"
    //   }
    // }
    if ((this.searchRequestId == null || this.searchRequestId == '')) {
      debugger
      if (this.searchChannel.length == 0) {
        if (this.searchshowName.length == 0) {
          if (this.searchFromDate == null) {
            if (this.searchToDate == null) {
              if (this.searchStatus.toString() == '') {
                this.displayalertMessage = true;
                this.messageData = {
                  'header': "Error",
                  'body': "Please Fill atleast one field"
                }
              }
              else {
                this.searchClickValidation();
              }

            }
            else {
              this.searchClickValidation();
            }
          }
          else {
            this.searchClickValidation();
          }
        }
        else {
          this.searchClickValidation();
        }
      }
      else {
        this.searchClickValidation();
      }

    }
    else {
      this.searchClickValidation();
    }


    //     this._requisitionService.getRequestList(consumtionListBody).subscribe(response => {
    //       this.load = false;
    //       this.removeBlockUI();
    // console.log("Request list");
    // console.log(response);
    // this.recordCount=response.RecordCount
    //       this.requestList = response.RequestList;
    //       console.log(this.requestList);
    //     });
  }
  searchClickValidation() {
    this.searchClickevent = 'Y';
    var datePipe = new DatePipe('en-GB');
    var channelcode = [];
    var showcode = [];
    for (let i = 0; i < this.searchChannel.length; i++) {
      channelcode.push(this.searchChannel[i].Channel_Code);
    }
    for (let i = 0; i < this.searchshowName.length; i++) {
      showcode.push(this.searchshowName[i].Title_Code);
    }
    this.load = true;
    this.addBlockUI();
    var consumtionListBody = {
      "RequestID": this.searchRequestId == null ? '' : this.searchRequestId,
      "ChannelCode": channelcode.toString(),
      "ShowCode": showcode.toString(),
      "StatusCode": this.searchStatus.toString(),
      "FromDate": this.searchFromDate == null ? '' : datePipe.transform(this.searchFromDate.toString(), 'dd-MMM-yyyy'),
      "ToDate": this.searchToDate == null ? '' : datePipe.transform(this.searchToDate.toString(), 'dd-MMM-yyyy')
    }

    console.log("Search Consumption");
    console.log(consumtionListBody);
    this.searchconsumtionListBody = consumtionListBody;
    this.getRequestList(10, 1);
  }
  clearAllClick() {
    // alert("clear All things..");
    debugger;
    this.searchClickevent = 'N';
    this.searchFromDate = null;
    this.searchToDate = null;
    this.searchStatus = '';
    this.searchRequestId = '';
    this.searchshowNameList = null;
    this.searchChannel = '';
    this.searchshowName = [];
    this.getRequestList(10, 1);
    var channelBody = {
      'Channel_Code': ''
    }

    console.log(JSON.stringify(channelBody));
    this.load = true;
    this.addBlockUI();
    this._requisitionService.getShowName(channelBody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      console.log(response);
      this.searchshowNameList = response.Show;
      // this.showNameList.unshift({ "Title_Name": "Please select", "Title_Code": 0 });
      this.searchshowName.TitleCode = this.searchshowNameList[0];
    }, error => { this.handleResponseError(error) }
    )



  }
  exportToExcel() {
    debugger;
    this.load = true;
    this.addBlockUI();
    var exportConsumptionBody;
    if (this.isRequestListclick == true) {
      this.sortBy = "RequestDate";
      this.order = "DESC";
    }
    else {
      this.sortBy = this.sortBy;
      this.order = this.order;
    }
    if (this.searchClickevent == 'N') {
      exportConsumptionBody = {
        "RecordFor": "L",
        "PagingRequired": "Y",
        "PageSize": this.exportPageSize,
        "PageNo": this.exportPageNo,
        "RequestID": "",
        "ChannelCode": '',
        "ShowCode": '',
        "StatusCode": '',
        "FromDate": "",
        "ToDate": "",
        "ExportFor": '',
        "SortBy": this.sortBy,
        "Order": this.order
      }
    }
    else if (this.searchClickevent == 'Y') {
      exportConsumptionBody = {
        "RecordFor": "L",
        "PagingRequired": "Y",
        "PageSize": this.exportPageSize,
        "PageNo": this.exportPageNo,
        "RequestID": this.searchconsumtionListBody.RequestID,
        "ChannelCode": this.searchconsumtionListBody.ChannelCode,
        "ShowCode": this.searchconsumtionListBody.ShowCode,
        "StatusCode": this.searchconsumtionListBody.StatusCode,
        "FromDate": this.searchconsumtionListBody.FromDate,
        "ToDate": this.searchconsumtionListBody.ToDate,
        "ExportFor": '',
        "SortBy": this.sortBy,
        "Order": this.order
      }
    }
    console.log(exportConsumptionBody);
    this._requisitionService.getexportConsumptionList(exportConsumptionBody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      console.log("Export Response");
      console.log(response);
      this.Download(response.Return.Message)
      // this.recordCount=response.RecordCount
      //     this.requestList = response.RequestList;
      //     console.log(this.requestList);
    }, error => { this.handleResponseError(error) }
    );
  }
  Download(b) {
    debugger;
    window.location.href = (this._requisitionService.DownloadFile().toString() + b).toString();
  }
  cueSheetHeaderChecked() {
    debugger
    console.log(this.cueSheetHeader);

    if (this.cueSheetHeader == true) {
      this.cueSheetReqList = [];
      this.requestList.forEach(x => x.cueSheet = true);
      for (let i = 0; i < this.requestList.length; i++) {
        if (this.requestList[i].Status == "Approved" && this.requestList[i].cueSheet == true) {
          this.cueSheetReqList.push(this.requestList[i]);

        }
      }
      console.log(this.cueSheetReqList);
      // this.requestList.forEach(x=>x.cueSheet==true);
    }
    else {
      this.requestList.forEach(x => x.cueSheet = false);
      this.cueSheetReqList = [];
    }

  }
  cueSheetChecked(cuedata) {
    debugger;
    if (this.cueSheetHeader == true) {
      if (cuedata.cueSheet == false) {
        this.cueSheetHeader = false;
        this.cueSheetReqList = this.cueSheetReqList.filter(x => x.RequestID != cuedata.RequestID);
      }
    }
    else {
      if (cuedata.cueSheet == true) {
        this.cueSheetReqList.push(cuedata);
      }
      else {
        this.cueSheetReqList = this.cueSheetReqList.filter(x => x.RequestID != cuedata.RequestID);

      }
    }
    console.log(this.cueSheetReqList);

    console.log(cuedata);
  }
  public cueSheetReqList: any[] = [];
  public cueSheetHeader: boolean = false;
  public manualAssignDialog: boolean = false;
  public cueSheetList: any;// any[] = [];
  public manualAssignHeader;
  public cueSheetDataBody: any = [];
  public episodeRangeList: any = [];
  public count = 0;
  public cueSheetListHeader: boolean = false;
  public requestedCueSheet: any[] = []
  cueSheetListChecked(rowdata, index) {
    // alert(rowdata);
    console.log(rowdata)
    console.log(index);
    if (this.cueSheetListHeader == true && rowdata.cuesheetListCheck == false) {
      this.cueSheetListHeader = false;
    }
    if (rowdata.cuesheetListCheck == true) {
      this.requestedCueSheet.push({ list: rowdata, index: index });
      // for(let i=0;i<this.cueSheetList.length;i++){
      if (this.cueSheetList[index].MusicTitleCode == rowdata.MusicTitleCode) {
        this.cueSheetList[index].Selected = false;
      }
      // }
      // this.cueSheetList.forEach(x=>x.MHRequestCode===rowdata.MHRequestCode?false:x.Selected)
    }
    else if (rowdata.cuesheetListCheck == false) {

      this.requestedCueSheet = this.requestedCueSheet.filter(x => x.index != index);
      console.log(this.requestedCueSheet)
      // for(let i=0;i<this.cueSheetList.length;i++){
      if (this.cueSheetList[index].MusicTitleCode == rowdata.MusicTitleCode) {
        this.cueSheetList[index].Selected = true;
      }
      // }
      // this.cueSheetList.forEach(x=>x.MHRequestCode===rowdata.MHRequestCode?true:x.Selected)
    }
    console.log(this.requestedCueSheet);
    // console.log(this.cueSheetList);
  }
  cueSheetListHeaderChecked() {
    this.requestedCueSheet = [];
    if (this.cueSheetListHeader == true) {
      this.cueSheetList.forEach(x => x.Selected = false);
      this.cueSheetList.forEach(x => x.cuesheetListCheck = true);
      for (let i = 0; i < this.cueSheetList.length; i++) {
        this.requestedCueSheet.push({ list: this.cueSheetList[i], index: i })
      }
    }
    else if (this.cueSheetListHeader == false) {

      this.cueSheetList.forEach(x => x.Selected = true);
      this.cueSheetList.forEach(x => x.cuesheetListCheck = false);
      // for(let i=0;i<this.cueSheetList.length;i++){
      //   this.requestedCueSheet.push({list:this.cueSheetList[i],index:i})
      // }
    }

    // this.requestedCueSheet=this.cueSheetList;
    console.log("Checked...")
    console.log(this.requestedCueSheet);
    // console.log(this.requestedCueSheet[0].list.MusicTitleCode)

  }
  manualAssignClick(IsCueSheet) {
    debugger;
    this.cueSheetListHeader = false;
    this.termCondition = false;
    let requestListCode: any = [];
    this.episodeRangeList = [];

    if (this.cueSheetReqList.length == 0) {
      this.displayalertMessage = true;
      this.messageData = {
        'header': "Message",
        'body': "Please Select at least one Record"
      }
    }
    else {
      let k = 0;
      for (let j = 0; j < this.cueSheetReqList.length; j++) {

        requestListCode.push(this.cueSheetReqList[j].RequestCode)
        k++;
      }
      if (this.cueSheetReqList.length == k) {

        this.load = true;
        this.addBlockUI();
        console.log(requestListCode.toString());
        this._requisitionService.getRequestCountDetails({ MHRequestCode: requestListCode.toString(), IsCueSheet: IsCueSheet }).subscribe(response => {
          this.load = false;
          this.removeBlockUI();
          console.log(response);
          //for (var i = 0; i < response.RequestDetails.length; i++) {
          //  if (response.RequestDetails[i].IsApprove == "Approve") {
          this.cueSheetList = response.RequestDetails;//.push(response.RequestDetails[i])
          this.cueSheetList.forEach(x => x.timeFrom = this.defaultDate)
          this.cueSheetList.forEach(x => x.timeTo = this.defaultDate)
          this.cueSheetList.forEach(x => x.durationTime = this.defaultDate)
          this.cueSheetList.forEach(x => x.fromFrame = "00")
          this.cueSheetList.forEach(x => x.toFrame = "00")
          this.cueSheetList.forEach(x => x.durationFrame = "00")
          this.cueSheetList.forEach(x => x.songType = "")
          this.cueSheetList.forEach(x => x.episodeRange = '');
          this.cueSheetList.forEach(x => x.cuesheetListCheck = false);
          this.cueSheetList.forEach(x => x.Selected = true);
          this.count = 0
          for (let i = 0; i < this.cueSheetList.length; i++) {
            if (this.cueSheetList[i].EpisodeFrom == this.cueSheetList[i].EpisodeTo) {
              this.episodeRangeList.push(this.cueSheetList[i].EpisodeFrom)
              this.count = this.count + 1;
            }
            else {
              let rangeList = [];
              for (let j = this.cueSheetList[i].EpisodeFrom; j <= this.cueSheetList[i].EpisodeTo; j++) {
                let body = {
                  'label': j.toString(),
                  'value': j
                }
                rangeList.push(body)
                this.count = this.count + 1;
              }
              this.episodeRangeList.push(rangeList);
            }
          }
          for (let i = 0; i < this.cueSheetList.length; i++) {
            this.cueSheetList[i].episodeRangeListName = this.episodeRangeList[i];
          }

          console.log(this.cueSheetList);
          this.totalCountOfNoOfSongsDetails = response.RequestDetails.length;
          // if( parseInt(data.EpisodeFrom)==parseInt(data.EpisodeTo)){
          //   this.manualAssignHeader="Cue Sheet Assignment - "+data.Title_Name+" ("+data.EpisodeFrom+")"

          // }
          // else{
          // this.manualAssignHeader="Cue Sheet Assignment - "+data.Title_Name+" ("+data.EpisodeFrom+" - "+data.EpisodeTo+")"
          // }
          this.textCueSheetRemarkCount = 0;
          this.remarksCueSheet = '';
          this.manualAssignDialog = true;
          this.productionHouseName = localStorage.getItem('ProductionName');
          this.termsTextFirst = "I hereby understand, accept and abide by the terms & conditions granted by Viacom18 Media Pvt Ltd for the consumption of music songs embedded within the said episode of the given program. The declaration is on behalf of the";
          this.termsTextSecond = "& its associated affiliates."
          //  }

          //}
          // this.requestCountHeader= rowdata.RequestID+' / '+rowdata.ChannelName+' / '+rowdata.Title_Name+' ( '+(rowdata.EpisodeFrom==rowdata.EpisodeTo?rowdata.EpisodeFrom:rowdata.EpisodeFrom+' To '+rowdata.EpisodeTo)+' )'


        }, error => { this.handleResponseError(error) }
        );
      }
    }

  }
  // manualAssignClick(data){
  //   this.termCondition=false;
  //   this.cueSheetDataBody=[];
  //   console.log(data);
  //   this.cueSheetDataBody.push({MHRequestCode:data.RequestCode,TitleName:data.Title_Name,TitleCode:data.TitleCode,EpisodeFromNo:data.EpisodeFrom,EpisodeToNo:data.EpisodeTo})
  //   this.load = true;
  //   this.addBlockUI();
  //   this._requisitionService.getRequestCountDetails({ MHRequestCode: data.RequestCode }).subscribe(response => {
  //     this.load = false;
  //     this.removeBlockUI();
  //     console.log(response.RequestDetails);
  //     this.cueSheetList = response.RequestDetails;
  //     this.cueSheetList.forEach(x=>x.timeFrom=this.defaultDate)
  //     this.cueSheetList.forEach(x=>x.timeTo=this.defaultDate)
  //     this.cueSheetList.forEach(x=>x.durationTime=this.defaultDate)
  //     this.cueSheetList.forEach(x=>x.fromFrame="00")
  //     this.cueSheetList.forEach(x=>x.toFrame="00")
  //     this.cueSheetList.forEach(x=>x.durationFrame="00")
  //     this.cueSheetList.forEach(x=>x.songType="")


  //     console.log(this.cueSheetList);
  //     this.totalCountOfNoOfSongsDetails=response.RequestDetails.length;
  //     if( parseInt(data.EpisodeFrom)==parseInt(data.EpisodeTo)){
  //       this.manualAssignHeader="Cue Sheet Assignment - "+data.Title_Name+" ("+data.EpisodeFrom+")"

  //     }
  //     else{
  //     this.manualAssignHeader="Cue Sheet Assignment - "+data.Title_Name+" ("+data.EpisodeFrom+" - "+data.EpisodeTo+")"
  //     }
  //     this.textCueSheetRemarkCount=0;
  //     this.remarksCueSheet='';
  //   this.manualAssignDialog=true;

  //     // this.requestCountHeader= rowdata.RequestID+' / '+rowdata.ChannelName+' / '+rowdata.Title_Name+' ( '+(rowdata.EpisodeFrom==rowdata.EpisodeTo?rowdata.EpisodeFrom:rowdata.EpisodeFrom+' To '+rowdata.EpisodeTo)+' )'


  //   }, error => { this.handleResponseError(error) }
  // );
  // }

  durationTimeCueSheet(rowData) {
    debugger;
    var datePipe = new DatePipe('en-GB');
    var date12 = new Date();
    console.log(date12);
    console.log(rowData);

    var inTime = rowData.timeFrom;
    var outTime = rowData.timeTo;
    if ((inTime > outTime) || inTime == null || outTime == null) {
      // alert("intime is greater than outtime")
      // this.displayalertMessage=true;
      // this.messageData = {
      //   'header': "Message",
      //   'body': "From  Time Should be less than  To Time "
      // }
      for (let i = 0; i < this.cueSheetList.length; i++) {
        if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {

          this.cueSheetList[i].durationTime = this.defaultDate;
          console.log(this.cueSheetList[i].durationTime);
        }
      }
      // this.cueSheetList[i].durationTime
    }
    else if (inTime <= outTime) {
      // alert("intime is less than outtime")

      var diff = outTime - inTime;

      var msec = diff;
      var hh = Math.floor(msec / 1000 / 60 / 60);
      msec -= hh * 1000 * 60 * 60;
      var mm = Math.floor(msec / 1000 / 60);
      msec -= mm * 1000 * 60;
      var ss = Math.floor(msec / 1000);
      msec -= ss * 1000;
      console.log(hh + ":" + mm + ":" + ss);
      var hhh = hh.toString().length == 1 ? ("0" + hh.toString()) : hh.toString();
      var mmm = mm.toString().length == 1 ? ("0" + mm.toString()) : mm.toString();
      var sss = ss.toString().length == 1 ? ("0" + ss.toString()) : ss.toString();
      for (let i = 0; i < this.cueSheetList.length; i++) {
        if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
          var datestr = date12.toString().substring(0, 16);
          console.log(datestr);
          var datelast = date12.toString().substring(24, 55);
          console.log(datelast);
          this.cueSheetList[i].durationTime = new Date(datestr + hhh + ":" + mmm + ":" + sss + datelast);
          console.log(this.cueSheetList[i].durationTime);
        }
      }
    }
    //   if (outTime < inTime) {
    //     outTime.setDate(outTime.getDate() + 1);
    // }

  }

  frameCueSheet(rowData) {
    debugger;
    var datePipe = new DatePipe('en-GB');
    var date12 = new Date();
    console.log(date12);
    console.log(rowData);

    var inFrame = rowData.fromFrame;
    var outFrame = rowData.toFrame;

    if ((inFrame > outFrame) || inFrame == null || outFrame == null) {
      for (let i = 0; i < this.cueSheetList.length; i++) {
        if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
          this.cueSheetList[i].durationFrame = 0;

          console.log(this.cueSheetList[i].durationTime);
        }
      }
      // this.cueSheetList[i].durationTime
    }
    else if (inFrame <= outFrame) {
      var diff = outFrame - inFrame;

      for (let i = 0; i < this.cueSheetList.length; i++) {
        if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
          this.cueSheetList[i].durationFrame = diff;
        }
      }
    }
  }

  calculateDuration(rowData, showError, validateOnly) {
    debugger;
    var returnVal = true;
    var frameLimitNew = 24;

    //var timeFrom = rowData.timeFrom.toTimeString().slice(0, 8);
    if (rowData.timeFrom.toString().includes("GMT")) {
      var timeFrom = rowData.timeFrom.toTimeString().slice(0, 8);
    }
    else {
      var timeFrom = rowData.timeFrom;
    }
    if (rowData.timeTo.toString().includes("GMT")) {
      var timeTo = rowData.timeTo.toTimeString().slice(0, 8);
    }
    else {
      var timeTo = rowData.timeTo;
    }

    var fromFrame = rowData.fromFrame;
    var toFrame = rowData.toFrame;

    var duration = rowData.durationTime;//.toTimeString().slice(0, 8);

    if (duration == "00:00" || duration == "00:00:00") {
      var arrFrom = timeFrom.split(":");
      var arrTo = timeTo.split(":");
      if (timeFrom == "00:00:00") {
        returnVal = false;
        if (showError)
          $("#txtFrom_" + rowData).addClass('required');
      }
      if (arrFrom.length == 2)
        timeFrom = arrFrom[0] + ":" + arrFrom[1] + ":00"

      if (fromFrame == "") {
        fromFrame = "00";
      }
      //$("#txtFrameFrom_" + rowData).val(this.FormatNumberLength(fromFrame, 2));

      for (let i = 0; i < this.cueSheetList.length; i++) {
        if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
          this.cueSheetList[i].fromFrame = this.FormatNumberLength(fromFrame, 2);
        }
      }

      if (timeTo == "00:00:00") {
        returnVal = false;
        if (showError)
          $("#txtTo_" + rowData).addClass('required');
      }
      if (arrTo.length == 2)
        timeTo = arrTo[0] + ":" + arrTo[1] + ":00"

      if (toFrame == "") {
        toFrame = "00";
      }

      //  $("#txtFrameTo_" + rowData).val(this.FormatNumberLength(toFrame, 2));
      for (let i = 0; i < this.cueSheetList.length; i++) {
        if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
          this.cueSheetList[i].toFrame = this.FormatNumberLength(toFrame, 2);
        }
      }

      if (returnVal) {
        var totalSec_From = this.ConvertToSeconds(timeFrom);
        var totalSec_To = this.ConvertToSeconds(timeTo);
        var diffSec = totalSec_To - totalSec_From;
        if (diffSec < 0) {
          returnVal = false;
          if (showError) {
            $("#txtTo_" + rowData).addClass('required');
            // showAlert("E", "Invalid Duration");
          }
        }
        if (returnVal && !validateOnly) {
          // var frameLimit = frameLimitNew;//$("#hdnFrameLimit").val();
          var durationFrame = 0;
          if (parseInt(toFrame) < parseInt(fromFrame)) {
            diffSec = diffSec - 1;
            durationFrame = 24 - parseInt(fromFrame)
            durationFrame = durationFrame + parseInt(toFrame);
          }
          else
            durationFrame = parseInt(toFrame) - parseInt(fromFrame)
          var balDuration = this.GetTimeInFormat(diffSec);
          //$("#lblDuration_" + rowData).val(balDuration);
          for (let i = 0; i < this.cueSheetList.length; i++) {
            if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
              if (diffSec >= 0) {
                this.cueSheetList[i].durationTime = balDuration;
              }

              this.cueSheetList[i].durationFrame = this.FormatNumberLength(durationFrame, 2);
            }
          }

          //$("#lblDurationFrame_" + rowData).val(this.FormatNumberLength(durationFrame, 2));
        }
      }
      return returnVal;
    }
    else {
      if ((timeFrom != "00:00:00" && timeFrom != "00:00") || (timeTo != "00:00:00" && timeTo != "00:00")) {
        var arrFrom = timeFrom.split(":");
        var arrTo = timeTo.split(":");

        if (timeFrom == "00:00:00" || timeFrom == "00:00") {
          returnVal = false;
          if (showError)
            $("#txtFrom_" + rowData).addClass('required');
        }
        if (arrFrom.length == 2)
          timeFrom = arrFrom[0] + ":" + arrFrom[1] + ":00"

        if (fromFrame == "") {
          fromFrame = "00";
        }
        //$("#txtFrameFrom_" + rowData).val(this.FormatNumberLength(fromFrame, 2));

        for (let i = 0; i < this.cueSheetList.length; i++) {
          if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
            this.cueSheetList[i].fromFrame = this.FormatNumberLength(fromFrame, 2);
          }
        }

        if (timeTo == "00:00:00" || timeTo == "00:00") {
          returnVal = false;
          if (showError)
            $("#txtTo_" + rowData).addClass('required');
        }
        if (arrTo.length == 2)
          timeTo = arrTo[0] + ":" + arrTo[1] + ":00"

        if (toFrame == "") {
          toFrame = "00";
        }
        //$("#txtFrameTo_" + rowData).val(this.FormatNumberLength(toFrame, 2));
        for (let i = 0; i < this.cueSheetList.length; i++) {
          if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
            this.cueSheetList[i].toFrame = this.FormatNumberLength(toFrame, 2);
          }
        }

        if (returnVal) {
          var totalSec_From = this.ConvertToSeconds(timeFrom);
          var totalSec_To = this.ConvertToSeconds(timeTo);
          var diffSec = totalSec_To - totalSec_From;
          if (diffSec < 0) {
            returnVal = false;
            if (showError) {
              $("#txtTo_" + rowData).addClass('required');
              //showAlert("E", "Invalid Duration");
            }
          }
          if (returnVal && !validateOnly) {
            //var frameLimit = frameLimitNew; //$("#hdnFrameLimit").val();
            var durationFrame = 0;
            if (parseInt(toFrame) < parseInt(fromFrame)) {
              diffSec = diffSec - 1;
              durationFrame = 24 - parseInt(fromFrame)
              durationFrame = durationFrame + parseInt(toFrame);
            }
            else
              durationFrame = parseInt(toFrame) - parseInt(fromFrame)

            if (diffSec < 0)
              diffSec = 0; // added by Rahul

            var balDuration = this.GetTimeInFormat(diffSec);

            //$("#lblDuration_" + rowData).val(balDuration);
            //$("#lblDurationFrame_" + rowData).val(this.FormatNumberLength(durationFrame, 2));

            for (let i = 0; i < this.cueSheetList.length; i++) {
              if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
                if (diffSec >= 0) {
                  this.cueSheetList[i].durationTime = balDuration;
                }
                this.cueSheetList[i].durationFrame = this.FormatNumberLength(durationFrame, 2);
              }
            }

          }
        }
        return returnVal;
      }
      else {

        if (fromFrame != "00" || toFrame != "00") {

          if (!validateOnly) {
            var frameLimit = frameLimitNew; // $("#hdnFrameLimit").val();
            var durationFrame = 0;
            if (parseInt(toFrame) < parseInt(fromFrame)) {
              diffSec = diffSec - 1;
              durationFrame = 24 - parseInt(fromFrame)
              durationFrame = durationFrame + parseInt(toFrame);
            }
            else
              durationFrame = parseInt(toFrame) - parseInt(fromFrame)

            var balDuration = this.GetTimeInFormat(diffSec);
            // $("#lblDuration_" + rowNo).val(balDuration);
            //$("#lblDurationFrame_" + rowData).val(this.FormatNumberLength(durationFrame, 2));

            for (let i = 0; i < this.cueSheetList.length; i++) {
              if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
                this.cueSheetList[i].durationFrame = this.FormatNumberLength(durationFrame, 2);
              }
            }

          }
        }

        returnVal = true;
        return returnVal;
      }
    }
  }

  ConvertToSeconds(time) {
    var arr = time.split(':');
    var hr = parseInt(arr[0], 10) * 3600;
    var mm = parseInt(arr[1], 10) * 60;
    var ss = parseInt(arr[2], 10);
    var totsec = hr + mm + ss;
    return totsec;
  }

  GetTimeInFormat(sec) {
    var val1;
    var val2;
    var hh = parseInt("00");
    var mm = parseInt("00");
    if (sec >= 3600) {
      val1 = parseFloat(sec) / 3600;
      hh = parseInt(val1, 10);
      sec = sec - (hh * 3600);
    }
    if (sec >= 60) {
      val2 = parseFloat(sec) / 60;
      mm = parseInt(val2, 10);
      sec = sec - (mm * 60);
    }

    var time = this.FormatNumberLength(hh, 2) + ':' + this.FormatNumberLength(mm, 2) + ':' + this.FormatNumberLength(sec, 2);
    return time;
  }

  FormatNumberLength(num, length) {
    var r = "" + num;
    while (r.length < length) {
      r = "0" + r;
    }
    return r;
  }

  public termCondition: boolean = false;
  public MHCueSheetSong: any = []
  validateManualCueSheetData() {
    debugger;
    var datePipe = new DatePipe('en-GB');

    console.log(this.cueSheetList)
    console.log(this.requestedCueSheet)
    this.MHCueSheetSong = [];
    // let EpsFrom = this.cueSheetDataBody[0].EpisodeFromNo;
    // let EpsTo = this.cueSheetDataBody[0].EpisodeToNo;
    let k = true
    // let count=((EpsTo-EpsFrom)==0?1:(EpsTo-EpsFrom)+1)*this.cueSheetList.length;
    let TotalCount = 0;
    let l = 1
    debugger;
    // for (let j=EpsFrom ;j<=EpsTo && k==true;(j++ && l++))
    // {
    if (this.requestedCueSheet.length == 0) {
      k = false;
      this.displayalertMessage = true;
      this.messageData = {
        'header': "Message",
        'body': "Please Select at least one record to submit CueSheet."
      }
    }
    else {
      for (let i = 0; i < this.cueSheetList.length && k == true; i++) {
        for (let j = 0; j < this.requestedCueSheet.length; j++) {
          console.log(this.cueSheetList[i].MusicTitleCode);
          console.log(this.requestedCueSheet[j].list.MusicTitleCode)
          if (this.cueSheetList[i].MusicTitleCode.toString() == this.requestedCueSheet[j].list.MusicTitleCode.toString()) {

            let tcInTime = this.cueSheetList[i].timeFrom == "00:00:00" ? this.cueSheetList[i].timeFrom : this.cueSheetList[i].timeFrom.toString();
            let tcOutTime = this.cueSheetList[i].timeTo == "00:00:00" ? this.cueSheetList[i].timeTo : this.cueSheetList[i].timeTo.toString();
            let durationTime = this.cueSheetList[i].durationTime == "00:00:00" ? this.cueSheetList[i].durationTime : this.cueSheetList[i].durationTime.toString();//datePipe.transform(this.cueSheetList[i].durationTime.toString(), 'HH:mm:ss')

            if (this.cueSheetList[i].durationTime == "00:00:00" && (this.cueSheetList[i].fromFrame > this.cueSheetList[i].toFrame)) {
              k = false;
              this.displayalertMessage = true;
              this.messageData = {
                'header': "Message",
                'body': "From Frame Should be less than To Frame"
              }
            }
            else if (this.cueSheetList[i].timeFrom <= this.cueSheetList[i].timeTo) {
              if ((tcInTime == "00:00:00" && tcOutTime == "00:00:00") && durationTime == "00:00:00") {
                k = false;
                this.displayalertMessage = true;
                this.messageData = {
                  'header': "Message",
                  'body': "From  and To Time Should not be 00:00:00"
                }
              }
              else if ((tcInTime != "00:00:00" && tcOutTime != "00:00:00")) {
                if (tcInTime == tcOutTime && durationTime == "00:00:00" && this.cueSheetList[i].fromFrame >= this.cueSheetList[i].toFrame) {
                  k = false;
                  this.displayalertMessage = true;
                  this.messageData = {
                    'header': "Message",
                    'body': "To Time Should be greater than From Time"
                  }
                }
                else {

                  if (this.cueSheetList[i].EpisodeFrom == this.cueSheetList[i].EpisodeTo) {
                    let body  //
                    if (this.cueSheetList[i].songType == "") {
                      k = false;
                      this.displayalertMessage = true;
                      this.messageData = {
                        'header': "Message",
                        'body': "Usage Type Should not be Blank"
                      }
                    }
                    else {
                      this.MHCueSheetSong.push({
                        TitleName: this.cueSheetList[i].Title_Name,
                        EpisodeNo: this.cueSheetList[i].episodeRangeListName,
                        MusicTitleCode: this.cueSheetList[i].MusicTitleCode,
                        MusicTrackName: this.cueSheetList[i].RequestedMusicTitle,
                        MHMusicSongTypeCode: this.cueSheetList[i].songType.MHMusicSongTypeCode == null ? 0 : this.cueSheetList[i].songType.MHMusicSongTypeCode,
                        SongType: this.cueSheetList[i].songType.MHMusicSongTypeCode == null ? this.cueSheetList[i].songType : this.cueSheetList[i].songType.SongType,
                        FromTime: this.cueSheetList[i].timeFrom == "00:00:00" ? this.cueSheetList[i].timeFrom : (this.cueSheetList[i].timeFrom.toString()),
                        FromFrame: this.cueSheetList[i].fromFrame,
                        ToTime: this.cueSheetList[i].timeTo == "00:00:00" ? this.cueSheetList[i].timeTo : (this.cueSheetList[i].timeTo.toString()),
                        ToFrame: this.cueSheetList[i].toFrame,
                        DurationTime: this.cueSheetList[i].durationTime == "00:00:00" ? this.cueSheetList[i].durationTime : this.cueSheetList[i].durationTime.toString(),//datePipe.transform(this.cueSheetList[i].durationTime.toString(), 'HH:mm:ss'),
                        DurationFrame: this.cueSheetList[i].durationFrame,
                        TitleCode: this.cueSheetList[i].TitleCode,
                        MHRequestCode: this.cueSheetList[i].MHRequestCode,
                        MovieAlbum: this.cueSheetList[i].MusicMovieAlbum
                      })
                      console.log(l)
                      TotalCount = (i + 1) * l;
                    }

                  }
                  else if (this.cueSheetList[i].EpisodeFrom != this.cueSheetList[i].EpisodeTo) {
                    let body
                    if (this.cueSheetList[i].episodeRange == "") {
                      k = false;
                      this.displayalertMessage = true;
                      this.messageData = {
                        'header': "Message",
                        'body': "Please Select Episode From Dropdown List."
                      }
                    }
                    else if (this.cueSheetList[i].songType == "") {
                      k = false;
                      this.displayalertMessage = true;
                      this.messageData = {
                        'header': "Message",
                        'body': "Usage Type Should not be Blank"
                      }
                    }
                    else {
                      for (let j = 0; j < this.cueSheetList[i].episodeRange.length; j++) {

                        this.MHCueSheetSong.push({
                          TitleName: this.cueSheetList[i].Title_Name,
                          EpisodeNo: this.cueSheetList[i].episodeRange[j],
                          MusicTitleCode: this.cueSheetList[i].MusicTitleCode,
                          MusicTrackName: this.cueSheetList[i].RequestedMusicTitle,
                          MHMusicSongTypeCode: this.cueSheetList[i].songType.MHMusicSongTypeCode == null ? 0 : this.cueSheetList[i].songType.MHMusicSongTypeCode,
                          SongType: this.cueSheetList[i].songType.MHMusicSongTypeCode == null ? this.cueSheetList[i].songType : this.cueSheetList[i].songType.SongType,
                          FromTime: this.cueSheetList[i].timeFrom == "00:00:00" ? this.cueSheetList[i].timeFrom : (this.cueSheetList[i].timeFrom.toString()),
                          FromFrame: this.cueSheetList[i].fromFrame,
                          ToTime: this.cueSheetList[i].timeTo == "00:00:00" ? this.cueSheetList[i].timeTo : (this.cueSheetList[i].timeTo.toString()),
                          ToFrame: this.cueSheetList[i].toFrame,
                          DurationTime: this.cueSheetList[i].durationTime == "00:00:00" ? this.cueSheetList[i].durationTime : this.cueSheetList[i].durationTime.toString(),//datePipe.transform(this.cueSheetList[i].durationTime.toString(), 'HH:mm:ss'),
                          DurationFrame: this.cueSheetList[i].durationFrame,
                          TitleCode: this.cueSheetList[i].TitleCode,
                          MHRequestCode: this.cueSheetList[i].MHRequestCode,
                          MovieAlbum: this.cueSheetList[i].MusicMovieAlbum
                        })
                        console.log(l)
                        TotalCount = (i + 1) * l;
                      }
                    }

                  }
                }
              }
              else if ((tcInTime == "00:00:00" && tcOutTime != "00:00:00") || (tcInTime != "00:00:00" && tcOutTime == "00:00:00")) {
                k = false;
                this.displayalertMessage = true;
                this.messageData = {
                  'header': "Message",
                  'body': "From  and To Time Should not be 00:00:00"
                }
              }
              else if ((tcInTime == "00:00:00" && tcOutTime == "00:00:00") && durationTime != "00:00:00") {
                if (this.cueSheetList[i].EpisodeFrom == this.cueSheetList[i].EpisodeTo) {
                  let body;
                  if (this.cueSheetList[i].songType == "") {
                    k = false;
                    this.displayalertMessage = true;
                    this.messageData = {
                      'header': "Message",
                      'body': "Usage Type Should not be Blank"
                    }
                  }
                  else {
                    this.MHCueSheetSong.push({
                      TitleName: this.cueSheetList[i].Title_Name,
                      EpisodeNo: this.cueSheetList[i].episodeRangeListName,
                      MusicTitleCode: this.cueSheetList[i].MusicTitleCode,
                      MusicTrackName: this.cueSheetList[i].RequestedMusicTitle,
                      MHMusicSongTypeCode: this.cueSheetList[i].songType.MHMusicSongTypeCode == null ? 0 : this.cueSheetList[i].songType.MHMusicSongTypeCode,
                      SongType: this.cueSheetList[i].songType.MHMusicSongTypeCode == null ? this.cueSheetList[i].songType : this.cueSheetList[i].songType.SongType,
                      FromTime: this.cueSheetList[i].timeFrom == "00:00:00" ? this.cueSheetList[i].timeFrom : (this.cueSheetList[i].timeFrom.toString()),
                      FromFrame: this.cueSheetList[i].fromFrame,
                      ToTime: this.cueSheetList[i].timeTo == "00:00:00" ? this.cueSheetList[i].timeTo : (this.cueSheetList[i].timeTo.toString()),
                      ToFrame: this.cueSheetList[i].toFrame,
                      DurationTime: this.cueSheetList[i].durationTime == "00:00:00" ? this.cueSheetList[i].durationTime : this.cueSheetList[i].durationTime.toString(),//datePipe.transform(this.cueSheetList[i].durationTime.toString(), 'HH:mm:ss'),
                      DurationFrame: this.cueSheetList[i].durationFrame,
                      TitleCode: this.cueSheetList[i].TitleCode,
                      MHRequestCode: this.cueSheetList[i].MHRequestCode,
                      MovieAlbum: this.cueSheetList[i].MusicMovieAlbum
                    })
                    console.log(l)
                    TotalCount = (i + 1) * l;
                  }
                }
                else if (this.cueSheetList[i].EpisodeFrom != this.cueSheetList[i].EpisodeTo) {
                  let body;
                  if (this.cueSheetList[i].episodeRange == "") {
                    k = false;
                    this.displayalertMessage = true;
                    this.messageData = {
                      'header': "Message",
                      'body': "Please Select Episode From Dropdown List."
                    }
                  }
                  else if (this.cueSheetList[i].songType == "") {
                    k = false;
                    this.displayalertMessage = true;
                    this.messageData = {
                      'header': "Message",
                      'body': "Usage Type Should not be Blank"
                    }
                  }
                  else {
                    for (let j = 0; j < this.cueSheetList[i].episodeRange.length; j++) {

                      this.MHCueSheetSong.push({
                        TitleName: this.cueSheetList[i].Title_Name,
                        EpisodeNo: this.cueSheetList[i].episodeRange[j],
                        MusicTitleCode: this.cueSheetList[i].MusicTitleCode,
                        MusicTrackName: this.cueSheetList[i].RequestedMusicTitle,
                        MHMusicSongTypeCode: this.cueSheetList[i].songType.MHMusicSongTypeCode == null ? 0 : this.cueSheetList[i].songType.MHMusicSongTypeCode,
                        SongType: this.cueSheetList[i].songType.MHMusicSongTypeCode == null ? this.cueSheetList[i].songType : this.cueSheetList[i].songType.SongType,
                        FromTime: this.cueSheetList[i].timeFrom == "00:00:00" ? this.cueSheetList[i].timeFrom : (this.cueSheetList[i].timeFrom.toString()),
                        FromFrame: this.cueSheetList[i].fromFrame,
                        ToTime: this.cueSheetList[i].timeTo == "00:00:00" ? this.cueSheetList[i].timeTo : (this.cueSheetList[i].timeTo.toString()),
                        ToFrame: this.cueSheetList[i].toFrame,
                        DurationTime: this.cueSheetList[i].durationTime == "00:00:00" ? this.cueSheetList[i].durationTime : this.cueSheetList[i].durationTime.toString(),//datePipe.transform(this.cueSheetList[i].durationTime.toString(), 'HH:mm:ss'),
                        DurationFrame: this.cueSheetList[i].durationFrame,
                        TitleCode: this.cueSheetList[i].TitleCode,
                        MHRequestCode: this.cueSheetList[i].MHRequestCode,
                        MovieAlbum: this.cueSheetList[i].MusicMovieAlbum
                      })
                      console.log(l)
                      TotalCount = (i + 1) * l;
                    }
                  }
                }
              }
            }
            else {
              k = false;
              this.displayalertMessage = true;
              this.messageData = {
                'header': "Message",
                'body': "From Time Should be less than To Time"
              }
            }
          }
        }
      }
    }
    // }
    console.log("Record Count");
    console.log(this.MHCueSheetSong);
    if (k == false) {
      return false;
    }
    else {
      return true;

    }
    // console.log(count);
    // console.log(TotalCount);
    // if(count==TotalCount){
    //   return true;
    // }
    // else {
    //   return false;
    // }
  }
  public filteredSong;
  filteredSongType(event) {

    let query = event.query;
    this.filteredSong = this.filterSongType(query, this.songTypeList)
    console.log(this.filteredSong);

  }
  filterSongType(query, songtype: any[]): any[] {
    //in a real application, make a request to a remote url with the query and return filtered results, for demo we filter at client side
    let filtered: any[] = [];
    songtype.filter(it => {
      console.log(it);
      if (it.SongType.toLowerCase().includes(query.toLowerCase())) {
        filtered.push(it);
      }
      // return it.toString().toLowerCase().indexOf(searchText) > -1;


    });
    // for(let i = 0; i < songtype.length; i++) {
    //     let country = songtype[i];
    //     if(country.SongType.toLowerCase().includes(query.toLowerCase()) == 0) {
    //         filtered.push(country);
    //     }
    // }
    console.log("Filter List");
    console.log(filtered)
    return filtered;
  }

  calculateTo(rowData, showError, validateOnly, data) {
    debugger;
    var returnVal = true;
    var frameLimitNew = 24;

    if (rowData.timeFrom.toString().includes("GMT")) {
      var timeFrom = rowData.timeFrom.toTimeString().slice(0, 8);
    }
    else {
      var timeFrom = rowData.timeFrom;
    }
    if (rowData.durationTime.toString().includes("GMT")) {
      var durationTime = rowData.durationTime.toTimeString().slice(0, 8);
    }
    else {
      var durationTime = rowData.durationTime
    }


    var fromFrame = rowData.fromFrame;
    var durationFrame = rowData.durationFrame;


    var duration = rowData.timeTo;//.toTimeString().slice(0, 8);

    if (rowData.timeTo.toString().includes("GMT")) {
      var timeTo = rowData.timeTo.toTimeString().slice(0, 8);
    }
    else {
      var timeTo = rowData.timeTo;
    }

    // var timeTo = rowData.timeTo.toTimeString().slice(0, 8);

    if (duration == "00:00" || duration == "00:00:00") {
      var arrFrom = timeFrom.split(":");
      var arrTo = durationTime.split(":");
      if (timeFrom == "00:00:00") {
        returnVal = false;
        if (showError)
          $("#txtFrom_" + rowData).addClass('required');
      }
      if (arrFrom.length == 2)
        timeFrom = arrFrom[0] + ":" + arrFrom[1] + ":00"

      if (fromFrame == "") {
        fromFrame = "00";
      }


      for (let i = 0; i < this.cueSheetList.length; i++) {
        if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
          this.cueSheetList[i].fromFrame = this.FormatNumberLength(fromFrame, 2);
        }
      }

      if (durationTime == "00:00:00") {
        returnVal = false;
        if (showError)
          $("#txtTo_" + rowData).addClass('required');
      }
      if (arrTo.length == 2)
        durationTime = arrTo[0] + ":" + arrTo[1] + ":00"

      if (durationFrame == "") {
        durationFrame = "00";
      }


      for (let i = 0; i < this.cueSheetList.length; i++) {
        if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
          this.cueSheetList[i].durationFrame = this.FormatNumberLength(durationFrame, 2);
        }
      }

      if (returnVal) {
        var totalSec_From = this.ConvertToSeconds(timeFrom);
        var totalSec_To = this.ConvertToSeconds(durationTime);
        var diffSec = totalSec_To + totalSec_From;
        if (diffSec < 0) {
          returnVal = false;
          if (showError) {
            $("#txtTo_" + rowData).addClass('required');

          }
        }
        if (returnVal && !validateOnly) {

          var toFrame = 0;
          if (parseInt(durationFrame) < parseInt(fromFrame)) {
            diffSec = diffSec + 1;
            toFrame = 24 + parseInt(fromFrame)
            toFrame = toFrame + parseInt(durationFrame);
          }
          else
            toFrame = parseInt(durationFrame) + parseInt(fromFrame)
          var balDuration = this.GetTimeInFormat(diffSec);
          //$("#lblDuration_" + rowData).val(balDuration);
          for (let i = 0; i < this.cueSheetList.length; i++) {
            if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
              if (diffSec >= 0) {
                this.cueSheetList[i].timeTo = balDuration;
              }

              this.cueSheetList[i].toFrame = this.FormatNumberLength(toFrame, 2);
            }
          }


        }
      }
      return returnVal;
    }
    else {
      if ((timeFrom != "00:00:00" && timeFrom != "00:00") || (durationTime != "00:00:00" && durationTime != "00:00")) {
        var arrFrom = timeFrom.split(":");
        var arrTo = durationTime.split(":");

        if (timeFrom == "00:00:00" || timeFrom == "00:00") {
          returnVal = false;
          if (showError)
            $("#txtFrom_" + rowData).addClass('required');
        }
        if (arrFrom.length == 2)
          timeFrom = arrFrom[0] + ":" + arrFrom[1] + ":00"

        if (fromFrame == "") {
          fromFrame = "00";
        }


        for (let i = 0; i < this.cueSheetList.length; i++) {
          if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
            this.cueSheetList[i].fromFrame = this.FormatNumberLength(fromFrame, 2);
          }
        }

        if (durationTime == "00:00:00" || durationTime == "00:00") {
          returnVal = false;
          if (showError)
            $("#txtTo_" + rowData).addClass('required');
        }
        if (arrTo.length == 2)
          durationTime = arrTo[0] + ":" + arrTo[1] + ":00"

        if (durationFrame == "") {
          durationFrame = "00";
        }

        for (let i = 0; i < this.cueSheetList.length; i++) {
          if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
            this.cueSheetList[i].durationFrame = this.FormatNumberLength(durationFrame, 2);
          }
        }

        if (returnVal) {
          var totalSec_From = this.ConvertToSeconds(timeFrom);
          var totalSec_To = this.ConvertToSeconds(durationTime);
          var diffSec = totalSec_To + totalSec_From;
          if (diffSec < 0) {
            returnVal = false;
            if (showError) {
              $("#txtTo_" + rowData).addClass('required');

            }
          }
          if (returnVal && !validateOnly) {
            var toFrame = 0;
            if (parseInt(durationFrame) < toFrame) {
              toFrame = parseInt(durationFrame) + toFrame;
            }
            else if (data == 'durationChange') {
              toFrame = parseInt(durationFrame) + parseInt(fromFrame);
              this.setDuration = false;
              if (this.setDuration == false) {
                var totalSec_From = this.ConvertToSeconds(timeFrom);
                var totalSec_To = this.ConvertToSeconds(timeTo);
                var diffSec = totalSec_To - totalSec_From;
                if (diffSec < 0) {
                  returnVal = false;
                  if (showError) {
                    $("#txtTo_" + rowData).addClass('required');
                  }
                }
                if (returnVal && !validateOnly) {
                  if ((toFrame) < parseInt(fromFrame)) {
                    diffSec = diffSec - 1;
                  }
                }
                var balDurationset = this.GetTimeInFormat(diffSec);
              }
              if (toFrame > 23) {
                this.setDuration = true;
                toFrame = (parseInt(durationFrame) + parseInt(fromFrame) - 24);
                var totalSec_From = this.ConvertToSeconds(timeFrom);
                var totalSec_To = this.ConvertToSeconds(timeTo);
                var diffSec = totalSec_To - totalSec_From;
                if (diffSec < 0) {
                  returnVal = false;
                  if (showError) {
                    $("#txtTo_" + rowData).addClass('required');
                  }
                }
                if (returnVal && !validateOnly) {
                  if ((toFrame) < parseInt(fromFrame)) {
                    diffSec = diffSec - 1;
                  }
                }
                var balDurationset = this.GetTimeInFormat(diffSec);
              }
            }
            if (diffSec < 0)
              diffSec = 0; // added by Rahul

            var balDuration = this.GetTimeInFormat(diffSec);
          }


          for (let i = 0; i < this.cueSheetList.length; i++) {
            if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
              if (diffSec >= 0) {
                if (data == 'nodurationChange') {
                  this.cueSheetList[i].timeTo = balDuration;
                  this.cueSheetList[i].durationTime = durationTime;
                }
                else if (data == 'durationChange') {
                  if (this.setDuration == true) {
                    this.cueSheetList[i].durationTime = balDurationset;
                  }
                  else if (this.setDuration == false) {
                    this.cueSheetList[i].durationTime = balDurationset;
                  }
                }
              }
              this.cueSheetList[i].toFrame = this.FormatNumberLength(toFrame, 2);

            }

          }
        }
        return returnVal;
      }
      else if ((timeTo != "00:00:00" && timeTo != "00:00") || (durationTime != "00:00:00" && durationTime != "00:00")) {
        this.calculateFrom(rowData, false, false, data)
      }

      else {

        if (fromFrame != "00" && durationFrame != "00") {

          if (!validateOnly) {
            var frameLimit = frameLimitNew; // $("#hdnFrameLimit").val();
            var toFrame = 0;
            if (parseInt(durationFrame) < toFrame) {
              toFrame = parseInt(durationFrame) + toFrame;
            }
            else {
              toFrame = parseInt(durationFrame) + parseInt(fromFrame);
              if (toFrame > 23) {
                toFrame = (parseInt(durationFrame) + parseInt(fromFrame) - 24);
              }
            }
            // if (parseInt(durationFrame) < parseInt(fromFrame)) {
            //   diffSec = diffSec + 1;
            //   toFrame = 24 + parseInt(fromFrame)
            //   toFrame = toFrame + parseInt(durationFrame);
            // }
            // else
            //   toFrame = parseInt(durationFrame) + parseInt(fromFrame)

            var balDuration = this.GetTimeInFormat(diffSec);


            for (let i = 0; i < this.cueSheetList.length; i++) {
              if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
                this.cueSheetList[i].toFrame = this.FormatNumberLength(toFrame, 2);
              }
            }

          }
        }

        returnVal = true;
        return returnVal;
      }
    }
  }

  calculateFrom(rowData, showError, validateOnly, data) {
    debugger;
    var returnVal = true;
    var frameLimitNew = 24;

    if (rowData.durationTime.toString().includes("GMT")) {
      var durationTime = rowData.durationTime.toTimeString().slice(0, 8);
    }
    else {
      var durationTime = rowData.durationTime;
    }
    if (rowData.timeTo.toString().includes("GMT")) {
      var timeTo = rowData.timeTo.toTimeString().slice(0, 8);
    }
    else {
      var timeTo = rowData.timeTo;
    }
    // var durationTime = rowData.durationTime.toTimeString().slice(0, 8);
    //  var timeTo =rowData.timeTo.toTimeString().slice(0, 8);

    var toFrame = rowData.toFrame;
    var durationFrame = rowData.durationFrame;
    if ((timeTo != "00:00:00" && timeTo != "00:00") || (durationTime != "00:00:00" && durationTime != "00:00")) {
      var arrFrom = timeTo.split(":");
      var arrTo = durationTime.split(":");

      if (timeTo == "00:00:00" || timeTo == "00:00") {
        returnVal = false;
        if (showError)
          $("#txtFrom_" + rowData).addClass('required');
      }
      if (arrFrom.length == 2)
        timeTo = arrFrom[0] + ":" + arrFrom[1] + ":00"

      if (toFrame == "") {
        toFrame = "00";
      }
      for (let i = 0; i < this.cueSheetList.length; i++) {
        if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
          this.cueSheetList[i].toFrame = this.FormatNumberLength(toFrame, 2);
        }
      }
      if (durationTime == "00:00:00" || durationTime == "00:00") {
        returnVal = false;
        if (showError)
          $("#txtTo_" + rowData).addClass('required');
      }
      if (arrTo.length == 2)
        durationTime = arrTo[0] + ":" + arrTo[1] + ":00"

      if (durationFrame == "") {
        durationFrame = "00";
      }
      for (let i = 0; i < this.cueSheetList.length; i++) {
        if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
          this.cueSheetList[i].durationFrame = this.FormatNumberLength(durationFrame, 2);
        }
      }
      if (returnVal) {
        var totalSec_From = this.ConvertToSeconds(timeTo);
        var totalSec_To = this.ConvertToSeconds(durationTime);
        var diffSec = totalSec_From - totalSec_To;
        if (diffSec < 0) {
          returnVal = false;
          if (showError) {
            $("#txtTo_" + rowData).addClass('required');

          }
        }
        if (returnVal && !validateOnly) {

          var fromFrame = 0;
          if (parseInt(durationFrame) < parseInt(toFrame)) {
            diffSec = diffSec - 1;
            fromFrame = 24 - parseInt(toFrame)
            fromFrame = toFrame + parseInt(durationFrame);
          }
          else
            fromFrame = parseInt(durationFrame) - parseInt(toFrame)

          if (diffSec < 0)
            diffSec = 0; // added by Rahul

          var balDuration = this.GetTimeInFormat(diffSec);



          for (let i = 0; i < this.cueSheetList.length; i++) {
            if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
              if (diffSec >= 0) {
                if (data == 'nodurationChange') {
                  this.cueSheetList[i].timeFrom = balDuration;
                }
                // if (data == 'durationChange') {
                //   this.cueSheetList[i].fromFrame = this.FormatNumberLength(fromFrame, 2);
                // }
              }
            }
          }

        }
        return returnVal;
      }
    }
    // else {
    //   if (toFrame != "00" || durationFrame != "00" && data == 'durationChange') {

    //     if (!validateOnly) {
    //       var frameLimit = frameLimitNew; // $("#hdnFrameLimit").val();
    //       var fromFrame = 0;
    //       if (parseInt(durationFrame) < toFrame) {
    //         fromFrame = toFrame - parseInt(durationFrame) ;
    //       }
    //       else {
    //         fromFrame = parseInt(durationFrame) + parseInt(toFrame);
    //         if (fromFrame > 23) {
    //           fromFrame = (parseInt(durationFrame) + parseInt(toFrame) - 24);
    //         }
    //       }
    //       var balDuration = this.GetTimeInFormat(diffSec);


    //       for (let i = 0; i < this.cueSheetList.length; i++) {
    //         if (this.cueSheetList[i].MusicTitleCode == rowData.MusicTitleCode) {
    //           if (data == 'durationChange') {
    //           this.cueSheetList[i].fromFrame = this.FormatNumberLength(fromFrame, 2);
    //           }
    //         }
    //       }

    //     }
    //   }
    // }
    // returnVal = true;
    // return returnVal;




  }

  submitMusicCueSheet() {
    // alert(this.termCondition)
    if (this.termCondition == true) {

      console.log("Music cue sheet upload");
      console.log(this.cueSheetList);

      // this.cueSheetDataBody.push({MHRequestCode:data.RequestCode,TitleName:data.Title_Name,TitleCode:data.TitleCode,EpisodeFromNo:data.EpisodeFrom,EpisodeToNo:data.EpisodeTo})
      if (this.validateManualCueSheetData()) {
        let cueSheetBody = {
          "FileName": "CueSheet_" + this.vendorShortName.VendorShortName + "_" + this.timeStamp,
          "SpecialInstruction": this.remarksCueSheet,
          // "MHRequestCode":this.cueSheetDataBody[0].MHRequestCode,
          "MHCueSheetSong": this.MHCueSheetSong
        }
        console.log("Cue Sheet Submit");
        console.log(JSON.stringify(cueSheetBody));
        this.load = true;
        this.addBlockUI();
        this._requisitionService.cueSheetSaveManually(cueSheetBody).subscribe(response => {
          this.load = false;
          this.removeBlockUI();
          // console.log("Submitted Successfully..!");
          this.manualAssignDialog = false;
          this.displayalertMessage = true;
          this.messageData = {
            'header': "Message",
            'body': "Cue Sheet Submitted Successfully..!"
          }
          console.log(response)
          this.MHCueSheetSong = [];
          this.requestedCueSheet = [];
        }, error => { this.handleResponseError(error) }
        );
      }
    }
    else {
      this.displayalertMessage = true;
      this.messageData = {
        'header': "Message",
        'body': "Please accept Terms and Conditions"
      }
    }
  }
  changedata(eventdata) {
    console.log(eventdata);
    // alert(eventdata);
  }
  public remarkCueSheetValid: boolean = true;
  public songTypeValCondtn: boolean = false;
  // songTypeChange(){
  //   this.remarkChange()

  // }
  remarkChange() {
    // alert(this.remarksCueSheet.length)

    if (this.remarksCueSheet.trim().length == 0) {

      this.remarksCueSheet = '';
      this.remarkCueSheetValid = true;
      // this.textCueSheetRemarkCount=this.remarksCueSheet.length;
    }
    else {
      this.remarkCueSheetValid = false;
    }
    // else{
    //   for(let i=0;i<this.cueSheetList.length;i++){
    //     if(i==0){
    //       this.cueSheetList[i].songType.trim().length==0?this.remarkCueSheetValid=true:this.remarkCueSheetValid=false;

    //     }
    //     else{
    //       if(this.remarkCueSheetValid==false){
    //         this.cueSheetList[i].songType.trim().length==0?this.remarkCueSheetValid=true:this.remarkCueSheetValid=false;
    //       }
    //     }
    //   }
    //     // if (this.songTypeValCondtn == true) {
    //     //   this.remarkCueSheetValid = true;
    //     // }
    //     // else {
    //     //   this.remarkCueSheetValid = false;
    //     // }
    // }
    this.textCueSheetRemarkCount = this.remarksCueSheet.trim().length;

  }

  episodeValidation() {
    debugger;
    if (parseInt(this.newMusicConsumptionRequest.EpisodeFrom) >= parseInt(this.newMusicConsumptionRequest.EpisodeTo)) {
      this.displayalertMessage = true;

      this.messageData = {
        'header': "Error",
        'body': "Episode To should greater than Episode From"
      }
    }
  }

  exportRequestdetails() {
    let dataObj = {
      "RequestID": "",
      "RecordFor": "L",
      "ChannelCode": "",
      "ShowCode": "",
      "ExportFor": "C",
      "StatusCode": "",
      "FromDate": "",
      "ToDate": "",
      "SortBy": this.sortBy,
      "Order": this.order
    }
    this._requisitionService.ExportConsumptionDetailList(dataObj).subscribe(response => {
      this.Download(response.Return.Message)
    }, error => { this.handleResponseError(error) }
    );
  }

  getMusicLanguage() {
    this.load = true;
    var musicLanguage = {}
    this._CommonUiService.getMusicLanguage(musicLanguage).subscribe(response => {
      this.load = false;
      this.languageList = response.MusicLanguage;
      this.languageList.unshift({ "Language_Name": "Music Language", "Music_Language_Code": 0 });
      this.newSearchRequest.MusicLanguageCode = this.languageList[0];
    }, error => { this.handleResponseError(error) });
  }

  getMusicLabel() {
    this.load = true;
    var musicLabelBody = {
      "ChannelCode": '',
      "TitleCode": ''
    }
    this._requisitionService.getMusicLabels(musicLabelBody).subscribe(response => {
      this.load = false;
      this.musicLabelList = response.Music;
      this.musicLabelList.unshift({ "MusicLabelName": "Music Label", "MusicLabelCode": 0 });
      this.newSearchRequest.MusicLabelCode = this.musicLabelList[0];
    }, error => { this.handleResponseError(error) }
    );
  }

  searchTrack() {
    debugger;
    this.tabHeaders = 'PlayListSearch';
    this.setMHPlaylistCode = 0;
    this.showdetail=true;
    sessionStorage.setItem(SEARCHED_GRID, 'true');
    sessionStorage.setItem(TAB_NAME, this.tabHeaders);
    sessionStorage.setItem(MHPLAYLIST_CODE, this.setMHPlaylistCode);
    sessionStorage.setItem(NEWREQ_DATA, JSON.stringify(this.newSearchRequest));
    this.searchedTrack=true;
    this.componentData = {
      'showName': this.newMusicConsumptionRequest.TitleCode.Title_Name, 'episodeType': this.episodeType,
      'listview': this.listdetail, 'listview1': this.listDetail1, 'toplist': this.toplist
    }
  }

  clearSearch() {
    debugger;
    this.newSearchRequest.MusicTrack = '';
    this.newSearchRequest.MovieName = '';
    this.newSearchRequest.GenreCode = null;
    this.newSearchRequest.TalentName = '';
    this.newSearchRequest.Tag = '';
    this.newSearchRequest.MusicLabelCode = 0;
    this.newSearchRequest.GenreCode = 0;
    this.newSearchRequest.MusicLanguageCode = 0;
    this.searchList = [];
    this.recordCount = 0;
    this.tabHeaders = 'PlayListSearch';
    this.setMHPlaylistCode = 0;
    sessionStorage.setItem(SEARCHED_GRID, 'false');
    sessionStorage.setItem(TAB_NAME, this.tabHeaders);
    sessionStorage.setItem(MHPLAYLIST_CODE, this.setMHPlaylistCode);
    sessionStorage.setItem(NEWREQ_DATA, JSON.stringify(this.newSearchRequest));
    this.componentData = {
      'showName': this.newMusicConsumptionRequest.TitleCode.Title_Name, 'episodeType': this.episodeType,
      'listview': this.listdetail, 'listview1': this.listDetail1, 'toplist': this.toplist
    }
  }


  getMusictrackList(data, i) {
    debugger;
    this.showdetail = true;
    this.tabHeaders = "PlayList";
    this.setMHPlaylistCode = data.MHPlayListCode;
    this.setMHPlaylistName = data.PlaylistName;
    for (let i = 0; i < this.listdetail.length; i++) {
      if (this.listdetail[i].MHPlayListCode == this.setMHPlaylistCode) {
        this.listdetail[i].showCss = 'Y';
      }
      else {
        this.listdetail[i].showCss = 'N';
      }
    }
    sessionStorage.setItem(TAB_NAME, this.tabHeaders);
    sessionStorage.setItem(MHPLAYLIST_CODE, this.setMHPlaylistCode);
    sessionStorage.setItem(SEARCHED_GRID, 'false');
    this.componentData = {
      'showName': this.newMusicConsumptionRequest.TitleCode.Title_Name, 'episodeType': this.episodeType,
      'listview': this.listdetail, 'listview1': this.listDetail1, 'toplist': this.toplist
    }
  }

  onTabChange(event) {
    debugger;
    if (event.index == 0) {
      this.tabHeaders = 'PlayList';
      this.showPlayList = true;
      this.showdetail = true;
      this.showTabdata = true;
      var getMHPlaylistCode = this.listdetail.filter(x => x.PlaylistName == this.setMHPlaylistName)[0];
      this.setMHPlaylistCode = getMHPlaylistCode.MHPlayListCode;
      for (let i = 0; i < this.listdetail.length; i++) {
        if (this.listdetail[i].MHPlayListCode == this.setMHPlaylistCode) {
          this.listdetail[i].showCss = 'Y';
        }
        else {
          this.listdetail[i].showCss = 'N';
        }
      }
      sessionStorage.setItem(TAB_NAME, this.tabHeaders);
      sessionStorage.setItem(MHPLAYLIST_CODE, this.setMHPlaylistCode);
      sessionStorage.setItem(SEARCHED_GRID, 'false');
      this.getPlayList();
      this.componentData = {
        'showName': this.newMusicConsumptionRequest.TitleCode.Title_Name, 'episodeType': this.episodeType,
        'listview': this.listdetail, 'listview1': this.listDetail1, 'toplist': this.toplist
      }
    }
    else if (event.index == 1  && this.searchedTrack == false) {
      this.showdetail = false;
      this.showTabdata = true;
      this.showPlayList = false;
      this.tabHeaders = 'PlayListSearch';
      sessionStorage.setItem(TAB_NAME, this.tabHeaders);
      sessionStorage.setItem(MHPLAYLIST_CODE, this.setMHPlaylistCode);
      sessionStorage.setItem(SEARCHED_GRID, 'true');
      this.componentData = {
        'showName': this.newMusicConsumptionRequest.TitleCode.Title_Name, 'episodeType': this.episodeType,
        'listview': this.listdetail, 'listview1': this.listDetail1, 'toplist': this.toplist
      }
    }
    else if(event.index==1 && this.searchedTrack == true){
      this.showdetail = true;
      this.showTabdata = true;
      this.showPlayList = false;
      this.tabHeaders = 'PlayListSearch';
      sessionStorage.setItem(TAB_NAME, this.tabHeaders);
      sessionStorage.setItem(MHPLAYLIST_CODE, this.setMHPlaylistCode);
      sessionStorage.setItem(SEARCHED_GRID, 'true');
      this.componentData = {
        'showName': this.newMusicConsumptionRequest.TitleCode.Title_Name, 'episodeType': this.episodeType,
        'listview': this.listdetail, 'listview1': this.listDetail1, 'toplist': this.toplist
      }
    }
  }

  deleteFullPlaylist() {
    this.showDeletedialog = true;
  }

  deletePlaylist() {
    let dataObj = {
      "MHPlayListCode": this.setMHPlaylistCode,
    }
    this._requisitionService.DeletePlayList(dataObj).subscribe(response => {
      let Return = response.Return
      if (Return.IsSuccess == true) {
        this.showDeletedialog = false;
        this.getPlayList();
        this.componentData = {
          'showName': this.newMusicConsumptionRequest.TitleCode.Title_Name, 'episodeType': this.episodeType,
          'listview': this.listdetail, 'listview1': this.listDetail1, 'toplist': this.toplist
        }
      }
    }, error => { this.handleResponseError(error) });
  }

  handleResponseError(errorCode) {
    this.load = false;
    this.removeBlockUI();
    if (errorCode == 403) {

      sessionStorage.clear();
      localStorage.clear();
      this.router.navigate(['/login']);
    }
  }
}
