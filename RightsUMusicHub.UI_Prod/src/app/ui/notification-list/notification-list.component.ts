import { Component, OnInit,ViewChild } from '@angular/core';
import { AuthenticationService } from '../../shared/services/authentication.service';
import {Router} from '@angular/router';
// import {HeaderComponent} from '../header/header.component'
import {ComParentChildService} from '../../shared/services/comparentchild.service'
declare var $: any;

@Component({
  selector: 'app-notification-list',
  templateUrl: './notification-list.component.html',
  styleUrls: ['./notification-list.component.css'],
  providers:[AuthenticationService,ComParentChildService]
})
export class NotificationListComponent implements OnInit {

  // @ViewChild(HeaderComponent) 
  // private headerUI:HeaderComponent;
  public notificationList:any;
  public totalCount=0;
  public load: boolean = false;
  public NotificationSearch:string=""
  constructor(private authenticationService: AuthenticationService,private router:Router,private comparentchildservice: ComParentChildService) { }
 
  ngOnInit() {
    var notificationBody={
      "RecordFor":"A"
    }
    
    this.load = true;
    this.addBlockUI();
    this.authenticationService.getNotificationRequestList(notificationBody).subscribe(response => {
      debugger;
        console.log("Notification List");
        console.log(response);
        this.notificationList=response.NotifiactionList;
        this.notificationFilterList=response.NotifiactionList;
        this.totalCount=response.NotifiactionList.length;
        
        this.load = false;
      this.removeBlockUI();
      }, error => { this.handleResponseError(error) })
  }
  changeColor(value){
    // console.log("Colorrrrrrrrrrrrrrrrrrrrrr");
    // console.log(value)
    //  orange
    return value.IsRead=='N' ?'rgb(248, 175, 147)' : null
}
public notificationFilterList:any[];
filter(listFilter){
  this.notificationFilterList = this.notificationList.filter(item => (item.UserName.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
      || item.Subject.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
    )
      );
}
  public alertHeader:any='';
  
  public displayMessage:boolean=false;
  

  notificationDetails(code){
    // alert("Clicik");
    console.log(code);
    this.displayMessage = true; 
    var notificationDetail={
      "MHNotificationLogCode":code.MHNotificationLogCode
    }
    this.load = true;
    this.addBlockUI();
    this.authenticationService.readNotification(notificationDetail).subscribe(response=>{
      console.log("Notification Details..!!!");
      console.log(response);
         
      this.alertHeader=response.NotificationDetail.Subject;
      var notifybody=response.NotificationDetail.Email_Body;
      console.log(notifybody)
      $("#NotifyMessage1").html(notifybody);
      this.load = false;
      this.removeBlockUI();
      // this.alertMessage=response.NotificationDetail.Email_Body;
      // this.alertMessage="Notification Details..!!!"
      for(let i=0;i<this.notificationList.length;i++){
        if(this.notificationList[i].MHNotificationLogCode==code.MHNotificationLogCode){
          if(this.notificationList[i].IsRead=='N'){
            this.notificationList[i].IsRead='Y';
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
  handleResponseError(errorCode) {    
    if (errorCode == 403 ) {
    sessionStorage.clear();
    localStorage.clear();
      this.router.navigate(['/login']);
    }
  }

}
