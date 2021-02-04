import { Component, OnInit, OnDestroy } from '@angular/core';
import { MusicAssignmentService } from '../music-assignment.service'
import { FormsModule, Validators, FormGroup, FormControl, FormBuilder } from '@angular/forms';
import { DatePipe } from '@angular/common';

import { Router } from '@angular/router'

@Component({
  selector: 'app-music-assignment',
  templateUrl: './music-assignment.component.html',
  styleUrls: ['./music-assignment.component.css'],
  providers: [MusicAssignmentService]
})
export class MusicAssignmentComponent implements OnInit {

  public fa: any;
  public spinner: any;
  public visibleSidebar2: boolean = false;
  changeEventData;
  formData;
  uploadedFilesList = [];
  fileUploadDialog: boolean = false;
  replaceCode;
  alertMessage;
  alertHeader;
  remarks;
  validateUploadRemark: boolean = false;
  textRemarkCount = 0;
  messageDialog: boolean = false;
  upload: boolean = false;
  load: boolean = false;
  
  approvalCueSheetCode;
  public recordCountmusic = 0;
  public rowonpage = 10;
  public first = 0;
  public Status: any = [];
  public displayalertMessage: Boolean = false;
  public messageData: any;
  public exportPageSize = 10;
  public exportPageNo = 1;
  public timer;
  public termsTextFirst: string;
  public termsTextSecond: string;
  public productionHouseName;
  public sortingDefault: boolean = false;
  public order: any;
  public sortBy: any;
  public downloadURLPath: any;
  public showDownloaderror: boolean = false;

