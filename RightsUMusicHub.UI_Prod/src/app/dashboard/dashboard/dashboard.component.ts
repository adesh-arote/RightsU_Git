import { Component, OnInit, } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { RequisitionService } from '../../requisition/requisition.service';
import { DashboardService } from '../dashboard.service';
import { ChartModule } from 'primeng/chart';
import { element } from 'protractor';
import { parse } from 'url';
import { Response } from '@angular/http';
import { ConfirmationService } from 'primeng/api';

declare var $: any;
declare var google: any;
@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css'],
  providers: [RequisitionService, DashboardService, ConfirmationService],

})


export class DashboardComponent implements OnInit {

  public reqCountSearch: any;
  public data: any;
  public bardata: any;
  public items: any[];
  public damyList: any[] = [];
  public showList;
  public getshowlist;
  public requestList = [];
  public requestCountList = [];
  public load: boolean = false;
  public showRequestCountDetails = false;
  public pieChartData = [];
  public requestCountHeader: any;
  public totalCountOfNoOfSongsDetails = 0;
  public countList: any;
  public BarChartDataOnText = "Monthly";
  public pieChartDataOnText = "Monthly";
  public BarChartDataOn = 1;
  public pieChartDataOn = 1;
  public dataRequest = "1";
  public barDataRequest = "1";
  public slicelist: any = [];
  public TalentName;
  public sortingDefault: boolean = false;
  public order: any;
  public sortBy: any;

  constructor(private router: Router, private _requisitionService: RequisitionService,
    private _dashboardService: DashboardService, private _confirmation: ConfirmationService) {


  }

  ngOnInit() {

    this.sortingDefault = true;

    var channelBody = {
      'Channel_Code': 0
    }



    this.load = true;
    this.addBlockUI();
    this._requisitionService.getShowName(channelBody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      this.getshowlist = response.Show;
      this.showList = response.Show;

      console.log(this.showList);
      $(function () {
        $('.topShowCss').slimScroll({
          height: '100px',

        });
      });
      this.limitedshowlist(9)
    }, error => { this.handleResponseError(error) })

    this.load = true;
    this.addBlockUI();
    if (this.sortingDefault == true) {
      this.sortBy = "RequestDate";
      this.order = "DESC";
    }
    else {
      this.sortBy = this.sortBy;
      this.order = this.order;
    }
    var requestListBody =
    {
      "RecordFor": "D",
      "PagingRequired": "Y",
      "PageSize": "10",
      "PageNo": 1,
      "RequestID": "",
      "ChannelCode": '',
      "ShowCode": '',
      "StatusCode": '',
      "FromDate": "",
      "ToDate": "",
      "SortBy": this.sortBy,
      "Order": this.order
    }

