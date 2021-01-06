import { Component, OnInit } from '@angular/core';
import { Message } from 'primeng/components/common/api';
import { Validators, FormGroup, FormControl, FormBuilder } from '@angular/forms'
import { Router, ActivatedRoute, ParamMap } from '@angular/router';
import { AppService } from '../app.service'
import { ConfirmationService } from 'primeng/api';


//Added by Sachin ----Start----
import { AuthenticationService } from '../shared/services/authentication.service';
const HOME_PATH: string[] = ['/', 'app'];
const USER_SESSION = "USER_SESSION";
const USER_RIGHTS = "USER_RIGHTS";
const SYSTEM_CONFIG = "SYSTEM_CONFIG";
const AUTH_TOKEN = "AUTH_TOKEN";
const USER_NAME = "USER_NAME";
const REFRESH_TOKEN = "REFRESH_TOKEN";
const EXPIRE_TIME = "EXPIRE_TIME";
const SESSION_EXPIRE_TIME = "SESSION_EXPIRE_TIME";
const ARCHIVE_STATUS = "ARCHIVE_STATUS";
const CHANGEPSW_STATUS = "CHANGEPSW_STATUS";
const USERS_IMAGE = "USERS_IMAGE";

//Added by Sachin ----End----

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
  providers: [ConfirmationService, AuthenticationService]
})
export class LoginComponent implements OnInit {
  msgs: Message[] = [];
  userform;
  userName; userPassword;
  islogin: boolean = true;
  loginStatus;
  public count: number = 3;
  public displayForgot: boolean = false;
  public userDetails: any;
  public displayChangePSW: boolean = false;
  //added by sachin   ---start---

  archiveStatus: any = 0;
  constructor(private fb: FormBuilder, private _appservice: AppService, private router: Router, public _authService: AuthenticationService, private _confirmation: ConfirmationService) { }
  //added by sachin----- end-----
  ngOnInit() {
    this.userform = this.fb.group({
      'userName': new FormControl('', Validators.required),
      'userPassword': new FormControl('', Validators.compose([Validators.required, Validators.minLength(1)]))
    })

    //added by sachin   ---start---
    //Check if user session exists
    if (localStorage.getItem('USER_SESSION')) {
      sessionStorage.setItem(USER_SESSION, localStorage.getItem('USER_SESSION'));
      sessionStorage.setItem(SYSTEM_CONFIG, localStorage.getItem('SYSTEM_CONFIG'));
      sessionStorage.setItem(USER_RIGHTS, localStorage.getItem('USER_RIGHTS'));
      sessionStorage.setItem(AUTH_TOKEN, localStorage.getItem('AUTH_TOKEN'));
      sessionStorage.setItem(EXPIRE_TIME, localStorage.getItem('EXPIRE_TIME'));
      sessionStorage.setItem(REFRESH_TOKEN, localStorage.getItem('REFRESH_TOKEN'));
      console.log()
      this._authService.isLoggedIn = true;
      //added by sachin   ---end---
    }
  }

