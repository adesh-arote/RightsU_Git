import { Component, OnInit, ViewChild } from '@angular/core';
import { AuthenticationService } from '../../shared/services/authentication.service';
import { Router } from '@angular/router';
// import {HeaderComponent} from '../header/header.component'
import { ComParentChildService } from '../../shared/services/comparentchild.service';
import { RequisitionService } from '../../requisition/requisition.service';
declare var $: any;

@Component({
  selector: 'app-notification-list',
  templateUrl: './notification-list.component.html',
  styleUrls: ['./notification-list.component.css'],
  providers: [AuthenticationService, ComParentChildService, RequisitionService]
})
export class NotificationListComponent implements OnInit {

  // @ViewChild(HeaderComponent) 
  // private headerUI:HeaderComponent;
  public notificationList: any;
  public totalCount = 0;
  public load: boolean = false;
  public NotificationSearch: string = ""
  public showRequestCountDetails: boolean = false;
  public MHRequestCode: number;
  public MHRequestTypeCode: number;
  public requestCountFilteredList: any;
  public isMusicDetail: boolean = false;
  public isAlbumDetail: boolean = false;
  public dialogRequestDetail: boolean = false;
  public musicDetailFilterList: boolean = false;
  public albumDetailFilterList: any;
  public totalCountOfNoOfSongsDetails = 0;
  public totalMusicDetailCount = 0;
  public totalAlbumDetailCount = 0;
  public musicDetailList;
  public albumDetailList;
  public searchMusicDetail:any;
  public searchAlbumDetail:any;
  public HeaderContent:any;
  public requestCountSearch;
  public RemarkSpecialInstruction: any = [];
  public remarksLabel: any;
  public specialRemarks: any;
  public reuestID: any;
  public requsetdetails:any;

  constructor(private authenticationService: AuthenticationService, private router: Router, private comparentchildservice: ComParentChildService, private _requisitionService: RequisitionService) { }

  ngOnInit() {
    var notificationBody = {
      "RecordFor": "A"
    }

    this.load = true;
    this.addBlockUI();
    this.authenticationService.getNotificationRequestList(notificationBody).subscribe(response => {
      debugger;
      console.log("Notification List");
      console.log(response);
      this.notificationList = response.NotifiactionList;
      this.notificationFilterList = response.NotifiactionList;
      this.totalCount = response.NotifiactionList.length;

      this.load = false;
      this.removeBlockUI();
    }, error => { this.handleResponseError(error) })
  }
  changeColor(value) {
    // console.log("Colorrrrrrrrrrrrrrrrrrrrrr");
    // console.log(value)
    //  orange
    return value.IsRead == 'N' ? 'rgb(248, 175, 147)' : null
  }
  public notificationFilterList: any[];
  filter(listFilter) {
    this.notificationFilterList = this.notificationList.filter(item => (item.UserName.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.Subject.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
    )
    );
  }
  public alertHeader: any = '';

  public displayMessage: boolean = false;


  notificationDetails(code) {
    // alert("Clicik");
    console.log(code);
    this.displayMessage = true;
    this.MHRequestCode = code.MHRequestCode;
    this.MHRequestTypeCode = code.MHRequestTypeCode;
    var notificationDetail = {
      "MHNotificationLogCode": code.MHNotificationLogCode
    }
    this.load = true;
    this.addBlockUI();
    this.authenticationService.readNotification(notificationDetail).subscribe(response => {
      console.log("Notification Details..!!!");
      console.log(response);

      this.alertHeader = response.NotificationDetail.Subject;
      var header = this.alertHeader.split('-');
      this.reuestID = header[0] + "-" + header[1] + "-" + header[2] + "-" +  header[3] ;
      this.requsetdetails=header[4];
      var notifybody = response.NotificationDetail.Email_Body;
      console.log(notifybody)
      $("#NotifyMessage1").html(notifybody);
      this.load = false;
      this.removeBlockUI();
      // this.alertMessage=response.NotificationDetail.Email_Body;
      // this.alertMessage="Notification Details..!!!"
      for (let i = 0; i < this.notificationList.length; i++) {
        if (this.notificationList[i].MHNotificationLogCode == code.MHNotificationLogCode) {
          if (this.notificationList[i].IsRead == 'N') {
            this.notificationList[i].IsRead = 'Y';
          }
        }
      }
      this.comparentchildservice.publish('call-notification');
      // this.headerUI.Notification();
    }, error => { this.handleResponseError(error) })
    // this.displayalertMessage=true;
    // this.messageData = {
    //   'header': "Notification Details",
    //   'body': "Request is Approved....!!!!"
    // }

  }