    this._dashboardService.getRequestList(requestListBody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      console.log("list response");
      console.log(response);
      this.requestList = response.RequestList;
      this.sortingDefault=false;
    }, error => { this.handleResponseError(error) })






  }


  getBarChartDataMethod(searchBarChartCriteria, searchstring) {
    this.BarChartDataOnText = searchstring;
    this.BarChartDataOn = searchBarChartCriteria;
    this.barDataRequest = searchBarChartCriteria;
  }

  getPieChartDataMethod(searchPieChartCriteria, searchstring) {
    this.pieChartDataOnText = searchstring;
    this.pieChartDataOn = searchPieChartCriteria;
    this.dataRequest = searchPieChartCriteria;
  }



  searchList() {

    this.showList = this.filtermethod()

  }
  filtermethod() {
    var searchText = this.TalentName.toLowerCase();
    return this.getshowlist.filter(it => {

      return it.Title_Name.toLowerCase().includes(searchText);

    });
  }
  limitedshowlist(filterListValue) {
    this.slicelist = [];
    let k = filterListValue / 3;
    let j = 0;
    let check = 0;

    for (let i = 0; i < k; i++) {
      debugger;
      // console.log(j);
      if (i == 0) {
        if ((i + 1) * 3 <= this.showList.length) {
          this.slicelist.push({ from: i, to: i + 3 });
          j = i + 2;
          check = i + 2;
        }
        else if (this.showList.length >= check && this.showList.length < ((i + 1) * 3)) {
          this.slicelist.push({ from: i, to: i + 3 });
          j = i + 2;
          check = i + 2;
          // j=i+2;
        }
        else {
          this.slicelist.push({ from: 0, to: 0 });

        }

      }
      else {
        if ((i + 1) * 3 <= this.showList.length) {
          j = j + 1;
          this.slicelist.push({ from: j, to: j + 3 });
          j = j + 2;
          check = j + 2;
        }
        else if (this.showList.length >= check && this.showList.length < ((i + 1) * 3)) {
          j = j + 1;
          this.slicelist.push({ from: j, to: j + 3 });
          j = j + 2;
          check = j + 2;
        }
        else {
          this.slicelist.push({ from: 0, to: 0 });

        }


      }
    }
  }

  divArray(count) {
    return Array(count);
  }
  quickSelection(listdata) {
    // alert(listdata.Title_Code);
    localStorage.setItem('showData', JSON.stringify(listdata));
    var ValidShow = {
      'TitleCode': listdata.Title_Code
    }
    // console.log(ValidShow);
    this._dashboardService.checkPlayList(ValidShow).subscribe(Response => {
      if (Response.Return.IsSuccess == true) {
        this.router.navigate(['/app/dashboard/quick-selection']);
      }
      else if (Response.Return.IsSuccess == false) {
        localStorage.setItem('quickChannelCode', Response.ChannelCode);
        localStorage.setItem('quickSelreq', 'Y');
        this.router.navigate(['/app/requisition/new-request']);
        // this._confirmation.confirm({
        //   message: 'Play list not created for this Show, Would you like to add Usage Request or Play list for this Show ?',
        //   header: 'Confirmation',
        //   icon: 'pi pi-exclamation-triangle',
        //   accept: () => {
        //     debugger;

        //   },
        //   // reject: () => {
        //   //    this.msgs = [{ severity: 'info', summary: 'Rejected', detail: 'You have rejected' }];
        //   // }
        // });
      }
    },
      error => { this.handleResponseError(error) }
    );

  }

  filter(listFilter, type) {

    //console.log(JSON.stringify(listFilter));
    debugger;
    if (type = 'reqCount') {
      debugger
      this.requestCountList = this.countList.filter(item => (item.RequestedMusicTitle.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
        || item.MusicMovieAlbum.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
        || item.LabelName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
        || item.IsApprove.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1)
      );
    }
  }
  requestCountDetails(rowdata, IsCueSheet) {
    this.load = true;
    this.addBlockUI();
    this._requisitionService.getRequestCountDetails({ MHRequestCode: rowdata.RequestCode, IsCueSheet: IsCueSheet }).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      this.requestCountList = response.RequestDetails;
      this.countList = response.RequestDetails;
      this.totalCountOfNoOfSongsDetails = response.RequestDetails.length;
      this.showRequestCountDetails = true;
      this.requestCountHeader = rowdata.RequestID + ' / ' + rowdata.ChannelName + ' / ' + rowdata.Title_Name + ' ( ' + (rowdata.EpisodeFrom == rowdata.EpisodeTo ? rowdata.EpisodeFrom : rowdata.EpisodeFrom + ' To ' + rowdata.EpisodeTo) + ' )'

      // this.cartListCount = 0;
    }, error => { this.handleResponseError(error) });
  }

  onNewRequestClick() {
    this.router.navigate(['/app/requisition/new-request']);
  }
  onViewAllRequestClick() {
    this.router.navigate(['/app/reports/authorized-report']);
  }
  addBlockUI() {
    $('body').addClass("overlay");
    $('body').on("keydown keypress keyup", false);
  }
  removeBlockUI() {
    $('body').removeClass("overlay");
    $('body').off("keydown keypress keyup", false);
  }
  close() {
    this.showRequestCountDetails = false;
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

