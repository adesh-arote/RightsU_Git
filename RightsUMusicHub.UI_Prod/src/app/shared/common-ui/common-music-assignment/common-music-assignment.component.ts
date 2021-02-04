import { Component, OnInit, Input } from '@angular/core';
import { Router } from '@angular/router';
import { MusicAssignmentService } from '../../../music-assignment/music-assignment.service';
import { DatePipe } from '@angular/common';

@Component({
  selector: 'app-common-music-assignment',
  templateUrl: './common-music-assignment.component.html',
  styleUrls: ['./common-music-assignment.component.css'],
  providers: [MusicAssignmentService]
})
export class CommonMusicAssignmentComponent implements OnInit {

  public uploadedFilesList: any = [];
  public recordCountmusic: any;
  public order: any;
  public sortBy: any;
  public sortingDefault: boolean = false;
  public rowonpage = 10;
  public first = 0;
  public exportPageSize = 10;
  public exportPageNo = 1;
  public load: boolean = false;
  public searchClickevent: any = 'N';
  public searchcueSheetBody: any;
  public searchStatus: any = [];
  public searchFromDate: any;
  public searchToDate: any;
  public countGridSearch;
  public totalCountRecord = 0;
  public errorCountList: any;
  public viewCueSheetList = [];
  public cueSheetViewDialog: boolean = false;
  public alertHeader: any;
  public termCondition: boolean = false;
  public fileUploadDialog: boolean = false;
  public replaceCode;
  public textRemarkCount = 0;
  public termsTextFirst: string;
  public termsTextSecond: string;
  public productionHouseName;
  public downloadURLPath: any;
  public showDownloaderror: boolean = false;
  public sendForApprovalDialog: boolean = false;
  public approvalCueSheetCode: boolean = false;
  public displayalertMessage: Boolean = false;
  public remarks: any;
  public messageData: any;
  public searchText: any;

  @Input() set musicassignmentDetails(data) {
    this.uploadedFilesList = data;
  }

  @Input() set totalRecords(data) {
    debugger;
    this.recordCountmusic = data;
  }


  constructor(private _musicAssignmentService: MusicAssignmentService, private router: Router) { }

  ngOnInit() {
    this.sortingDefault = true;
    this.searchClickevent = 'N';
    localStorage.setItem('SEARCH_DATA', this.searchClickevent);
  }

