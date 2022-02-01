import { Time } from '@angular/common';
import { LazyLoadEvent } from "primeng/api";
import { Component, OnInit } from '@angular/core';
import { cloneDeep } from 'lodash';
import { DatePipe } from '@angular/common'
import { MessageService } from 'primeng/api';

import { FormBuilder, Validators } from '@angular/forms';
import { LABELS, MESSAGES } from 'src/app/shared/constant';
import { UtilityService } from 'src/app/shared/utility.service'
import { NotificationEngineService } from 'src/app/shared/notification-engine.service'

@Component({
  selector: 'app-search-screen',
  templateUrl: './search-screen.component.html',
  styleUrls: ['./search-screen.component.scss'],
  providers: [DatePipe, MessageService]
})
export class SearchScreenComponent implements OnInit {

  events: any = [];
  selectedEvents: any = [];
  transType: any = [];
  selectedTransType: any = [];
  statusArray: any = [];
  selectedStatus!: string;
  noOfRetry: any = [];
  selectedNoOfRetry!: string;
  notificationType: any = [];
  selectedNtfnType!: string;
  users: any = [];
  selectedUserCode!: string;
  customers: any = [];
  listData: any = [];
  cloneData: any = [];
  scrollableCols: any = [];
  showResendBtn: boolean = false;
  selectedData: any;
  searchForm: any;
  submitted: boolean = false;
  sStartDate!: Date;
  sEndDate!: Date;
  sTime!: Date;
  sentStartDate!: Date;
  sentEndDate!: Date;
  sentTime!: Date;
  showScheduleVal: boolean = false;
  showPopup: boolean = false;
  showSentVal: boolean = false;
  isLoading: boolean = false;
  showConfirmPopup: boolean = false;
  totalRecords = 0;
  isVirtualScroll = true;
  loading: boolean = false;
  showViewPopup: boolean = false;
  dateValidation: boolean = false;
  sentdateValidation: boolean = false;
  subject: string = '';
  recipient: string = '';
  popupData: any;
  LABEL;
  MESSAGE;
  retryFailOptionInConfig: boolean = false;
  retrySuccessOptionInConfig: boolean = false;


  constructor(public _formBuilder: FormBuilder, private readonly utilityService: UtilityService,
    private readonly notificationEngineService: NotificationEngineService, public datepipe: DatePipe,
    private messageService: MessageService) {
    this.LABEL = LABELS;
    this.MESSAGE = MESSAGES;
    this.popupData = {};
    this.searchForm = this._formBuilder.group({
      'status': ['', Validators.required],
      'ntfType': ['', Validators.required],
      'schedulSDate': [''], //, Validators.required
      'schedulEDate': [''], //, Validators.required
      'event': [''],
      'trasactionType': [''],
      'noofretry': [''],
      'user': [''],
      'sentSDate': [''],
      'sentEDate': ['']

    });

    this.getMasterData();

    this.noOfRetry = [
      { label: "1", value: 1 },
      { label: "2", value: 2 },
      { label: "3", value: 3 },
      { label: "4", value: 4 },
      { label: "5", value: 5 },
    ]

    this.users = [
      { label: "User 1", value: 1 },
      { label: "User 2", value: 2 },
      { label: "User 3", value: 3 },

    ]

    this.loading = false

    this.scrollableCols = [
      { field: 'TransactionCode', header: 'Transaction Code' },
      { field: 'TransactionType', header: 'Transaction Type' },
      { field: 'MessageType', header: 'Message Type' },
      { field: 'Message', header: 'Message' },
      { field: 'SentTo', header: 'Sent To' },
      { field: 'Status', header: 'Status' },
      { field: 'NoOfRetry', header: 'No Of Retry' },
      { field: 'SentDateTime', header: 'Sent Date Time' },
      { field: 'ScheduleDateTime', header: 'Schedule Date Time' },
      // { field: 'EventCategory', header: 'Event/Category' },
      // { field: 'Subject', header: 'Subject' }
    ];


  }


  ngOnInit(): void {
    this.getConfiguration();
  }

