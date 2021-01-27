import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute, ParamMap } from '@angular/router';
import { AuthenticationService } from '../../shared/services/authentication.service';
declare var $: any;
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators'
import { ComParentChildService } from '../../shared/services/comparentchild.service';
import { RequisitionService } from '../../requisition/requisition.service';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css'],
  providers: [AuthenticationService, ComParentChildService, RequisitionService]
})
export class HeaderComponent implements OnInit {
  public productionHouseName;
  public userName;
  public userDetails: any;
  public Request;
  public displayalertMessage: boolean = false;
  public messageData: any;
  public notificationList: any;
  public ChangePSW;
  public unreadCount = 0;
  public ImageUrl: any = '';
  public formData;
  userImage = "User_Img.png";
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
  public HeaderContent: any;
  public requestCountSearch;
  public searchMusicDetail: any;
  public searchAlbumDetail: any;
  public RemarkSpecialInstruction: any = [];
  public remarksLabel: any;
  public specialRemarks: any;
  public reuestID: any;
  public requsetdetails:any;

  constructor(private router: Router, private authenticationService: AuthenticationService, private comparentchildservice: ComParentChildService, private _requisitionService: RequisitionService) {
  }
  public count = 0;
  ngOnInit() {
    debugger;

    this.ChangePSW = sessionStorage.getItem('CHANGEPSW_STATUS');
    this.router.events.subscribe((res) => {

      this.Request = this.router.url;
    })


    this.productionHouseName = localStorage.getItem('ProductionName');
    this.userName = localStorage.getItem('loginName');
    //this method is call when you call method of parent from child component or another component
    this.comparentchildservice.on('call-notification').subscribe(() => this.Notification());

    this.Notification();
    if (localStorage.getItem('USERS_IMAGE') == null || localStorage.getItem('USERS_IMAGE') == undefined || localStorage.getItem('USERS_IMAGE') == "" || localStorage.getItem('USERS_IMAGE') == "null") {
      this.userImage = "User_Img.png";
      this.ImageUrl = "../../../assets/Images/" + this.userImage;
    }
    else {
      this.userImage = localStorage.getItem('USERS_IMAGE');
      this.ImageUrl = "../../../assets/Images/" + this.userImage;
    }
    //this.ImageUrl = "../../../assets/Images/User_Img.png";
    this.removeScroll();
  }

  Notification() {
    if (this.ChangePSW != 'Y') {
      var notificationBody = {
        "RecordFor": "N"
      }
      this.authenticationService.getNotificationRequestList(notificationBody).subscribe(response => {
        console.log("Notification List");
        console.log(response);
        this.notificationList = response.NotifiactionList;
        this.unreadCount = response.UnReadCount;
        this.removeScroll();
        $('.slimScrollDiv').css("height", "42px !important");
        console.log(this.unreadCount)
      }, error => { this.handleResponseError(error) })

      // this.unreadCount=this.authenticationService.getNotificationRequestList(notificationBody).pipe(map((channelsOutput) => {
      //   console.log("Mapping")
      //   console.log(channelsOutput.UnReadCount)
      //   return channelsOutput.UnReadCount;
      // }));
    }
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

  // onNewRequestClick() {
  //   this.router.navigate(['/app/requisition/new-music-track']);
  // }
  Toggleclick() {
    // $( "body" ).toggleClass( "fixed" );

  }
  public alertHeader: any = '';
  public alertMessage: any = '';
  public displayMessage: boolean = false;
  public load: boolean = false;
  notificationDetails(code, MHRequestTypeCode, MHRequestCode) {
    debugger;
    console.log(code);
    this.displayMessage = true;
    this.MHRequestCode = MHRequestCode;
    this.MHRequestTypeCode = MHRequestTypeCode;

    var notificationDetail = {
      "MHNotificationLogCode": code
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
      console.log(notifybody);
      $("#NotifyMessage").html("" + notifybody + "");
      this.load = false;
      this.removeBlockUI();
      // this.alertMessage=response.NotificationDetail.Email_Body;
      // this.alertMessage="Notification Details..!!!"
    }, error => { this.handleResponseError(error) })
    // this.displayalertMessage=true;
    // this.messageData = {
    //   'header': "Notification Details",
    //   'body': "Request is Approved....!!!!"
    // }

  }

