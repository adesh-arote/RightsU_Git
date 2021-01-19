import { Component, OnInit, Renderer2, ElementRef } from '@angular/core';
import { RequisitionService } from '../../requisition/requisition.service';
import { MusicAssignmentService } from '../../music-assignment/music-assignment.service';
import { Router, ActivatedRoute, ParamMap, NavigationEnd } from '@angular/router';
import { Subject } from 'rxjs';
import { DatePipe } from '@angular/common';
import { Message } from 'primeng/components/common/api';
import { MenuItem } from 'primeng/api';
declare var $: any;

@Component({
  selector: 'app-authorized-music',
  templateUrl: './authorized-music.component.html',
  styleUrls: ['./authorized-music.component.css'],
  providers: [RequisitionService]
})
export class AuthorizedMusicComponent implements OnInit {

  public visibleSidebar2: boolean = false;
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
  public requestCountHeader: any;
  public totalCountOfNoOfSongsDetails = 0;
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
  public recordCount = 0;
  public rowonpage = 10;
  public first = 0;
  public searchChannel: any = [];
  public searchshowNameList;
  public searchshowName: any = [];
  public Status: any = [];
  public searchStatus: any = [];
  public searchFromDate;
  public searchToDate;
  public searchRequestId;
  public sortingDefault: boolean = false;
  public order: any;
  public sortBy: any;
  public showMusicTrackList: boolean = false;
  public showUsageList: boolean = false;
  public requestMusicList: any;
  public totalCountOfMusicTrack: number;
  public requestAlbumList: any = [];
  public totalCountofMovieAlbum: number;
  public showMusicAlbumList: boolean = false;
  public isFirstClickedusage: boolean = false;
  public isFirstClickedmusictrack: boolean = false;
  public isFirstClickedmusicalbum: boolean = false;

  constructor(private renderer: Renderer2, private elRef: ElementRef, private _requisitionService: RequisitionService, private router: Router) {
    this.Status = [
      { label: 'Approved', value: '1' },
      { label: 'Pending', value: '2' },
      { label: 'Rejected', value: '3' },
      { label: 'Partially Approved', value: '4' }

    ];
  }