  getMasterData() {
    this.notificationEngineService.GetMasterData({}).subscribe(
      outputData => {
        this.notificationType = outputData.Response.filter((data: any) => data.Type === 'NT');
        this.statusArray = outputData.Response.filter((data: any) => data.Type === 'NS');
        this.transType = outputData.Response.filter((data: any) => data.Type === 'T');
        this.events = outputData.Response.filter((data: any) => data.Type === 'EC');
      });
  }

  getConfiguration() {
    this.notificationEngineService.GetConfiguration({}).subscribe(
      outputData => {
        if (outputData.Response[0].RetryOptionForFailed || outputData.Response[0].ResendOptionForSuccessful) {
          this.showResendBtn = true;
        } else {
          this.showResendBtn = false;
        }

        this.retryFailOptionInConfig = outputData.Response[0].RetryOptionForFailed;
        this.retrySuccessOptionInConfig = outputData.Response[0].ResendOptionForSuccessful;
        //  this.showResendBtn = true;
      });

  }

  onEventChange(event: any) {
    this.selectedEvents = event.value.map((data: any) => data.Name);
  }

  onTransTypeChange(event: any) {
    this.selectedTransType = event.value.map((data: any) => data.Name);
  }

  onStatusChange(event: any) {
    this.selectedStatus = event.value.Code;
  }

  onNoOfRetryChange(event: any) {
    this.selectedNoOfRetry = event.value.value;
  }

  onNtfTypeChange(event: any) {
    this.selectedNtfnType = event.value.Code;
  }

  onUserChange(event: any) {
    this.selectedUserCode = event.value.value;
  }



  searchData() {
    this.submitted = true;
    debugger;
    this.isLoading = true;
    if (this.searchForm.valid && !this.showScheduleVal && !this.showSentVal && !this.dateValidation && !this.sentdateValidation
      && !this.utilityService.isEmpty(this.selectedNtfnType) && !this.utilityService.isEmpty(this.selectedStatus)) {
      let obj = {
        "NECode": "",
        "TransType": this.selectedTransType.toString(),
        "TransCode": "",
        "UserCode": this.selectedUserCode,
        "NotificationType": this.selectedNtfnType,
        "EventCategory": this.selectedEvents.toString(),
        "Subject": this.subject,
        "Status": this.selectedStatus,
        "NoOfRetry": this.selectedNoOfRetry,
        "size": 50,
        "from": 0,
        "ScheduleStartDateTime": this.datepipe.transform(this.sStartDate, 'dd/MMM/yyyy hh:mm:ss'),
        "ScheduleEndDateTime": this.datepipe.transform(this.sEndDate, 'dd/MMM/yyyy hh:mm:ss'),
        "SentStartDateTime": this.datepipe.transform(this.sentStartDate, 'dd/MMM/yyyy hh:mm:ss'),
        "SentEndDateTime": this.datepipe.transform(this.sentEndDate, 'dd/MMM/yyyy hh:mm:ss'),
        "Recipient": this.recipient
      }

      // let obj = {
      //   "NECode": "8,9,10,11,12,13,14,15,16,17,18,19,20",
      //   "TransType": "",
      //   "TransCode": "",
      //   "UserCode": "",
      //   "NotificationType": "",
      //   "EventCategory": "",
      //   "Subject": "",
      //   "Status": "",
      //   "NoOfRetry": 0,
      //   "size": 50,
      //   "from": 0,
      //   "ScheduleStartDateTime": "",
      //   "ScheduleEndtDateTime": "",
      //   "SentStartDateTime": "",
      //   "SentEndDateTime": "",
      //   "Recipient": ""
      // }
      this.notificationEngineService.GetListData(obj).subscribe(
        outputData => {
          this.totalRecords = outputData.Response.TotalRecords;
          this.listData = outputData.Response.lstGetMessages;
          this.listData.map((option: any) => {
            //if (option.Status === 'Success' || option.Status === 'Fail') {
            //  option['showBtn'] = true;
            //} else {
            //  option['showBtn'] = false;
            //}
            if (option.Status === 'Success') {
              if (this.retrySuccessOptionInConfig) {
                option['showBtn'] = true;
              } else {
                option['showBtn'] = false;
              }
            }

            if (option.Status === 'Fail') {
              if (this.retryFailOptionInConfig) {
                option['showBtn'] = true;
              } else {
                option['showBtn'] = false;
              }
            }
          });
          this.cloneData = cloneDeep(this.listData);
          this.isLoading = false;
          console.log(this.listData)
        }, error => {
          this.isLoading = false;
          this.messageService.add({ severity: 'error', summary: 'Error', detail: 'No Record Found' });
        });

    } else {
      this.isLoading = false;
      if (this.utilityService.isEmpty(this.selectedNtfnType)) {
        this.searchForm.controls['ntfType'].status = "INVALID";
      }
      if (this.utilityService.isEmpty(this.selectedStatus)) {
        this.searchForm.controls['status'].status = "INVALID";
      }

    }

  }