  onEnter(obj) {
    this.msgs = [];
    if (obj) {
      if (this.userName.trim() == '' || this.userPassword.trim() == '') {
        this.msgs.push({ severity: 'error', summary: '', detail: this.userName == null ? 'Please Enter UserName' : this.userPassword == null ? 'Please Enter Password' : this.userName.trim() == '' ? 'Please Enter UserName' : this.userPassword.trim() == '' ? 'Please Enter Password' : '' });

      }
      else {
        this.LoginClick();

      }
    }
    else {
      this.msgs.push({ severity: 'error', summary: '', detail: this.userName == null ? 'Please Enter UserName' : this.userPassword == null ? 'Please Enter Password' : this.userName == '' ? 'Please Enter UserName' : this.userPassword == '' ? 'Please Enter Password' : '' });
    }
  }
  LoginClick() {
    sessionStorage.clear();
    localStorage.clear();
    let USERNAME = this.userName;
    this._appservice.applogin(this.userName, this.userPassword).subscribe(
      response => {
        debugger;
        console.log("Login response");
        console.log(response);
        this.loginStatus = response;
        sessionStorage.setItem(AUTH_TOKEN, this.loginStatus.access_token);
        sessionStorage.setItem(REFRESH_TOKEN, this.loginStatus.refresh_token);
        sessionStorage.setItem(EXPIRE_TIME, this.loginStatus.expires_in);
        sessionStorage.setItem(USER_NAME, USERNAME);
        localStorage.setItem(USER_NAME, USERNAME);
        localStorage.setItem(AUTH_TOKEN, this.loginStatus.access_token);
        localStorage.setItem(REFRESH_TOKEN, this.loginStatus.refresh_token);
        localStorage.setItem(EXPIRE_TIME, this.loginStatus.expires_in);
        //Set default Archive Status
        this.archiveStatus = 0;
        sessionStorage.setItem(ARCHIVE_STATUS, this.archiveStatus);
        //Save token Details
        let auth_token = sessionStorage.getItem(AUTH_TOKEN);
        let expire_time = sessionStorage.getItem(EXPIRE_TIME);
        this._appservice.validateLogin().subscribe(
          response => {
            debugger;
            this.msgs = [];
            let Return = response.Return;
            console.log(Return);
            console.log(response);

            let Obj = JSON.stringify(response.User);
            sessionStorage.setItem(CHANGEPSW_STATUS, Return.IsSystemPassword);
            localStorage.setItem('UserName', this.userName);

            sessionStorage.setItem(USER_SESSION, Obj);
            localStorage.setItem(USER_SESSION, Obj);

            if (Return.IsSuccess) {
              var prodName = response.User.ProductionHouse;
              var loginUserName = response.User.Login_Name
              localStorage.setItem('ProductionName', prodName);
              localStorage.setItem('loginName', loginUserName);
              localStorage.setItem(USERS_IMAGE, response.User.UserImage);
              if (Return.IsSystemPassword == 'Y') {
                this.router.navigate(['/app/changepswd']);
              }
              else {
                this.router.navigate(['/app/dashboard']);
              }

            }
            else if (Return.IsSuccess == false) {
              if (Return.Message == "Change Password" || Return.IsSystemPassword == 'Y') {
                this.router.navigate(['/app/changepswd']);
              }
              else if (Return.Message == "Locked") {
                this._confirmation.confirm({
                  message: 'You are already logged in. Do you want to release account?',
                  header: 'Confirmation',
                  icon: 'pi pi-exclamation-triangle',
                  accept: () => {
                    debugger;
                    var details = 0;
                    this._authService.releaseAccount({ 'Login_Name': this.userName }).subscribe(response => {
                      console.log(response);
                      if (response.User.IsSuccess) {
                        sessionStorage.clear();
                        localStorage.removeItem('USER_SESSION');
                        localStorage.removeItem('USER_RIGHTS');
                        localStorage.removeItem('SYSTEM_CONFIG');
                        localStorage.removeItem('AUTH_TOKEN');
                        localStorage.removeItem('EXPIRE_TIME');
                        localStorage.removeItem('UserName');
                        this.userPassword = null;
                        this.msgs = [{ severity: 'info', summary: '', detail: 'Account Released Successfully...!!!' }];
                        this.router.navigate(['/login']);
                      }

                    });

                  },
                  reject: () => {
                    // this.msgs = [{ severity: 'info', summary: 'Rejected', detail: 'You have rejected' }];
                  }
                });
              }
              if (this.loginStatus.User.Message == 'User Locked') {
                this.userform.controls['userName'].disable();
                this.userform.controls['userPassword'].disable();
              }

              this.msgs.push({ severity: 'error', summary: 'Error Message', detail: this.loginStatus.User.Message });
            }

          }, error => {
            alert(error);
          });
        //added by sachin   ---start---
      }, error => {
        alert(error);
      });


    //added by sachin   ---end---
  }
  forgotClick() {
    this.displayForgot = true;
    this.forgotEmailId = '';
    // this.islogin = false;

  }
  public forgotEmailId: any;
  public displayalertMessage: Boolean = false;
  public messageData: any;
  submitForgotPasswordRequest() {
    this.displayForgot = false;
    var forgotBody = {
      "Email_Id": this.forgotEmailId
    }
    console.log(JSON.stringify(forgotBody));
    this._appservice.appForgotPassword(forgotBody).subscribe(response => {
      console.log("Forgot response...!!")
      console.log(JSON.stringify(response));
      debugger;
      this.displayForgot = response.User.IsSuccess == true ? false : true;
      this.displayalertMessage = true;

      this.messageData = {
        'header': response.User.IsSuccess == true ? 'Message' : 'Warning Message',
        'body': response.User.Message
      }
    })
  }
  continueClick() {
    this.islogin = true;
    this.userName = null;
    this.userPassword = null;
  }

}