  ngOnInit() {
    this.load = true;
    this.sortingDefault = true;
    this.showUsageList = true;
    this.showMusicTrackList = false;
    this.showMusicAlbumList = false;
    this.addBlockUI();
    this._requisitionService.getChannel().subscribe(response => {

      console.log("response of channel");
      this.getChannelList = response.Channel;
      this.load = false;
      this.removeBlockUI();
      // this.getChannelList.unshift({ "Channel_Name": "Please select", "Channel_Code": 0 });
      // this.newMusicConsumptionRequest.ChannelCode = this.getChannelList[0];

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
        this.getRequestList(25, 1);
      },
        error => { this.handleResponseError(error) })
    }, error => { this.handleResponseError(error) })
  }


  requestCountDetails(rowdata, IsCueSheet) {
    debugger;
    this.load = true;
    this.addBlockUI();
    this._requisitionService.getRequestCountDetails({ MHRequestCode: rowdata.RequestCode, IsCueSheet: IsCueSheet }).subscribe(response => {

      this.requestCountList = response.RequestDetails;
      this.totalCountOfNoOfSongsDetails = response.RequestDetails.length;
      this.showRequestCountDetails = true;
      this.requestCountHeader = rowdata.RequestID + ' / ' + rowdata.ChannelName + ' / ' + rowdata.Title_Name + ' ( ' + (rowdata.EpisodeFrom == rowdata.EpisodeTo ? rowdata.EpisodeFrom : rowdata.EpisodeFrom + ' To ' + rowdata.EpisodeTo) + ' )'
      this.load = false;
      this.removeBlockUI();
      this.newSearchRequest = {
        MusicLabelCode: 0,
        MusicTrack: "",
        MovieName: "",
        GenreCode: 0,
        TalentName: "",
        Tag: ""
      }
      // this.cartListCount = 0;
    }, error => { this.handleResponseError(error) });
  }

  getRequestList(pageSize, PageNo) {
    this.exportPageNo = PageNo;
    this.exportPageSize = pageSize;
    if (this.sortingDefault == true) {
      this.sortBy = "RequestDate";
      this.order = "DESC";
    }
    else {
      this.sortBy = this.sortBy;
      this.order = this.order;
    }
    var consumtionListBody;
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
    console.log(consumtionListBody);
    this.load = true;
    this.addBlockUI();
    this._requisitionService.getRequestList(consumtionListBody).subscribe(response => {
      this.isFirstClickedusage = true;
      console.log("Request list");
      console.log(response);
      if (response.Return.IsSuccess) {
        this.recordCount = response.RecordCount
        this.requestList = response.RequestList;
        this.sortingDefault = false;
        // console.log("welcome to list");
        // alert("welcome");
        this.load = false;
        this.removeBlockUI();
        console.log(this.requestList);
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


  loadDataOnPagination(event) {
    debugger;
    var pageNo = event.first;
    var pageSize = event.rows;
    var sortBy = event.sortField;
    this.sortBy = sortBy;
    if (this.sortingDefault == true) {
      this.sortBy = "RequestDate";
      this.order = "DESC";
    }
    else {
      if (event.sortField == undefined) {
        this.sortBy = "RequestDate";
      }
      if (event.sortOrder == 1) {
        this.order = "ASC";
      }
      else {
        this.order = "DESC";
      }
      this.sortBy = this.sortBy;
      this.order = this.order;
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


  public exportPageSize = 10;
  public exportPageNo = 1;
  onpagechange(pageSize, pageNo) {
    // this.recordCount=0;
    this.exportPageSize = pageSize;
    this.exportPageNo = pageNo;
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

      console.log("Request list");
      console.log(response);
      this.recordCount = response.RecordCount
      this.requestList = response.RequestList;
      this.load = false;
      this.removeBlockUI();
      console.log(this.requestList);
      this.sortingDefault = false;
    }, error => { this.handleResponseError(error) });
  }

  // advance search method
  searchChannelChange() {
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
    },
      error => { this.handleResponseError(error) })
  }
  public searchClickevent: any = 'N';
  public searchconsumtionListBody;
  searchClick() {

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
    this.searchClickevent = 'Y'
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
    this.searchClickevent = 'N';
    this.searchFromDate = null;
    this.searchToDate = null;
    this.searchStatus = '';
    this.searchRequestId = '';
    this.searchshowNameList = null;
    this.searchChannel = '';
    this.searchshowName = [];
    this.getRequestList(10, 1);
  }
  exportToExcel() {
    debugger;
    this.load = true;
    if (this.sortingDefault == true) {
      this.sortBy = "RequestDate";
      this.order = "DESC";
    }
    else {
      this.order = this.order;
      this.sortBy = this.sortBy;
    }
    this.addBlockUI();
    var exportConsumptionBody;
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
        "ExportFor": 'A',
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
        "ExportFor": 'A',
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
    }, error => { this.handleResponseError(error) });
  }
  Download(b) {
    debugger;
    window.location.href = (this._requisitionService.DownloadFile().toString() + b).toString();
  }

  checkRequest(data) {
    debugger;
    if (data == 'usage') {
      this.showMusicTrackList = false;
      this.showUsageList = true;
      this.showMusicAlbumList = false;
      if (data == 'usage' && this.isFirstClickedusage == false) {
        this.getRequestList(25, 1)
      }
    }
    else if (data == 'musictrack') {
      this.showMusicTrackList = true;
      this.showUsageList = false;
      this.showMusicAlbumList = false;
      if (data == 'musictrack' && this.isFirstClickedmusictrack == false) {
        this.requestMusicListMethod();
      }
    }
    else if (data == 'musicalbum') {
      this.showMusicTrackList = false;
      this.showUsageList = false;
      this.showMusicAlbumList = true;
      if (data == 'musicalbum' && this.isFirstClickedmusicalbum == false) {
        this.requestAlbumListMethod();
      }
    }
  }

  requestMusicListMethod() {
    debugger;
    this.load = true;
    var requestMusicListBody = {
      MHRequestTypeCode: '2'
    }
    this.load = true; this._requisitionService.GetMovieAlbumMusicList(requestMusicListBody).subscribe(response => {
      this.load = false;
      this.isFirstClickedmusictrack = true;
      this.requestMusicList = response.RequestList;
      this.totalCountOfMusicTrack = response.RequestList.length;
    }, error => { this.handleResponseError(error) });
  }

  requestAlbumListMethod() {
    this.load = true;
    var requestAlbumListBody = {
      MHRequestTypeCode: '3'
    }
    this._requisitionService.GetMovieAlbumMusicList(requestAlbumListBody).subscribe(response => {
      this.load = false;
      this.isFirstClickedmusicalbum = true;
      this.requestAlbumList = response.RequestList;
      this.totalCountofMovieAlbum = response.RequestList.length;
    }, error => { this.handleResponseError(error) });
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