  removeScroll() {
    $(function () {
      $('.slimScrollDiv').slimScroll({
        height: '42px !important',

      });
    });
  }

  showRequsetDetails() {
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
        "MHRequestTypeCode": this.MHRequestTypeCode
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
        "MHRequestTypeCode": this.MHRequestTypeCode
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
        "MHRequestTypeCode": this.MHRequestTypeCode
      }
      this._requisitionService.GetNotificationHeader(obj).subscribe(response => {
        this.HeaderContent = response.Header;
      }, error => { this.handleResponseError(error) });
    }

  }

  filter(listFilter, filterby) {
    debugger;
    if (filterby == 'musicDetail') {
      this.musicDetailFilterList = this.musicDetailList.filter(item => (item.RequestedMusicTitleName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
        || item.ApprovedMusicTitleName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
        || item.MusicLabelName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
        || item.MusicMovieAlbumName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
        || item.CreateMap.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
        || item.IsApprove.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      ))
    }
    else if (filterby == 'albumDetail') {
      this.albumDetailFilterList = this.albumDetailList.filter(item => (item.RequestedMovieAlbumName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
        || item.ApprovedMovieAlbumName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
        || item.MovieAlbum.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
        || item.CreateMap.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
        || item.IsApprove.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      ))
    }
  }

  closeConsumption() {
    this.showRequestCountDetails = false;
  }

  closeMusicDetails() {
    this.dialogRequestDetail = false;
  }

  viewAllClick() {
    this.router.navigate(['/app/notification-list']);
  }
  unsetCredentials() {
    var details;
    details = localStorage.getItem('USER_SESSION');
    this.userDetails = JSON.parse(details);
    this.authenticationService.logout({ 'LoginDetailsCode': this.userDetails.LoginDetailsCode }).subscribe(response => {
      console.log("Logout Response");
      console.log(response);
      if (response.User.IsSuccess) {
        sessionStorage.clear();
        localStorage.removeItem('USER_SESSION');
        localStorage.removeItem('USER_RIGHTS');
        localStorage.removeItem('SYSTEM_CONFIG');
        localStorage.removeItem('AUTH_TOKEN');
        localStorage.removeItem('EXPIRE_TIME');
        this.router.navigate(['/login']);
      }

    }, error => { this.handleResponseError(error) });


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

  fileCheck(event) {
    debugger;
    var fileExtension = ['jpeg', 'jpg', 'png', 'gif', 'bmp'];
    const file = event.target.files[0]

    if (!fileExtension.includes(file.name.split('.')[1])) {
      alert("Only '.jpeg','.jpg', '.png', '.gif', '.bmp' formats are allowed.");
      return false;
    }
    else {
      this.ImageUrl = event.target.value;
      if (event.target.files && event.target.files[0]) {
        var reader: any;
        reader = new FileReader();
        reader.readAsDataURL(event.target.files[0]); // read file as data url
        reader.onload = (event) => { // called once readAsDataURL is completed
          this.ImageUrl = event.target.result;
        }
      }
    }
    this.submit(event, "");
    return true;
  }

  submit(event, chooseUpload) {
    this.formData = new FormData();
    let fileList: FileList = event.target.files;
    if (fileList.length > 0) {
      let file: File = fileList[0];
      this.formData.append('UploadFile', file, file.name);
      this.formData.append('UsersCode', localStorage.getItem('USERS_CODE'));
    }
    this.authenticationService.uploadImage(this.formData).subscribe(response => {
      localStorage.setItem('USERS_IMAGE', response.User.User_Image);
    }, error => { this.handleResponseError(error) });
  }

  getUsageroutelink(url){
    debugger;
    this.router.navigate([url]);
    localStorage.setItem('VIEW_ALL_REQUEST', 'false');
  }
}
