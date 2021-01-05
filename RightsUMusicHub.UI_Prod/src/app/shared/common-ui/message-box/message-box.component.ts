import { Component, OnInit,Input,OnChanges,SimpleChange } from '@angular/core';

@Component({
  selector: 'app-message-box',
  templateUrl: './message-box.component.html',
  styleUrls: ['./message-box.component.css']
})
export class MessageBoxComponent implements OnInit {
  @Input ('messageData') messageData:any;

  public alertHeader;
  public alertMessage;
  public displayMessage:boolean=false;
  constructor() { }

  ngOnChanges(changes: {[propKey: string]: SimpleChange}) {
    let log: string[] = [];
    // console.log(changes);
    for (let propName in changes) {
      let changedProp = changes[propName];
      console.log(changedProp);
    //   let to = JSON.stringify(changedProp.currentValue);
      if (changedProp.isFirstChange()) {
        console.log("first Change");
        this.displayMessage=true;
        this.alertHeader=changedProp.currentValue.header;
        this.alertMessage=changedProp.currentValue.body;
    //     log.push(`Initial value of ${propName} set to ${to}`);
      } else {
        console.log("Second change")
        this.displayMessage=true;
        this.alertHeader=changedProp.currentValue.header;
        this.alertMessage=changedProp.currentValue.body;
      }
    }
    // this.changeLog.push(log.join(', '));
  }
  ngOnInit() {
    // this.displayMessage=true;
    // alert("pageinint")
    // this.alertHeader=this.messageData.header;
    // this.alertMessage=this.messageData.body;
  }

  alertClose(){
    
    
    this.displayMessage=false;
  }

  
}
