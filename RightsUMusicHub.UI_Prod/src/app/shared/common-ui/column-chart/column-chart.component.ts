import { Component, OnInit,Input,OnChanges,SimpleChange } from '@angular/core';
import { DashboardService } from '../../../dashboard/dashboard.service';
import {Router} from "@angular/router"
declare var google: any;
declare var $: any;
@Component({
  selector: 'app-column-chart',
  templateUrl: './column-chart.component.html',
  styleUrls: ['./column-chart.component.css'],
  providers:[DashboardService]
})
export class ColumnChartComponent implements OnInit {

  @Input() barDataRequest;
  public barChartDetailsList = [];
  public barChartList:any;
  public TotalCountBarChartDetail;
  public showChartDetails: boolean = false;
  // public showBarChartDetails: boolean = false;
  public chartPlaceHolderText:any='';
  public alertHeader
  public chartSearch="";
  public BarChartDataOnText;
  public BarChartDataOn=1;
  public load: boolean = false;
  public responseBarData = [];
  public showBarLabel:boolean=false;
  public showPieChartDetails: boolean = false;
  public pieChartDetailsList = [];
  public pieChartList:any;
  public chart= {
  
    type: 'ColumnChart',
    data: [''],
    columnNames: [''],
        options: {
      legend: { position: 'top', 'alignment': 'center', maxLines: 7 },
            bar: { groupWidth: '80%' },
      is3D: true,
      hAxis: {
        count: -1,
        slantedText: true,  /* Enable slantedText for horizontal axis */
    }
    }
  };;

  constructor(private _dashboardService:DashboardService,private router:Router) {
    google.charts.load('current', { 'packages': ['bar'] });
    google.charts.setOnLoadCallback(this.getBarChartDataMethod(1));
   }
   ngOnChanges(changes: {[propKey: string]: SimpleChange}) {
    let log: string[] = [];
    
    for (let propName in changes) {
      let changedProp = changes[propName];
      console.log(changedProp);
    
      if (changedProp.isFirstChange()) {
        
      } else {
        console.log("On Changes value.....! ");
        console.log(changedProp.currentValue);
        this.getBarChartDataMethod(changedProp.currentValue)
    
      }
    }
    
  }
  ngOnInit() {
  }
  
  public showName;
  public musicLabelName;
  onSelect(event){
    console.log(event);
        if(event.length!=0){
          if(event[0].row !=null){
            this.showName = this.chart.data[event[0].row][0];
            this.musicLabelName=this.chart.columnNames[event[0].column];
      this.barChartDetails(this.showName,this.musicLabelName);
          }
          else if(event[0].row !=null && event.length==1){
            if(this.showName !=null && this.musicLabelName !=null){
              this.barChartDetails(this.showName,this.musicLabelName);
            }
      
          } 
    }
    else if(event.length==0){
      if(this.showName !=null && this.musicLabelName !=null){
        this.barChartDetails(this.showName,this.musicLabelName);
      }
    }
    
  }
  