  calculateDateDiff(startDate: Date, endDate: Date, type: string) {
    if ((startDate !== undefined && startDate !== null) && (endDate !== undefined && endDate !== null)) {
      if (type === 'schedule') {
        if (endDate < startDate) {
          this.dateValidation = true;
        } else {
          this.dateValidation = false;
        }
      } else {
        if (endDate < startDate) {
          this.sentdateValidation = true;
        } else {
          this.sentdateValidation = false;
        }
      }

      let diff = endDate.getMonth() - startDate.getMonth() +
        (12 * (endDate.getFullYear() - startDate.getFullYear()));
      if (diff !== null && diff !== undefined) {
        if ((diff + 1) > 3) {
          if (type === 'schedule' && !this.dateValidation) {
            this.showScheduleVal = true;
          } else {
            if (!this.sentdateValidation) {
              this.showSentVal = true;
            }
          }
        } else {
          if (type === 'schedule') {
            this.showScheduleVal = false;
          } else {
            this.showSentVal = false;
          }
        }
      }

    }
  }

  onResendClick(data: any) {
    debugger;
    this.isLoading = true;
    let obj = {
      "NECode": data.NotificationsCode,
      "UpdatedStatus": 'RESEND',
      "ReadDateTime": this.datepipe.transform(new Date(), 'dd/MMM/yyyy hh:mm:ss')
    }
    this.notificationEngineService.resendData(obj).subscribe(
      outputData => {
        this.listData.map((rowData: any) => {
          if (rowData.RowNum === data.RowNum) {
            rowData.Status = "Pending";
            rowData['showBtn'] = false;
          }
        });

        this.showConfirmPopup = false;
        this.isLoading = false;
      }, error => {
        this.isLoading = false;
        this.messageService.add({ severity: 'error', summary: 'Error', detail: 'No Records Found' });
      });
  }