  showRequsetDetails() {
    debugger;
    if (this.MHRequestTypeCode == 1) {
      this.displayMessage = false;
      this.showRequestCountDetails = true;
      this.requestCountSearch = null;
      this._requisitionService.getRequestCountDetails({ MHRequestCode: this.MHRequestCode, IsCueSheet: 'N' }).subscribe(response => {
        this.requestCountFilteredList = response.RequestDetails;
        this.totalCountOfNoOfSongsDetails = response.RequestDetails.length;
        this.RemarkSpecialInstruction = response.RemarkSpecialInstruction;
        this.remarksLabel = this.RemarkSpecialInstruction.Remarks;
        this.specialRemarks = this.RemarkSpecialInstruction.SpecialInstructions;
      }, error => { this.handleResponseError(error) }
      );
      let obj = {
        'MHRequestCode': this.MHRequestCode,
        "MHRequestTypeCode":this.MHRequestTypeCode
      }
      this._requisitionService.GetNotificationHeader(obj).subscribe(response => {
        this.HeaderContent = response.Header;
      }, error => { this.handleResponseError(error) });
    }
    else if (this.MHRequestTypeCode == 2) {
      this.displayMessage = false;
      this.dialogRequestDetail = true;
      this.isMusicDetail = true;
      this.isAlbumDetail = false;
      this.searchMusicDetail = null;
      let body = {
        'MHRequestCode': this.MHRequestCode
      }
      this._requisitionService.GetMusicTrackRequestDetails(body).subscribe(response => {
        this.musicDetailList = response.RequestDetails;
        this.musicDetailFilterList = response.RequestDetails;
        this.totalMusicDetailCount = response.RequestDetails.length;
      }, error => { this.handleResponseError(error) });
      let obj = {
        'MHRequestCode': this.MHRequestCode,
        "MHRequestTypeCode":this.MHRequestTypeCode
      }
      this._requisitionService.GetNotificationHeader(obj).subscribe(response => {
        this.HeaderContent = response.Header;
      }, error => { this.handleResponseError(error) });
    }
    else if (this.MHRequestTypeCode == 3) {
      this.displayMessage = false;
      this.dialogRequestDetail = true;
      this.isMusicDetail = false;
      this.isAlbumDetail = true;
      this.searchAlbumDetail = null;
      let body = {
        'MHRequestCode': this.MHRequestCode,
      }
      this._requisitionService.GetMovieAlbumRequestDetails(body).subscribe(response => {
        this.albumDetailList = response.RequestDetails;
        this.albumDetailFilterList = response.RequestDetails;
        this.totalAlbumDetailCount = response.RequestDetails.length;
      }, error => { this.handleResponseError(error) });
      let obj = {
        'MHRequestCode': this.MHRequestCode,
        "MHRequestTypeCode":this.MHRequestTypeCode
      }
      this._requisitionService.GetNotificationHeader(obj).subscribe(response => {
        this.HeaderContent = response.Header;
      }, error => { this.handleResponseError(error) });
    }

  }

  closeConsumption() {
    this.showRequestCountDetails = false;
  }

  closeMusicDetails() {
    this.dialogRequestDetail = false;
  }


  filterList(listFilter,filterby){
    debugger;
    if(filterby=='musicDetail'){
      this.musicDetailFilterList=this.musicDetailList.filter(item => (item.RequestedMusicTitleName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
      || item.ApprovedMusicTitleName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
      || item.MusicLabelName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.MusicMovieAlbumName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.CreateMap.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.IsApprove.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      ))
    }
    else if(filterby=='albumDetail'){
      this.albumDetailFilterList=this.albumDetailList.filter(item => (item.RequestedMovieAlbumName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
      || item.ApprovedMovieAlbumName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
      || item.MovieAlbum.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.CreateMap.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.IsApprove.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
    ))
    }
  }

  alertClose() {
    this.displayMessage = false;

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
      sessionStorage.clear();
      localStorage.clear();
      this.router.navigate(['/login']);
    }
  }

}
