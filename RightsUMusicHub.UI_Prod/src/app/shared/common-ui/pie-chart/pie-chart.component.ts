import { Component, OnInit,Input,OnChanges,SimpleChange } from '@angular/core';
import { DashboardService } from '../../../dashboard/dashboard.service';
import {Router} from "@angular/router"
declare var google: any;
declare var $: any;
@Component({
  selector: 'app-pie-chart',
  templateUrl: './pie-chart.component.html',
  styleUrls: ['./pie-chart.component.css'],
  providers:[DashboardService]
})
export class PieChartComponent implements OnInit {

  @Input() dataRequest;

  
  public pieChartDetailsList = [];
  public pieChartList:any;
  public TotalCountPieChartDetail;
  public load: boolean = false;
  public pieChartData = [];
  public showChartDetails: boolean = false;
  public chartPlaceHolderText:any='';
  public alertHeader
  public pieChartDataOn=1;
  public pieChartDataOnText;
  public pieSelectedData;
  public showPieLabel:boolean=false;
  public chartSearch;
  public chart={
    // title: 'Test Chart',
    type: 'PieChart',
    data: [],
    columnNames: ['Element', 'Value'],
    options:{
      chartArea:{left:20,top: 40,bottom:20, 'width': '100%', 'height': '100%'},
      legend: { position: 'right','alignment':'center', maxLines: 10 },
      is3D: true,
      tooltip:{
        ignoreBounds:true,
        // isHtml:true
      }
    }
  }; ;

  constructor(private router:Router,private _dashboardService:DashboardService) {
    google.charts.load('current', { 'packages': ['corechart'] });
    google.charts.setOnLoadCallback(this.getPieChartDataMethod(1));

   }
  ngOnChanges(changes: {[propKey: string]: SimpleChange}) {
    let log: string[] = [];
    // console.log(changes);
    for (let propName in changes) {
      let changedProp = changes[propName];
      console.log(changedProp);
    //   let to = JSON.stringify(changedProp.currentValue);
      if (changedProp.isFirstChange()) {
        
      } else {
        console.log("On Changes value.....! ");
        console.log(changedProp.currentValue);
        this.getPieChartDataMethod(changedProp.currentValue)
      
      }
    }
    
  }
  ngOnInit() {
    console.log("elemanet Id.........!!!")
    console.log(this.dataRequest)
    // this.getPieChartDataMethod(1)
  }
  
  
  getPieChartDataMethod(searchPieChartCriteria){
    // this.pieChartDataOnText=searchstring;
    this.pieChartDataOn=searchPieChartCriteria;
    this.load = true;
    this.addBlockUI();
    this.pieChartData=[];
    var PieChartBody={    
      "NoOfMonths":searchPieChartCriteria
      }  
      console.log(PieChartBody)
    this._dashboardService.getPieChartData(PieChartBody).subscribe(response => {
      var labelsArr = [], dataArr = [], count = 0;
      console.log("Pie response........");
      console.log(response);
      if (response.Data.length != 0) {
        this.showPieLabel = false;
        var piedata=[];
        for(let i=0;i<response.Data.length;i++){
          piedata.push([response.labels[i],response.Data[i]])
        }
        this.chart= {
          // title: 'Test Chart',
          type: 'PieChart',
          data: piedata,
          columnNames: ['Element', 'Value'],
          options:{
            chartArea:{left:20,top: 40,bottom:20, 'width': '100%', 'height': '100%'},
            legend: { position: 'right','alignment':'center', maxLines: 10 },
            is3D: true,
            tooltip: {
              ignoreBounds: true,
              // isHtml:true
            }
          }
        };
    }
    else{
      
      this.showPieLabel=true;
    }
    }, error => { this.handleResponseError(error) });
  }
  public pierowData;
  onSelect(event){
    console.log(event);
    console.log(this.chart);
    if(event.length !=0){
      this.pierowData=event[0].row;
      this.pieChartDetails(this.chart.data[event[0].row][0]);
    }
    if(event.length==0){
      if(this.pierowData !=null){
      this.pieChartDetails(this.chart.data[this.pierowData][0]);

      }
    }
  }
 

  pieChartDetails(labelName) {
    this.chartSearch='';
    this.load = true;
    this.addBlockUI();
    this._dashboardService.getLabelWiseUsage({ "ShowName": "", "LabelName": labelName,"NoOfMonths":this.pieChartDataOn }).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      console.log(response);
      this.pieChartDetailsList = response.LabelWiseList;
      this.pieChartList=response.LabelWiseList;
      this.TotalCountPieChartDetail=response.LabelWiseList.length;
      this.showChartDetails = true;
      
      this.chartPlaceHolderText="Show Name, Music Track Name, Movie/Album";
      this.alertHeader = "Music Label Consumed: " + labelName
    }, error => { this.handleResponseError(error) });

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

  // filter(listFilter){
    
    
    
     
  //       this.pieChartDetailsList = this.pieChartList.filter(item => (item.ShowName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
  //       || item.MusicTrackName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
  //       || item.Movie_Album.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
  //       || item.MusicLanguage.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
  //       || item.YearOfRelease.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1)
  //       );
      
    
     
  // }
  piechartHandler2() {
    $('#piechart').css('cursor','pointer');
     }  
    piechartHandler3() {
    $('#piechart').css('cursor','default');
     } 
     addBlockUI() {
      $('body').addClass("overlay");
      $('body').on("keydown keypress keyup", false);
    }
    removeBlockUI() {
      $('body').removeClass("overlay");
      $('body').off("keydown keypress keyup", false);
    }
    close() {
      this.showChartDetails = false;
      
     
      
    }
}