  exportCSV(data: any) {
    debugger;
    if (this.listData.length === 0) {
      data.exportCSV();
    } else {
      let obj = {
        "NECode": "",
        "TransType": this.selectedTransType.toString(),
        "TransCode": "",
        "UserCode": this.selectedUserCode,
        "NotificationType": this.selectedNtfnType,
        "EventCategory": this.selectedEvents.toString(),
        "Subject": this.subject,
        "Status": this.selectedStatus,
        "NoOfRetry": this.selectedNoOfRetry,
        "size": this.totalRecords,
        "from": 0,
        "ScheduleStartDateTime": this.datepipe.transform(this.sStartDate, 'dd/MMM/yyyy hh:mm:ss'),
        "ScheduleEndDateTime": this.datepipe.transform(this.sEndDate, 'dd/MMM/yyyy hh:mm:ss'),
        "SentStartDateTime": this.datepipe.transform(this.sentStartDate, 'dd/MMM/yyyy hh:mm:ss'),
        "SentEndDateTime": this.datepipe.transform(this.sentEndDate, 'dd/MMM/yyyy hh:mm:ss'),
        "Recipient": this.recipient
      }

      // let obj = {
      //   "NECode": "8,9,10,11,12,13,14,15,16,17,18,19,20",
      //   "TransType": "",
      //   "TransCode": "",
      //   "UserCode": "",
      //   "NotificationType": "",
      //   "EventCategory": "",
      //   "Subject": "",
      //   "Status": "",
      //   "NoOfRetry": 0,
      //   "size": this.totalRecords,
      //   "from": 0,
      //   "ScheduleStartDateTime": "",
      //   "ScheduleEndtDateTime": "",
      //   "SentStartDateTime": "",
      //   "SentEndDateTime": "",
      //   "Recipient": ""
      // }
      this.notificationEngineService.GetListData(obj).subscribe(
        outputData => {

          let exportData = outputData.Response.lstGetMessages;
          if (outputData.Status && !this.utilityService.isEmpty(exportData)) {
            const result = [
              'TransactionCode',
              'TransactionType',
              'MessageType',
              'Message',
              'SentTo',
              'Status',
              'NoOfRetry',
              'SentDateTime',
              'ScheduleDateTime',
              'EventCategory',
              'Subject'
            ];
            const re2 = ['Transaction Code', 'Transaction Type', 'Message Type', 'Message', 'Sent To', 'Status',
              'No Of Retry', 'Sent Date Time', 'Schedule Date Time', 'Event/Category', 'Subject'
            ];
            const header = result;
            const csv = exportData.map((row: any) =>
              header
                .map((fieldName: any) => JSON.stringify(row[fieldName]))
                .join(',')
            );
            csv.unshift(re2.join(','));
            const csvArray = csv.join('\r\n');

            const a = document.createElement('a');
            const blob = new Blob([csvArray], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);

            a.href = url;
            a.download = 'download.csv';
            a.click();
            window.URL.revokeObjectURL(url);
            a.remove();
          } else {
            data.exportCSV();
          }


        });

    }
  }

  /**
   * @description This function loads next n: number of records on scroll action
   * @param  {LazyLoadEvent} event
   * @returns void
   */
  loadDataOnScroll(event: LazyLoadEvent) {
    debugger;
    if (this.cloneData.length > 0) {
      this.isVirtualScroll = true;
      if (event.globalFilter === undefined || event.globalFilter === null) {
        event.globalFilter = '';
      }
      if (event.globalFilter.length > 3 || this.utilityService.isEmpty(event.globalFilter)) {
        this.loading = true;
      }
      let obj = {
        "NECode": "",
        "TransType": this.selectedTransType.toString(),
        "TransCode": "",
        "UserCode": this.selectedUserCode,
        "NotificationType": this.selectedNtfnType,
        "EventCategory": this.selectedEvents.toString(),
        "Subject": this.subject,
        "Status": this.selectedStatus,
        "NoOfRetry": this.selectedNoOfRetry,
        "size": 50,
        "from": 0,
        "ScheduleStartDateTime": this.datepipe.transform(this.sStartDate, 'dd/MM/yyyy hh:mm:ss'),
        "ScheduleEndDateTime": this.datepipe.transform(this.sEndDate, 'dd/MM/yyyy hh:mm:ss'),
        "SentStartDateTime": this.datepipe.transform(this.sentStartDate, 'dd/MM/yyyy hh:mm:ss'),
        "SentEndDateTime": this.datepipe.transform(this.sentEndDate, 'dd/MM/yyyy hh:mm:ss'),
        "Recipient": this.recipient
      }

      // let obj = {
      //   "NECode": "8,9,10,11,12,13,14,15,16,17,18,19,20",
      //   "TransType": "",
      //   "TransCode": "",
      //   "UserCode": "",
      //   "NotificationType": "",
      //   "EventCategory": "",
      //   "Subject": "",
      //   "Status": "",
      //   "NoOfRetry": 0,
      //   "size": 50,
      //   "from": 0,
      //   "ScheduleStartDateTime": "",
      //   "ScheduleEndtDateTime": "",
      //   "SentStartDateTime": "",
      //   "SentEndDateTime": "",
      //   "Recipient": ""
      // }
      this.notificationEngineService.GetListData(obj).subscribe(
        outputData => {
          this.totalRecords = outputData.Response.TotalRecords;
          this.listData = outputData.Response.lstGetMessages;
          this.listData.map((option: any) => {
            //if (option.Status === 'Success' || option.Status === 'Fail') {
            //  option['showBtn'] = true;
            //} else {
            //  option['showBtn'] = false;
            //}

            if (option.Status === 'Success') {
              if (this.retrySuccessOptionInConfig) {
                option['showBtn'] = true;
              } else {
                option['showBtn'] = false;
              }
            }

            if (option.Status === 'Fail') {
              if (this.retryFailOptionInConfig) {
                option['showBtn'] = true;
              } else {
                option['showBtn'] = false;
              }
            }
          });
          this.cloneData = cloneDeep(this.listData);
          if (this.utilityService.isEmpty(event.globalFilter)) {
            this.listData = this.cloneData;
          } else if (event.globalFilter.length > 3) {
            event.globalFilter = event.globalFilter.toLowerCase();
            this.listData = this.listData.filter(function (o: any) {
              return [
                'TransactionCode',
                'TransactionType',
                'MessageType',
                'Message',
                'SentTo',
                'Status',
                'NoOfRetry',
                'SentDateTime',
                'ScheduleDateTime',
                'EventCategory',
                'Subject'
              ].some(function (k) {
                if (o[k] === undefined || o[k] === null) {
                  o[k] = '';
                }
                return o[k].toString().toLowerCase().indexOf(event.globalFilter) !== -1;
              });
            });
          }
          this.loading = false;
        });

    }
  }