  loadDataOnPagination(event) {
    debugger;
    var pageNo = event.first;
    var pageSize = event.rows;
    var sortBy = event.sortField;
    this.sortBy = sortBy;
    if (this.sortingDefault == true) {
      this.sortBy = "RequestedDate";
      this.order = "DESC";
    }
    else {
      if (event.sortField == undefined) {
        this.sortBy = "RequestedDate";
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


  onpagechange(pageSize, pageNo) {
    debugger;
    this.exportPageSize = pageSize;
    this.exportPageNo = pageNo;
    this.load = true;
    var demoList = [];
    var datePipe = new DatePipe('en-GB');
    this.searchClickevent = localStorage.getItem('SEARCH_DATA');
    var cuesheetbody =
    {

      "StatusCode": this.searchStatus.toString(),
      "FromDate": this.searchFromDate == null ? '' : datePipe.transform(this.searchFromDate.toString(), 'dd-MMM-yyyy'),
      "ToDate": this.searchToDate == null ? '' : datePipe.transform(this.searchToDate.toString(), 'dd-MMM-yyyy')

    }
    this.searchcueSheetBody = cuesheetbody;
    var dataObj;
    if (this.searchClickevent == 'N') {
      dataObj =
      {
        "PagingRequired": "Y",
        "PageSize": pageSize,
        "PageNo": pageNo,
        "StatusCode": '',
        "FromDate": "",
        "ToDate": "",
        "SortBy": this.sortBy,
        "Order": this.order

      }
    }
    else if (this.searchClickevent == 'Y') {
      dataObj =
      {
        "PagingRequired": "Y",
        "PageSize": pageSize,
        "PageNo": pageNo,
        "StatusCode": this.searchcueSheetBody.StatusCode,
        "FromDate": this.searchcueSheetBody.FromDate,
        "ToDate": this.searchcueSheetBody.ToDate,
        "SortBy": this.sortBy,
        "Order": this.order
      }
    }
    this._musicAssignmentService.getCueSheetList(dataObj).subscribe(response => {
      this.load = false;
      this.recordCountmusic = response.RecordCount;
      this.sortingDefault = false;
      demoList = response.CueSheet;
      demoList.forEach(x => x.successPercent = x.SuccessRecords != 0 ? (x.SuccessRecords / x.TotalRecords) * 100 : 0)
      demoList.forEach(x => x.errorPercent = x.ErrorRecords != 0 ? (x.ErrorRecords / x.TotalRecords) * 100 : 0)
      demoList.forEach(x => x.warningPercent = x.WarningRecords != 0 ? (x.WarningRecords / x.TotalRecords) * 100 : 0)
      demoList.forEach(x => x.defaultPercent = x.SuccessRecords == 0 && x.ErrorRecords == 0 && x.WarningRecords == 0 ? 100 : 0)
      demoList.forEach(x => x.defaultRecord = x.SuccessRecords == 0 && x.ErrorRecords == 0 && x.WarningRecords == 0 ? 'NA' : '')
      this.uploadedFilesList = demoList;
    }, error => { this.handleResponseError(error) });
  }

  viewRecords(headerString, rowdata, type) {
    this.load = true;
    this.searchText = null;
    this._musicAssignmentService.getCueSheetSongDetails({ MHCueSheetCode: rowdata.MHCueSheetCode, ViewOn: type }).subscribe(response => {
      this.load = false;
      this.countGridSearch = '';
      this.viewCueSheetList = response.CueSheetSongs;
      this.errorCountList = response.CueSheetSongs;
      this.totalCountRecord = response.CueSheetSongs.length;
      this.cueSheetViewDialog = true;
      this.alertHeader = headerString + ' for : ' + rowdata.RequestID;
    }, error => { this.handleResponseError(error) });
  }

  alertClose() {
    this.cueSheetViewDialog = false;
  }

  uploadFile(id) {
    debugger;
    this.termCondition = false;
    this.fileUploadDialog = true;
    this.replaceCode = id;
    this.textRemarkCount = 0;
    this.productionHouseName = localStorage.getItem('ProductionName');
    this.termsTextFirst = "I hereby understand, accept and abide by the terms & conditions granted by Viacom18 Media Pvt Ltd for the consumption of music songs embedded within the said episode of the given program. The declaration is on behalf of the";
    this.termsTextSecond = "& its associated affiliates."
    if (!this.replaceCode) {
      this.alertHeader = "Upload file";
    } else if (this.replaceCode) {
      this.alertHeader = "Replace file";
    }
  }

  downLoadFile(data) {
    debugger;
    let dataObj = {
      "MHCueSheetCode": data
    }
    this.load = true;
    this._musicAssignmentService.DownloadCuesheet(dataObj).subscribe(outputData => {
      this.load = false;
      this.downloadURLPath = outputData.FilePath;
      if (this.downloadURLPath != "") {
        window.location.href = (this._musicAssignmentService.DownloadFileNew().toString() + this.downloadURLPath).toString();
      }
      else {
        this.showDownloaderror = true;
      }
    }, error => { this.handleResponseError(error) });
  }

  sendToApproval(cueSheetCode) {
    this.alertHeader = "Send for approval"
    this.sendForApprovalDialog = true;
    this.approvalCueSheetCode = cueSheetCode;
  }

  submitForApproval() {
    this.sendForApprovalDialog = false;
    this.remarks = '';
    this.load = true;
    this._musicAssignmentService.cuesheetSubmit({ MHCueSheetCode: this.approvalCueSheetCode }).subscribe(response => {
      this.load = false;
      this.displayalertMessage = true;
      this.messageData = {
        'header': "Message",
        'body': "Submitted Successfully!"
      }
      this.cueSheetList(25, 1);
    }, error => { this.handleResponseError(error) });
  }

  cueSheetList(PageSize, PageNo) {
    this.exportPageSize = PageSize;
    this.exportPageNo = PageNo;
    var demoList = []
    this.load = true;
    if (this.sortingDefault == true) {
      this.sortBy = "RequestedDate";
      this.order = "DESC";
    }
    else {
      this.order = this.order;
      this.sortBy = this.sortBy;
    }
    var cuesheetbody;
    if (this.searchClickevent == 'N') {
      cuesheetbody =
      {
        "PagingRequired": "Y",
        "PageSize": PageSize,
        "PageNo": PageNo,
        "StatusCode": '',
        "FromDate": "",
        "ToDate": ""
      }
    }
    else if (this.searchClickevent == 'Y') {
      cuesheetbody =
      {
        "PagingRequired": "Y",
        "PageSize": PageSize,
        "PageNo": PageNo,
        "StatusCode": this.searchcueSheetBody.StatusCode,
        "FromDate": this.searchcueSheetBody.FromDate,
        "ToDate": this.searchcueSheetBody.ToDate
      }
    }
    this._musicAssignmentService.getCueSheetList(cuesheetbody).subscribe(response => {
      this.load = false;
      this.recordCountmusic = response.RecordCount
      demoList = response.CueSheet;
      demoList.forEach(x => x.successPercent = x.SuccessRecords != 0 ? (x.SuccessRecords / x.TotalRecords) * 100 : 0)
      demoList.forEach(x => x.errorPercent = x.ErrorRecords != 0 ? (x.ErrorRecords / x.TotalRecords) * 100 : 0)
      demoList.forEach(x => x.warningPercent = x.WarningRecords != 0 ? (x.WarningRecords / x.TotalRecords) * 100 : 0)
      demoList.forEach(x => x.defaultPercent = x.SuccessRecords == 0 && x.ErrorRecords == 0 && x.WarningRecords == 0 ? 100 : 0)
      demoList.forEach(x => x.defaultRecord = x.SuccessRecords == 0 && x.ErrorRecords == 0 && x.WarningRecords == 0 ? 'NA' : '')
      this.uploadedFilesList = demoList;
    }, error => { this.handleResponseError(error) });
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
