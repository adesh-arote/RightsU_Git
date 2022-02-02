import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { MessageService } from 'primeng/api';

import { UtilityService } from 'src/app/shared/utility.service'
import { LABELS, MESSAGES } from 'src/app/shared/constant';
import { NotificationEngineService } from 'src/app/shared/notification-engine.service'

@Component({
  selector: 'app-config-screen',
  templateUrl: './config-screen.component.html',
  styleUrls: ['./config-screen.component.scss'],
  providers: [MessageService]
})
export class ConfigScreenComponent implements OnInit {

  oldNumberValue: number = 0;
  numberModel: any;
  noOfRetry: any = [];
  submitted: boolean = false;
  configForm: any;
  retryFailModel: any;
  retrySuccessModel: any;
  severModel: any;
  portModel: any;
  defaultCredModel: any;
  noOfRetryModel: any;
  userNameModel: any;
  pswdModel: any;
  showRetryVal1: boolean = false;
  showRetryVal2: boolean = false;
  showCredentialVal1: boolean = false;
  showCredentialVal2: boolean = false;
  configCode: number = 0;
  LABEL;
  MESSAGE;

  constructor(public _formBuilder: FormBuilder, private readonly utilityService: UtilityService,
    private readonly notificationEngineService: NotificationEngineService, private messageService: MessageService) {
    this.configForm = this._formBuilder.group({
      'retryFail': ['', Validators.required],
      'retrySucess': ['', Validators.required],
      'serverName': ['', Validators.required],
      'port': ['', Validators.required],
      'defaultCredential': ['', Validators.required],
      'noOfRetry': [''],
      'durationRetry': ['', [Validators.max(100), Validators.min(3)]],
      'userName': [''],
      'pswd': ['']
    });
    this.LABEL = LABELS;
    this.MESSAGE = MESSAGES;
  }

  ngOnInit(): void {
    this.noOfRetry = [
      { label: "1", value: 1 },
      { label: "2", value: 2 },
      { label: "3", value: 3 },
      { label: "4", value: 4 },
      { label: "5", value: 5 },
    ];
    this.getConfiguration();
  }

  /**
   * @description this function is used for accept only number
   * @param  {} event
   * @returns boolean
   */
  keyPress(event: any) {
    const eve = (event) ? event : window.event;
    const charCode = (eve.which) ? eve.which : eve.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
      return false;
    }