  openViewPopup(rowData: any) {
    this.popupData = rowData;
    this.showViewPopup = true;
  }

  getEventValue($event: any): string {
    return $event.target.value;
  }

  clearData() {
    debugger
    this.dateValidation = false;
    this.showScheduleVal = false;
    this.sentdateValidation = false;
    this.showSentVal = false;
    this.listData = [];
    this.cloneData = [];
    this.selectedEvents = [];
    this.selectedTransType = [];
    this.selectedStatus = '';
    this.selectedNoOfRetry = '';
    this.selectedNtfnType = '';
    this.selectedUserCode = '';
    this.recipient = '';
    this.subject = '';
    // this.sStartDate;	
    // this.sEndDate 	
    // this.sentStartDate	
    // this.sentEndDate	
    this.searchForm.clearValidators();
    this.submitted = false;
    this.searchForm.controls['status'].setValue(undefined, { emitEvent: true });
    this.searchForm.controls['ntfType'].setValue(undefined, { emitEvent: true });
    this.searchForm.controls['event'].setValue(undefined, { emitEvent: true });
    this.searchForm.controls['trasactionType'].setValue(undefined, { emitEvent: true });
    this.searchForm.controls['noofretry'].setValue(undefined, { emitEvent: true });
    this.searchForm.controls['user'].setValue(undefined, { emitEvent: true });
    this.searchForm.controls['schedulSDate'].setValue(undefined, { emitEvent: true });
    this.searchForm.controls['schedulEDate'].setValue(undefined, { emitEvent: true });
    this.searchForm.controls['sentSDate'].setValue(undefined, { emitEvent: true });
    this.searchForm.controls['sentEDate'].setValue(undefined, { emitEvent: true });
    this.searchForm.controls['sentSDate'].updateValueAndValidity();
    this.searchForm.controls['sentEDate'].updateValueAndValidity();
    this.searchForm.controls['schedulSDate'].updateValueAndValidity();
    this.searchForm.controls['schedulEDate'].updateValueAndValidity();
    this.searchForm.controls['event'].updateValueAndValidity();
    this.searchForm.controls['trasactionType'].updateValueAndValidity();
    this.searchForm.controls['noofretry'].updateValueAndValidity();
    this.searchForm.controls['user'].updateValueAndValidity();
    this.searchForm.controls['status'].updateValueAndValidity();
    this.searchForm.controls['ntfType'].updateValueAndValidity();
    this.searchForm.controls['status'].status = "VALID";
    this.searchForm.controls['ntfType'].status = "VALID";
  }

}