  constructor(private _musicAssignmentService: MusicAssignmentService, private router: Router) {
    this.Status = [
      { label: 'Pending', value: 'P' },
      { label: 'Data Error', value: 'D' },
      { label: 'Submit', value: 'S' }
    ];
    this.timer = setInterval(() => { this.cueSheetStatusCheck() }, 2000);

  }
  ngOnDestroy() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }
  ngOnInit() {
    this.sortingDefault = true;

    this.cueSheetList(25, 1);
  }

  ngAfterViewInit() {

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
  
  remarkChange() {
    if (this.remarks.trim().length == 0) {
      this.remarks = '';
      this.validateUploadRemark = true;

    }
    else {
      this.validateUploadRemark = false;
    }

    this.textRemarkCount = this.remarks.trim().length;
  }
  public termCondition: boolean = false;
  submit(event, chooseUpload) {
    // alert(this.termCondition)
    if (this.termCondition == true) {
      console.log(event);
      this.formData = new FormData();
      let fileList: FileList = event.target.files;
      if (fileList.length > 0) {
        let file: File = fileList[0];
        console.log(file);
        if (!this.replaceCode) {
          this.formData.append('CueSheetCode', 0);
          this.formData.append('UploadFile', file, file.name);
        } else if (this.replaceCode) {
          this.formData.append('CueSheetCode', this.replaceCode);
          this.formData.append('UploadFile', file, file.name);
        }

        if (file.type == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet") {
          this.upload = true;
          this.addBlockUI();
          this._musicAssignmentService.uploadFile(this.formData).subscribe(response => {
            this.upload = false;
            this.removeBlockUI();
            this.fileUploadDialog = false;
            this.remarks = ''
            this.textRemarkCount = 0;
            chooseUpload.value = '';
            this.displayalertMessage = true;
            this.messageData = {
              'header': "Message",
              'body': response.Return.Message
            }
            this.cueSheetList(25, 1);

          }, error => { this.handleResponseError(error) });
        }
        else {
          this.displayalertMessage = true;
          this.messageData = {
            'header': "Message",
            'body': "Please upload excel formatted file"
          }
        }

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

  cueSheetList(PageSize, PageNo) {
    this.exportPageSize = PageSize;
    this.exportPageNo = PageNo;
    var demoList = []
    this.load = true;
    this.addBlockUI();
    var cuesheetbody;
    if (this.sortingDefault == true) {
      this.sortBy = "RequestedDate";
      this.order = "DESC";
    }
    else {
      this.order = this.order;
      this.sortBy = this.sortBy;
    }
    if (this.searchClickevent == 'N') {
      cuesheetbody =
      {
        "PagingRequired": "Y",
        "PageSize": PageSize,
        "PageNo": PageNo,
        "StatusCode": '',
        "FromDate": "",
        "ToDate": "",
        "SortBy": this.sortBy,
        "Order": this.order
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
        "ToDate": this.searchcueSheetBody.ToDate,
        "SortBy": this.sortBy,
        "Order": this.order
      }
    }

    console.log(JSON.stringify(cuesheetbody));
    this._musicAssignmentService.getCueSheetList(cuesheetbody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      console.log(response);
      // this.uploadedFilesList = response.CueSheet;
      this.recordCountmusic = response.RecordCount
      demoList = response.CueSheet;
      demoList.forEach(x => x.successPercent = x.SuccessRecords != 0 ? (x.SuccessRecords / x.TotalRecords) * 100 : 0)
      demoList.forEach(x => x.errorPercent = x.ErrorRecords != 0 ? (x.ErrorRecords / x.TotalRecords) * 100 : 0)
      demoList.forEach(x => x.warningPercent = x.WarningRecords != 0 ? (x.WarningRecords / x.TotalRecords) * 100 : 0)
      demoList.forEach(x => x.defaultPercent = x.SuccessRecords == 0 && x.ErrorRecords == 0 && x.WarningRecords == 0 ? 100 : 0)
      demoList.forEach(x => x.defaultRecord = x.SuccessRecords == 0 && x.ErrorRecords == 0 && x.WarningRecords == 0 ? 'NA' : '')
      this.uploadedFilesList = demoList;
      console.log("this update cue sheet");
      console.log(this.uploadedFilesList);
      // this.checkstatus()      ;
    }, error => { this.handleResponseError(error) });
  }
  // checkstatus(){

  //for refreshing list
  cueSheetStatusCheck() {
    console.log("Status Check execution");
    console.log(this.uploadedFilesList);
    for (let i = 0; i < this.uploadedFilesList.length; i++) {

      if (this.uploadedFilesList[i].RecordStatus == 'P') {
        this._musicAssignmentService.getCueSheetStatus({ MHCueSheetCode: this.uploadedFilesList[i].MHCueSheetCode }).subscribe(response => {
          this.load = false;
          this.removeBlockUI();
          console.log("response Status");
          console.log(response.CueSheet.RecordStatus);
          if (response.CueSheet.RecordStatus != 'P') {

            this.uploadedFilesList[i].ErrorRecords = response.CueSheet.ErrorRecords;
            this.uploadedFilesList[i].FileName = response.CueSheet.FileName;
            this.uploadedFilesList[i].MHCueSheetCode = response.CueSheet.MHCueSheetCode;
            this.uploadedFilesList[i].RecordStatus = response.CueSheet.RecordStatus;
            this.uploadedFilesList[i].RequestID = response.CueSheet.RequestID;
            this.uploadedFilesList[i].RequestedBy = response.CueSheet.RequestedBy;
            this.uploadedFilesList[i].RequestedDate = response.CueSheet.RequestedDate;
            this.uploadedFilesList[i].Status = response.CueSheet.Status;
            this.uploadedFilesList[i].SuccessRecords = response.CueSheet.SuccessRecords;
            this.uploadedFilesList[i].TotalRecords = response.TotalRecords;
            this.uploadedFilesList[i].WarningRecords = response.CueSheet.WarningRecords;
            this.uploadedFilesList[i].successPercent = response.CueSheet.SuccessRecords != 0 ? (response.CueSheet.SuccessRecords / response.CueSheet.TotalRecords) * 100 : 0;
            this.uploadedFilesList[i].errorPercent = response.CueSheet.ErrorRecords != 0 ? (response.CueSheet.ErrorRecords / response.CueSheet.TotalRecords) * 100 : 0;
            this.uploadedFilesList[i].warningPercent = response.CueSheet.WarningRecords != 0 ? (response.CueSheet.WarningRecords / response.CueSheet.TotalRecords) * 100 : 0;
            this.uploadedFilesList[i].defaultPercent = response.CueSheet.SuccessRecords == 0 && response.CueSheet.ErrorRecords == 0 && response.CueSheet.WarningRecords == 0 ? 100 : 0;
            this.uploadedFilesList[i].defaultRecord = response.CueSheet.SuccessRecords == 0 && response.CueSheet.ErrorRecords == 0 && response.CueSheet.WarningRecords == 0 ? 'NA' : '';
          }

        }, error => { this.handleResponseError(error) });
      }
    }
  }


  addBlockUI() {
    $('body').addClass("overlay");
    $('body').on("keydown keypress keyup", false);
  }
  removeBlockUI() {
    $('body').removeClass("overlay");
    $('body').off("keydown keypress keyup", false);
  }
 
  public searchClickevent: any = 'N';
  public searchcueSheetBody;
  searchClick() {
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
  searchClickValidation() {
    debugger;
    this.searchClickevent = 'Y';
    localStorage.setItem('SEARCH_DATA', this.searchClickevent);
    var datePipe = new DatePipe('en-GB');
    console.log(this.searchToDate);

    var cuesheetbody =
    {

      "StatusCode": this.searchStatus.toString(),
      "FromDate": this.searchFromDate == null ? '' : datePipe.transform(this.searchFromDate.toString(), 'dd-MMM-yyyy'),
      "ToDate": this.searchToDate == null ? '' : datePipe.transform(this.searchToDate.toString(), 'dd-MMM-yyyy')

    }
    this.searchcueSheetBody = cuesheetbody;
    console.log(JSON.stringify(cuesheetbody));
    this.cueSheetList(25, 1);
  }
  public searchFromDate: any;
  public searchToDate: any;
  public searchStatus: any = [];
  clearAllClick() {
    // alert("clear All things..");
    this.searchClickevent = 'N';
    this.searchFromDate = null;
    this.searchToDate = null;
    this.searchStatus = '';
    this.cueSheetList(25, 1);
  }
  exportToExcel() {
    this.load = true;
    this.addBlockUI();
    var exportcuesheetbody;
    if (this.sortingDefault == true) {
      this.sortBy = "RequestedDate";
      this.order = "DESC";
    }
    else {
      this.order = this.order;
      this.sortBy = this.sortBy;
    }
    if (this.searchClickevent == 'N') {
      exportcuesheetbody =
      {
        "PagingRequired": "Y",
        "PageSize": this.exportPageSize,
        "PageNo": this.exportPageNo,
        "StatusCode": '',
        "FromDate": "",
        "ToDate": "",
        "SortBy": this.sortBy,
        "Order": this.order

      }
    }
    else if (this.searchClickevent == 'Y') {
      exportcuesheetbody =
      {
        "PagingRequired": "Y",
        "PageSize": this.exportPageSize,
        "PageNo": this.exportPageNo,
        "StatusCode": this.searchcueSheetBody.StatusCode,
        "FromDate": this.searchcueSheetBody.FromDate,
        "ToDate": this.searchcueSheetBody.ToDate,
        "SortBy": this.sortBy,
        "Order": this.order
      }
    }
    console.log(exportcuesheetbody);
    this._musicAssignmentService.getExportCueSheetList(exportcuesheetbody).subscribe(response => {
      debugger;
      this.load = false;
      this.removeBlockUI();
      console.log("Export Response");
      console.log(response);
      this.Download(response.Return.Message)
    }, error => { this.handleResponseError(error) });
  }
  Download(b) {
    debugger;
    window.location.href = (this._musicAssignmentService.DownloadFile().toString() + b).toString();
  }
  
  downloadFile(filePath) {
    debugger;
    var link = document.createElement('a');
    link.href = filePath;
    link.click();
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