  barchartHandler2(){
    $('#barchart').css('cursor','pointer');
  }
  barchartHandler3(){
    $('#barchart').css('cursor','default');
  }
  getBarChartDataMethod(searchBarChartCriteria) {
    debugger;
  
    this.BarChartDataOn=searchBarChartCriteria;
    
    this.load = true;
    this.addBlockUI();
    var BarChartBody={    
      "NoOfMonths":searchBarChartCriteria
      }  
      console.log(BarChartBody);
      this.responseBarData=[];
    this._dashboardService.getBarChartData(BarChartBody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      console.log("Bar Graph Data...");
      console.log(response);
      this.responseBarData = response.BarChart;
      if (response.BarChart.length != 0){
        //if ((response.BarChart[0].ShowName != "NA")){
        // this.processBarData();  
        var obj=[];
        for (let i = 0; i < this.responseBarData.length; i++) {
          debugger;
          var detailobj = [];

          this.showBarLabel = false;
          console.log(this.responseBarData[i].Details.length);
          // demolist.copyWithin(demolist.toString(),demol.toString())

          detailobj.push([this.responseBarData[i].Details[0].Usage, this.responseBarData[i].Details[1].Usage]);//,this.responseBarData[i].Details[2].Usage, this.responseBarData[i].Details[3].Usage])
        if(this.responseBarData[i].Details.length==1){
          obj.push([this.responseBarData[i].ShowName,this.responseBarData[i].Details[0].Usage])

        }
        else if(this.responseBarData[i].Details.length==2){
          obj.push([this.responseBarData[i].ShowName,this.responseBarData[i].Details[0].Usage,this.responseBarData[i].Details[1].Usage])

        }
        else if(this.responseBarData[i].Details.length==3){
          obj.push([this.responseBarData[i].ShowName,this.responseBarData[i].Details[0].Usage,this.responseBarData[i].Details[1].Usage,this.responseBarData[i].Details[2].Usage])

        }
        else if(this.responseBarData[i].Details.length==4){
          obj.push([this.responseBarData[i].ShowName,this.responseBarData[i].Details[0].Usage,this.responseBarData[i].Details[1].Usage,this.responseBarData[i].Details[2].Usage,this.responseBarData[i].Details[3].Usage])

        }
        else if(this.responseBarData[i].Details.length==5){
          obj.push([this.responseBarData[i].ShowName,this.responseBarData[i].Details[0].Usage,this.responseBarData[i].Details[1].Usage,this.responseBarData[i].Details[2].Usage,this.responseBarData[i].Details[3].Usage,this.responseBarData[i].Details[4].Usage])

        }
        else if(this.responseBarData[i].Details.length==6){
          obj.push([this.responseBarData[i].ShowName,this.responseBarData[i].Details[0].Usage,this.responseBarData[i].Details[1].Usage,this.responseBarData[i].Details[2].Usage,this.responseBarData[i].Details[3].Usage,this.responseBarData[i].Details[4].Usage,this.responseBarData[i].Details[5].Usage])

        }
        else if(this.responseBarData[i].Details.length==7){
          obj.push([this.responseBarData[i].ShowName,this.responseBarData[i].Details[0].Usage,this.responseBarData[i].Details[1].Usage,this.responseBarData[i].Details[2].Usage,this.responseBarData[i].Details[3].Usage,this.responseBarData[i].Details[4].Usage,this.responseBarData[i].Details[5].Usage,this.responseBarData[i].Details[6].Usage])

        }
        else if(this.responseBarData[i].Details.length==8){
          obj.push([this.responseBarData[i].ShowName,this.responseBarData[i].Details[0].Usage,this.responseBarData[i].Details[1].Usage,this.responseBarData[i].Details[2].Usage,this.responseBarData[i].Details[3].Usage,this.responseBarData[i].Details[4].Usage,this.responseBarData[i].Details[5].Usage,this.responseBarData[i].Details[6].Usage,this.responseBarData[i].Details[7].Usage])

        }
      }
      var dataname=[];
      if(this.responseBarData[0].Details.length==1){
        dataname.push(['showName',this.responseBarData[0].Details[0].LabelName])
        
      }
      else if(this.responseBarData[0].Details.length==2){
        dataname.push(['showName',this.responseBarData[0].Details[0].LabelName,this.responseBarData[0].Details[1].LabelName])
        
      }
      else if(this.responseBarData[0].Details.length==3){
        dataname.push(['showName',this.responseBarData[0].Details[0].LabelName,this.responseBarData[0].Details[1].LabelName,this.responseBarData[0].Details[2].LabelName])
        
      }
      else if(this.responseBarData[0].Details.length==4){
        dataname.push(['showName',this.responseBarData[0].Details[0].LabelName,this.responseBarData[0].Details[1].LabelName,this.responseBarData[0].Details[2].LabelName,this.responseBarData[0].Details[3].LabelName])
        
      }
      else if(this.responseBarData[0].Details.length==5){
        dataname.push(['showName',this.responseBarData[0].Details[0].LabelName,this.responseBarData[0].Details[1].LabelName,this.responseBarData[0].Details[2].LabelName,this.responseBarData[0].Details[3].LabelName,this.responseBarData[0].Details[4].LabelName])
        
      }
      else if(this.responseBarData[0].Details.length==6){
        dataname.push(['showName',this.responseBarData[0].Details[0].LabelName,this.responseBarData[0].Details[1].LabelName,this.responseBarData[0].Details[2].LabelName,this.responseBarData[0].Details[3].LabelName,this.responseBarData[0].Details[4].LabelName,this.responseBarData[0].Details[5].LabelName])
        
      }
      else if(this.responseBarData[0].Details.length==7){
        dataname.push(['showName',this.responseBarData[0].Details[0].LabelName,this.responseBarData[0].Details[1].LabelName,this.responseBarData[0].Details[2].LabelName,this.responseBarData[0].Details[3].LabelName,this.responseBarData[0].Details[4].LabelName,this.responseBarData[0].Details[5].LabelName,this.responseBarData[0].Details[6].LabelName])
        
      }
      else if(this.responseBarData[0].Details.length==8){
        dataname.push(['showName',this.responseBarData[0].Details[0].LabelName,this.responseBarData[0].Details[1].LabelName,this.responseBarData[0].Details[2].LabelName,this.responseBarData[0].Details[3].LabelName,this.responseBarData[0].Details[4].LabelName,this.responseBarData[0].Details[5].LabelName,this.responseBarData[0].Details[6].LabelName,this.responseBarData[0].Details[7].LabelName])
        
      }
      console.log(obj);
      this.chart= {
  
        type: 'ColumnChart',
        data: obj,
        columnNames: dataname[0],
        options: {
          legend: { position: 'top', 'alignment': 'center', maxLines: 7 },
                bar: { groupWidth: '80%' },
          is3D: true,
          hAxis: {
            count: -1,
            slantedText: true,  /* Enable slantedText for horizontal axis */
        }
        
        }
      };
      console.log("Chart Obj");
      console.log(this.chart);      
      }
      else{
        this.showBarLabel=true;
      }
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

  processBarData() {

    let  musicLabels = [], datasetObjArr = [],barChartObj=[];
    barChartObj[0]=[];
    // barChartObj[0].push('Show Name')
    barChartObj[0].push('')
    
    this.responseBarData.forEach(element => {
      
      element.Details.forEach(ele => {
        if (!musicLabels.includes(ele.LabelName)) {
          musicLabels.push(ele.LabelName);
          barChartObj[0].push(ele.LabelName);
        }
      });
    })
   console.log("music labels Data");
   console.log(musicLabels);
   console.log("Response bar data stored");
   console.log(this.responseBarData);
      this.responseBarData.forEach(ele => {
        var temp=[];
        temp.push(ele.ShowName);
        musicLabels.forEach(element => {
         
        var index = ele.Details.findIndex(obj => obj.LabelName == element);
        if (index > -1) {
          temp.push(ele.Details[index].Usage);
        } else {
          temp.push(0);
        }
      })
      barChartObj.push(temp);
    })
  console.log("Bar Chart Object");
   console.log(barChartObj);
   var musiclabel;
   var barChartData=[];
   for(let i=0;i<barChartObj.length;i++){
     if(i==0){
      var musiclabel=barChartObj[0]

     }
     else{
       barChartData.push(barChartObj[i]);
     }
   }
   console.log(musiclabel);
   console.log(barChartData);
    //  var data = google.visualization.arrayToDataTable(barChartObj);
    
     var bardata =new google.visualization.DataTable(barChartObj);
     for(let j=0;j<musiclabel.length;j++)
     {
      //  debugger;
       if(j==0){
        bardata.addColumn('string', musiclabel[j]);
         
       }
       else{
        bardata.addColumn('number', musiclabel[j]);
         
       }
     }
   
     var demodata=[]
  for(let k=0;k<barChartData.length;k++){
demodata.push((barChartData[k]))    
  }
  console.log(JSON.parse(JSON.stringify(demodata)));
  bardata.addRows(barChartData);
// for(let k=0;k<barChartData.length;k++){
//   data.addRow([  
//     barChartData[k][0],barChartData[k][1],barChartData[k][2],barChartData[k][3],barChartData[k][4]
//   ]);
// }
        var options = {
          // bar: {groupWidth: "90%"},
          // legend: { position: "relative"},
          // legend: { position: 'right','alignment':'center', maxLines: 10 },
          // legend: { 'alignment':'center' },  
          legend: { position: 'top', 'alignment': 'center', maxLines: 5 },
                bar: { groupWidth: '80%' },
          is3D: true,
          height:250,
          hAxis: {
            // title: "Shows",
            // direction:-1,
            // textPosition:'out',
            // logScale:true,
            count: -1,
            slantedText: true,  /* Enable slantedText for horizontal axis */
            // slantedTextAngle: 43 /* Define slant Angle */
        }
        
        };
       
        var barChart = new google.visualization.ColumnChart(document.getElementById('barchart'));
        console.log(bardata);
        barChart.draw(bardata, options);
        google.visualization.events.addListener(barChart, 'onmouseover', this.barchartHandler2);
      google.visualization.events.addListener(barChart, 'onmouseout', this.barchartHandler3);
        google.visualization.events.addListener(barChart, 'select', () => {
          var selectedItem = barChart.getSelection()[0];
          console.log("Selected bar chart");
          console.log(selectedItem);
         debugger;
  
         if(this.CheckItemSelection(selectedItem)){
          if (this.columnSelectedData) {
            console.log(bardata);
            var showName = bardata.getValue(this.columnSelectedData.row,0);
            console.log(showName);
            // alert(JSON.stringify(showName));
            console.log(barChartObj)
            var musicLabelName=barChartObj[0][this.columnSelectedData.column];
            // alert(JSON.stringify(musicLabelName));
          }
          this.barChartDetails(showName,musicLabelName);
        }
        });
   
  }
  
  filter(listFilter){
    
  
    debugger;
    
        this.barChartDetailsList = this.barChartList.filter(item => (item.MusicTrackName.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
      || item.Movie_Album.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
      || item.MusicLanguage.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.YearOfRelease.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1)
      );
      
   
    
     
  }
public columnSelectedData;
  CheckItemSelection(selectedData){
    if(selectedData==null){
      return true
    }
    else{
      this.columnSelectedData=selectedData
    console.log(selectedData);
    if(selectedData.column==1 && selectedData.row==null){
      return false;
                }
                else if(selectedData.column==2 && selectedData.row==null){
                  return false;
      
                }
                else if(selectedData.column==3 && selectedData.row==null){
                  return false;
      
                }
                else if(selectedData.column==4 && selectedData.row==null){
                  return false;
      
                }
                else{
                  return true;
                }
              }
  }
  
  barChartDetails(showName,musicLabelName) {
    this.chartSearch=null
    debugger;
    this.load = true;
    this.addBlockUI();
    this._dashboardService.getLabelWiseUsage({ "ShowName": showName, "LabelName": musicLabelName,"NoOfMonths":this.BarChartDataOn }).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      console.log("Bar Graph Detail...");
      console.log(response);
      this.barChartDetailsList = response.LabelWiseList;
      this.barChartList=response.LabelWiseList;
      this.TotalCountBarChartDetail=response.LabelWiseList.length;
      this.showChartDetails = true;
      // this.showBarChartDetails = true;
      this.chartPlaceHolderText="Track Name, Movie/Album"
      this.alertHeader = "Music Tracks Consumed : " + showName;
    }, error => { this.handleResponseError(error) });
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