    return true;
  }


  /**
* @description this function is used for accept only number
* @param  {} event
* @returns boolean
*/
  preventInput(event: any) {
   
    if ((+event.target.value < +event.target.min || +event.target.value > +event.target.max) &&
      event.target.value !== undefined && event.target.value !== null) {
      this.numberModel = this.oldNumberValue;
    } else {
      this.oldNumberValue = event.target.value;
    }
  }

  getConfiguration() {
    this.notificationEngineService.GetConfiguration({}).subscribe(
      outputData => {
        if (!this.utilityService.isEmpty(outputData.Response) && outputData.Response.length > 0) {
          let data = outputData.Response[0];
          this.numberModel = data.DurationBetweenTwoRetriesMin;
          this.noOfRetryModel = data.NoOfTimesToRetry;
          let model = this.noOfRetry.filter((data: any) => data.value === this.noOfRetryModel);
          model = !this.utilityService.isEmpty(model) ? model[0] : 0;
          this.configForm.controls['noOfRetry'].setValue(model, { emitEvent: true });
          this.configCode = data.NotificationConfigCode;
          this.pswdModel = data.Password;
          this.retrySuccessModel = data.ResendOptionForSuccessful;
          this.retryFailModel = data.RetryOptionForFailed;
          this.portModel = data.SMTPPort;
          this.severModel = data.SMTPServer;
          this.defaultCredModel = data.UseDefaultCredentials;
          this.userNameModel = data.UserName
        }

      });

  }

  onNoOfRetryChange(event: any) {
    this.noOfRetryModel = event.value.value;
  }

  saveData() {
    this.checkRadioSelection()
    this.submitted = true;
    if (this.configForm.valid && !this.showRetryVal1 && !this.showRetryVal2 && !this.showCredentialVal1 && !this.showCredentialVal2) {
      let obj = {
        "NoOfTimesToRetry": !this.utilityService.isEmpty(this.noOfRetryModel) ? this.noOfRetryModel : 0,
        "DurationBetweenTwoRetriesMin": !this.utilityService.isEmpty(this.numberModel) ? this.numberModel : 0,
        "RetryOptionForFailed": !this.utilityService.isEmpty(this.retryFailModel) ? this.retryFailModel : false,
        "ResendOptionForSuccessful": !this.utilityService.isEmpty(this.retrySuccessModel) ? this.retrySuccessModel : false,
        "SMTPServer": !this.utilityService.isEmpty(this.severModel) ? this.severModel : "",
        "SMTPPort": !this.utilityService.isEmpty(this.portModel) ? this.portModel : 0,
        "UseDefaultCredentials": !this.utilityService.isEmpty(this.defaultCredModel) ? this.defaultCredModel : false,
        "UserName": !this.utilityService.isEmpty(this.userNameModel) ? this.userNameModel : "",
        "Password": !this.utilityService.isEmpty(this.pswdModel) ? this.pswdModel : "",
        "NotificationConfigCode": this.configCode

      }
      // let obj =  {
      //   "NoOfTimesToRetry": 0,
      //   "DurationBetweenTwoRetriesMin" : 0 ,
      //   "RetryOptionForFailed": true,
      //   "ResendOptionForSuccessful" : true,
      //   "SMTPServer" :"",
      //   "SMTPPort" : 0,
      //   "UseDefaultCredentials" : true,
      //   "UserName" : "",
      //   "Password": "",
      //   }
      this.notificationEngineService.saveConfiguration(obj).subscribe(
        outputData => {
          if (outputData.Status) {
            this.messageService.add({ severity: 'success', summary: 'Success', detail: 'Configuration saved successfully.' });
          }
        });
    }
  }

  checkRadioSelection() {
    if (this.retryFailModel === true || this.retrySuccessModel === true) {
      if (this.utilityService.isEmpty(this.noOfRetryModel)) {
        this.showRetryVal1 = true;
      } else {
        this.showRetryVal1 = false;
      }
      if (this.utilityService.isEmpty(this.numberModel)) {
        this.showRetryVal2 = true;
      } else {
        this.showRetryVal2 = false;
      }
    } else {
      this.showRetryVal1 = false;
      this.showRetryVal2 = false;
    }
    if (this.defaultCredModel === false) {
      if (this.utilityService.isEmpty(this.userNameModel)) {
        this.showCredentialVal1 = true;
      } else {
        this.showCredentialVal1 = false;
      }
      if (this.utilityService.isEmpty(this.pswdModel)) {
        this.showCredentialVal2 = true;
      } else {
        this.showCredentialVal2 = false;
      }
    } else {
      this.showCredentialVal1 = false;
      this.showCredentialVal2 = false;
    }
  }


  clearFormData() {
    this.showRetryVal1 = false;
    this.showRetryVal2 = false;
    this.showCredentialVal1 = false;
    this.showCredentialVal2 = false;

    this.numberModel = undefined;
    this.retryFailModel = undefined;
    this.retrySuccessModel = undefined;
    this.severModel = undefined;
    this.portModel = undefined;
    this.defaultCredModel = undefined;
    this.noOfRetryModel = undefined;
    this.userNameModel = undefined;
    this.pswdModel = undefined;
    this.configForm.controls['noOfRetry'].setValue(undefined, { emitEvent: true });
    this.submitted = false;
    this.configForm.clearValidators();
    this.configForm.controls.retryFail.updateValueAndValidity();
    this.configForm.controls.retrySucess.updateValueAndValidity();
    this.configForm.controls.serverName.updateValueAndValidity();
    this.configForm.controls.port.updateValueAndValidity();
    this.configForm.controls.defaultCredential.updateValueAndValidity();
  }
}
