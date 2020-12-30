import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute, ParamMap } from '@angular/router';
import { AuthenticationService } from '../../shared/services/authentication.service';
declare var $: any;
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators'
import {ComParentChildService} from '../../shared/services/comparentchild.service'
@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css'],
  providers: [AuthenticationService,ComParentChildService]
})
export class HeaderComponent implements OnInit {
  public productionHouseName;
  public userName;
  public userDetails: any;
  public Request;
  public displayalertMessage:boolean=false;
  public messageData: any;
  public notificationList:any;
  public ChangePSW;
  public unreadCount=0;
  constructor(private router: Router, private authenticationService: AuthenticationService,private comparentchildservice: ComParentChildService) {
   }
  public count = 0;
  ngOnInit() {
    this.ChangePSW=sessionStorage.getItem('CHANGEPSW_STATUS');
    this.router.events.subscribe((res) => { 
     
      this.Request=this.router.url;
  })
    

    this.productionHouseName = localStorage.getItem('ProductionName');
    this.userName = localStorage.getItem('loginName');
//this method is call when you call method of parent from child component or another component
    this.comparentchildservice.on('call-notification').subscribe(() => this.Notification());
    
    this.Notification();
  
  }

  Notification(){
    if(this.ChangePSW !='Y'){
      var notificationBody={
        "RecordFor":"N"
      }
        this.authenticationService.getNotificationRequestList(notificationBody).subscribe(response=>{
          console.log("Notification List");
          console.log(response);
          this.notificationList=response.NotifiactionList;
          this.unreadCount=response.UnReadCount;
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
    if (errorCode == 403 ) {
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
  public alertHeader:any='';
  public alertMessage:any='';
  public displayMessage:boolean=false;
  public load: boolean = false;
  notificationDetails(code){
    console.log(code);
    this.displayMessage = true; 
    var notificationDetail={
      "MHNotificationLogCode":code
    }
    this.load = true;
    this.addBlockUI();
    this.authenticationService.readNotification(notificationDetail).subscribe(response=>{
      console.log("Notification Details..!!!");
      console.log(response);
      this.alertHeader=response.NotificationDetail.Subject;
      var notifybody=response.NotificationDetail.Email_Body;
      console.log(notifybody);
      $("#NotifyMessage").html(""+notifybody+"");
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
  viewAllClick(){
    this.router.navigate(['/app/notification-list']);
  }
  unsetCredentials() {
    var details;
    details = localStorage.getItem('USER_SESSION');
    this.userDetails=JSON.parse(details);
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
  alertClose(){
    this.displayMessage=false;

  }
  addBlockUI() {
    $('body').addClass("overlay");
    $('body').on("keydown keypress keyup", false);
  }
  removeBlockUI() {
    $('body').removeClass("overlay");
    $('body').off("keydown keypress keyup", false);
  }
}
