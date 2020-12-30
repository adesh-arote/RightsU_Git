import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute, ParamMap } from '@angular/router';
import { AppService } from '../../app.service'
import { AuthenticationService } from '../../shared/services/authentication.service';

@Component({
  selector: 'app-change-password',
  templateUrl: './change-password.component.html',
  styleUrls: ['./change-password.component.css']
})
export class ChangePasswordComponent implements OnInit {

  public load: boolean = false;
  public newPSW:any;
  public confirmedPSW:any;
  public oldPSW:any;
  public userName;
  public messageData: any;
  public displayalertMessage:boolean=false;
  public ChangePSW;
  constructor(private _appservice: AppService, private router: Router, public _authService: AuthenticationService) { }

  ngOnInit() {
    this.userName=localStorage.getItem('UserName');
    this.ChangePSW=sessionStorage.getItem('CHANGEPSW_STATUS');
    console.log(this.userName); 
  }
  
  submitChangePswdRequest(){
    if(this.newPSW==this.confirmedPSW){
      let ChangePswdbody={
        "OldPassword":this.oldPSW,
        "NewPassword":this.newPSW
    }
        // alert("Password MAtch");
        
        this._appservice.changePassword(ChangePswdbody).subscribe(
          response => {
            if(response.Return.IsSuccess==true){
            
              this._authService.releaseAccount({ 'Login_Name': this.userName }).subscribe(response => {
            
              if (response.User.IsSuccess) {
                sessionStorage.clear();
                localStorage.removeItem('USER_SESSION');
                localStorage.removeItem('USER_RIGHTS');
                localStorage.removeItem('SYSTEM_CONFIG');
                localStorage.removeItem('AUTH_TOKEN');
                localStorage.removeItem('EXPIRE_TIME');
                localStorage.removeItem('UserName');
                
            // this.msgs = [{ severity: 'info', summary: '', detail: 'Account Released Successfully...!!!' }];                        
                this.router.navigate(['/login']);
              }
        
            }
            , error => { this.handleResponseError(error) });
          }
          else{
            
            this.displayalertMessage=true;
        this.messageData = {
          'header': "Message",
          'body': response.Return.Message
        }
          }
          })
    }
    else{
      this.displayalertMessage=true;
        this.messageData = {
          'header': "Message",
          'body': "New Password and Confirm Password should be same."
        }
    }
  }
  CancelClick(){
    this.router.navigate(['/login']);
  }
  handleResponseError(errorCode) {    
    if (errorCode == 403 ) {
      
    sessionStorage.clear();
    localStorage.clear();
      this.router.navigate(['/login']);
    }
  }
}
