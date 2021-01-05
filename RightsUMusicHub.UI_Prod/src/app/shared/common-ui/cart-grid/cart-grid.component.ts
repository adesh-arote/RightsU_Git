import { Component, OnInit,Input,OnChanges,SimpleChange, Output, EventEmitter } from '@angular/core';
import {CommonUiService} from '../../common-ui/common-ui.service'
import { DatePipe } from '@angular/common';
import { Router, ActivatedRoute, ParamMap ,NavigationEnd} from '@angular/router';
import {ComParentChildService} from '../../services/comparentchild.service'
declare var $: any;

@Component({
  selector: 'app-cart-grid',
  templateUrl: './cart-grid.component.html',
  styleUrls: ['./cart-grid.component.css'],
  providers:[CommonUiService,ComParentChildService]
})
export class CartGridComponent implements OnInit {
  @Input ('componentData') componentData:any;
  @Input ('newMusicConsumptionRequest') newMusicConsumptionRequest:any;
  @Input ('componentType') componentType:any;
  @Input('gridvalue') gridvalue:any;
  @Output() newList=new EventEmitter();
  public displaySubmitMessage:boolean=false;
  public alertHeader: string = "";
  public alertMessage: string = "";
  public text: any;
public episodeType;
public messageData:any;
public showName;
public listDetail1;
public listdetail;
public toplist;
public musicLabelList;
public load: boolean = false;
public searchText;
public newSearchRequest;
public getGenreList;
public searchList: any = [];
  public cartList: any = [];
  public cartListCount = 0;
  public displayAddNewPlayList:boolean=false;
  public playListMusicTitleCode;
  public newPlayListName;
  public displayalertMessage:Boolean=false;
  public validateCartRemark:boolean=true;
  public textRemarkCount = 0;
  public requestType:boolean=false;
  public recordCount=0;
  public rowonpage=10;
  public first=0;
  public searchShowGrid:boolean=false;
  constructor(private _CommonUiService:CommonUiService, private router: Router,private comparentchildservice: ComParentChildService) { 

  }
  ngOnChanges(changes: {[propKey: string]: SimpleChange}) {
    let log: string[] = [];
    // console.log(changes);
    for (let propName in changes) {
      console.log(propName);
      let changedProp = changes[propName];
      console.log(changedProp);
    //   let to = JSON.stringify(changedProp.currentValue);
      if (changedProp.isFirstChange()) {
        console.log("First Changes value.....! ");
        console.log(changedProp.currentValue);
      } else {
        console.log("On Changes value.....! ");
        console.log(changedProp.currentValue);
        if(this.componentType=="consumption"){
        this.quickSelectionGridData(changedProp.currentValue);
        }
        if(this.componentType=="quickSelection"){
          console.log(changedProp.currentValue.listview);
          if(propName=="componentData"){
            this.episodeType=changedProp.currentValue.episodeType;
          }
          if(propName=="gridvalue"){
            this.gridvalue=changedProp.currentValue;
            this.quickSelectionGridData(this.gridvalue.MHPlayListCode);
          }
          
        }
        // this.displayMessage=true;
        // this.alertHeader=changedProp.currentValue.header;
        // this.alertMessage=changedProp.currentValue.body;
      }
    }
    // this.changeLog.push(log.join(', '));
  }

  ngOnInit() {
    console.log(this.gridvalue);
 console.log(this.componentData)
 
 this.comparentchildservice.on('playlist-grid').subscribe(() => this.quickSelectionGridData(this.gridvalue.MHPlayListCode));
    console.log("Consumption data");
    console.log(this.newMusicConsumptionRequest);

    debugger;
    
    
    
 
    if(this.componentType=="consumption"){
      this.episodeType=this.componentData.episodeType;
    
    this.showName=this.componentData.showName;
    this.listDetail1=this.componentData.listview1;
    this.listdetail=this.componentData.listview;
    this.toplist=this.componentData.toplist;
    $(function(){
      $('.dropdwnbody1').slimScroll({
        height: '100px',
        
      });
    });
      this.requestType=true;
      this.load = true;
      this.addBlockUI();
      var musicLabelBody={
        "ChannelCode":this.newMusicConsumptionRequest.ChannelCode.Channel_Code,
        "TitleCode":this.newMusicConsumptionRequest.TitleCode.Title_Code
        }
        console.log(musicLabelBody);
      this._CommonUiService.getMusicLabels(musicLabelBody).subscribe(response => {
        this.load = false;
        this.removeBlockUI();
        console.log(response.Music);
        this.musicLabelList = response.Music;
        this.musicLabelList.unshift({ "MusicLabelName": "Music Label", "MusicLabelCode": 0 });
        this.newSearchRequest.MusicLabelCode = this.musicLabelList[0];
      }, error => { this.handleResponseError(error) });
      // this.load = true;
      // this.addBlockUI();
      this._CommonUiService.getGenre().subscribe(response => {
        // this.load = false;
        // this.removeBlockUI();
        this.getGenreList = response.Music;
        this.getGenreList.unshift({ "Genres_Name": "Genres", "Genres_Code": 0 });
        this.newSearchRequest.GenreCode = this.getGenreList[0];
      }, error => { this.handleResponseError(error) });
    }
    else if(this.componentType=="quickSelection"){
      this.episodeType=this.componentData.episodeType;
      console.log("Episode Type");
      console.log(this.componentData);
      console.log(this.episodeType);
      this.searchShowGrid=true;
    this.showName=this.componentData.showName;
    // this.listDetail1=this.componentData.listview1;
    this.listdetail=this.componentData.listview;
    // this.toplist=this.componentData.toplist;
    $(function(){
      $('.dropdwnbody1').slimScroll({
        height: '100px',
        
      });
    });
    console.log("Quick Selection Grid Code");
    console.log(this.gridvalue);
      this.quickSelectionGridData(this.gridvalue.MHPlayListCode);
    }

    this.newSearchRequest = {
      MusicLabelCode: 0,
      MusicTrack: "",
      MovieName: "",
      GenreCode: 0,
      TalentName: "",
      Tag: ""
    }
    
  }
  quickSelectionGridData(playlistvalue){
    // console.log("Grid Call....")
    var body = {
      'MusicLabelCode': '',
      'MusicTrack': '',
      'MovieName': '',
      'GenreCode': 0,
      'TalentName': '',
      'Tag': '',
      'MHPlayListCode':playlistvalue==null?'':playlistvalue,
      'PaginRequired':'N',
      'PageSize':'25',
      'PageNo':'1',
      'ChannelCode':'',
      'TitleCode':''
    }
console.log(JSON.stringify(body));
this.load = true;
    this.addBlockUI();
this._CommonUiService.getRecommendations(body).subscribe(response => {
  this.load = false;
    this.removeBlockUI();
        console.log("Song List");
        console.log(response);
        this.recordCount=response.RecordCount;
        this.searchList = response.Show;
        
          $(function(){
            $('.dropdwnbody').slimScroll({
              height: '100px',
              
            });
          });
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

  clearSearch() {
    debugger;
   // this.newSearchRequest.MusicLabelCode = 0;
    this.newSearchRequest.MusicTrack = '';
    this.newSearchRequest.MovieName = '';
    this.newSearchRequest.GenreCode = null;
    this.newSearchRequest.TalentName = '';
    this.newSearchRequest.Tag = '';
    this.newSearchRequest.MusicLabelCode = 0;
    this.newSearchRequest.GenreCode = 0;
    this.searchList = [];
    this.recordCount = 0;
  }
  searchTrack() {
    if(this.isClick==true){
      this.isClick=false;
      this.playListName='';
    }
    this.playListWiseClick='N';
    var body = {
      'MusicLabelCode': this.newSearchRequest.MusicLabelCode.MusicLabelCode == null ? 0 : this.newSearchRequest.MusicLabelCode.MusicLabelCode,
      'MusicTrack': this.newSearchRequest.MusicTrack,
      'MovieName': this.newSearchRequest.MovieName,
      'GenreCode': this.newSearchRequest.GenreCode.Genres_Code == null ? 0 : this.newSearchRequest.GenreCode.Genres_Code,
      'TalentName': this.newSearchRequest.TalentName,
      'Tag': this.newSearchRequest.Tag,
      'MHPlayListCode':0,
      'PaginRequired':'N',
      'PageSize':'25',
      'PageNo':'1',
      'ChannelCode':this.newMusicConsumptionRequest.ChannelCode.Channel_Code,
      'TitleCode':this.newMusicConsumptionRequest.TitleCode.Title_Code
    }
    debugger;
    var count = 0
    for (var property in body) {
      console.log(property);
      console.log(body);
      if (body[property] != 0 && body[property] != "" &&body[property] != '' && body[property] != null && body[property] != undefined) {
        count++;
      }
    }
console.log(count);
// if(this.newSearchRequest.MusicLabelCode.MusicLabelCode=='0'){
//   this.displayalertMessage=true;
  
//   this.messageData={
//     'header':"Error",
//     'body':"Select Music Label"
//   }
  
// }
// else  
if (count <= 5) {
      this.displayalertMessage=true;
      
      this.messageData={
        'header':"Error",
        'body':'Please select at least one criteria for searching'
        // 'body':"Select at least 1 filters for searching"
      }
      
    }
     
    else {
      this.load = true;
    this.addBlockUI();
    this.searchShowGrid=true;
    console.log(JSON.stringify(body));
      this._CommonUiService.getRecommendations(body).subscribe(response => {
        this.load = false;
      this.removeBlockUI();
      console.log("Grid List....!!!")
        console.log(response);
        this.recordCount=response.RecordCount;
        this.searchList = response.Show;
        // this.TotalRecords=this.searchList.length;
        // for(let i=0;i<this.searchList.length;i++){
          $(function(){
            $('.dropdwnbody').slimScroll({
              height: '100px',
              
            });
          });
        // }
        
       
      }, error => { this.handleResponseError(error) });
    }
  }
  public serchCriteria;
  public playListWiseClick='N';
  public isClick:boolean=false;
  public playListName='';
  listWiseGridSearch(playListCode,playListName){
    if(this.isClick==false){
      this.isClick=true;
      this.playListName=playListName;
    }
    else if(this.isClick==true){
      this.playListName=playListName;
    }
    this.playListWiseClick='Y'
    debugger;
     this.newSearchRequest.MusicLabelCode=this.musicLabelList[0];
     this.newSearchRequest.MusicTrack='';
     this.newSearchRequest.MovieName='';
     this.newSearchRequest.GenreCode=this.getGenreList[0];
     this.newSearchRequest.TalentName='';
     this.newSearchRequest.Tag='';
     this.serchCriteria=playListCode;
    var body = {
      'MusicLabelCode': '',
      'MusicTrack': '',
      'MovieName': '',
      'GenreCode': 0,
      'TalentName': '',
      'Tag': '',
      'MHPlayListCode':playListCode,
      'PaginRequired':'N',
      'PageSize':'25',
      'PageNo':'1',
      'ChannelCode':'',
      'TitleCode':''
    }
console.log(JSON.stringify(body));
this.load = true;
    this.addBlockUI();
this._CommonUiService.getRecommendations(body).subscribe(response => {
  this.load = false;
    this.removeBlockUI();
        console.log("Song List.......");
        console.log(response);
        this.searchShowGrid=true;
        this.recordCount=response.RecordCount;
        // this.recordCount=response.RecordCount;
        this.searchList = response.Show;
        
          $(function(){
            $('.dropdwnbody').slimScroll({
              height: '100px',
              
            });
          });
      }, error => { this.handleResponseError(error) });
  }
  public index=0;
  addToCart(track) {
    console.log(this.newMusicConsumptionRequest);
    console.log(track);
    console.log(this.index);
    track.data.Genre=track.data.Genre==""?"NA":track.data.Genre;
    track.data.StarCast=track.data.StarCast==""?"NA":track.data.StarCast;
    track.data.Singers=track.data.Singers==""?"NA":track.data.Singers;
    track.data.MusicLabel=track.data.MusicLabel==""?"NA":track.data.MusicLabel;
    track.data.MusicComposer=track.data.MusicComposer==""?"NA":track.data.MusicComposer;
    track.data.index=this.index;

    console.log(track.data);
    this.cartList.push(track.data);
    this.cartListCount++;
    this.index=this.index+1;
    this.searchList=this.searchList.filter(x=>x.Music_Title_Code !=track.data.Music_Title_Code);
    // this.recordCount=this.recordCount-1;
  // }
}
removeFromCart(id) {
  this.cartList = this.cartList.filter(x => x.index != id.index)
  this.cartListCount = this.cartList.length;
}
addNewPlaylist(playListData){
  this.playListMusicTitleCode=playListData.Music_Title_Code;
  
  // alert(JSON.stringify(playListData));
  this.displayAddNewPlayList=true;
  this.newPlayListName='';
}
createPlayList(){
  if(this.componentType=="consumption"){
  this.displayAddNewPlayList=false;
  var playlist={
    "PlaylistName": this.newPlayListName,
    "TitleCode":this.newMusicConsumptionRequest.TitleCode.Title_Code,
    "MHPlayListSong":
    [
        {
            "MusicTitleCode": this.playListMusicTitleCode
        }
    ]
  }
  
  this.load = true;
  this.addBlockUI();
  this._CommonUiService.createPlayList(playlist).subscribe(response=>{
    this.load = false;
    this.removeBlockUI();
    
    console.log("welcome");
    console.log(response);
    // this.displayMessage=true;
    this.displayalertMessage=true;
      
      this.messageData={
        'header':"Message",
        'body':response.Return.Message
      }
   
    
  this.getPlayList();
  }, error => { this.handleResponseError(error) }
)
  }
  else if(this.componentType=="quickSelection"){
    this.displayAddNewPlayList=false;
  var playlist={
    "PlaylistName": this.newPlayListName,
    "TitleCode":this.componentData.titleCode,
    "MHPlayListSong":
    [
        {
            "MusicTitleCode": this.playListMusicTitleCode
        }
    ]
  }
  
  this.load = true;
  this.addBlockUI();
  this._CommonUiService.createPlayList(playlist).subscribe(response=>{
    this.load = false;
    this.removeBlockUI();
    
console.log("welcome");
    console.log(response);
    // this.displayMessage=true;
    this.displayalertMessage=true;
      
      this.messageData={
        'header':"Message",
        'body':response.Return.Message
      }
   
    if(response.Return.IsSuccess==true){
      this.getPlayList();

    }
    }, error => { this.handleResponseError(error) })
  }
}
getPlayList(){
  if(this.componentType=="consumption"){
    var playlistbody=
    {
      "TitleCode":this.newMusicConsumptionRequest.TitleCode.Title_Code
    }
    
    this.load = true;
    this.addBlockUI();
  this._CommonUiService.getPlayList(playlistbody).subscribe(response=>{
  this.load = false;
  this.removeBlockUI();
   
  this.listdetail=response.MHPlayList;
  this.listDetail1=response.MHPlayList;
  
  
  this.filterlist();
  }, error => { this.handleResponseError(error) })  
  } 
  else if(this.componentType=="quickSelection"){
    
    var playlistbody=
    {
      "TitleCode":this.componentData.titleCode
    }
    
    this.load = true;
    this.addBlockUI();
  this._CommonUiService.getPlayList(playlistbody).subscribe(response=>{
  this.load = false;
  this.removeBlockUI();
   
  this.listdetail=response.MHPlayList;
  this.newList.emit(this.listdetail);
  // this.router.navigate([this.router.url]);
  // this.listDetail1=response.MHPlayList;
  
  }, error => { this.handleResponseError(error) })  
  }
  
}
filterlist(){
  this.toplist=[]
  for(let i=0;i<3 && i<this.listDetail1.length;i++){
    this.toplist.push(this.listDetail1[i]);

  }
  
  for(let i=0;i<3;i++){
    
    this.listDetail1=this.listDetail1.filter(x=>x !=this.toplist[i]);  

  }
  
}
consumptionCartRemarkChange() {
    
  if(this.newMusicConsumptionRequest.Remarks.trim().length==0){
    this.validateCartRemark=true;
    
  }
  else{
    this.validateCartRemark=false;
  }
  
      this.textRemarkCount = this.newMusicConsumptionRequest.Remarks.trim().length;
    }
attachPlayList(musicListData,playListValue){

  // alert("Click Devotional");
  // alert(JSON.stringify(musicListData));
  // alert(JSON.stringify(playListValue.MHPlayListCode));
  var attachlist={
    "MHPlayListCode": playListValue.MHPlayListCode,
    "MusicTitleCode":musicListData.Music_Title_Code
  }   
  this.load = true;
  this.addBlockUI();
  this._CommonUiService.createPlayListSong(attachlist).subscribe(response=>{
    this.load = false;
    this.removeBlockUI();

    
    this.displayalertMessage=true;
      
      this.messageData={
        'header':"Message",
        'body':response.Return.Message
      }
    // $('#messageModal').modal('show');
    

  }, error => { this.handleResponseError(error) })
  this.searchText='';
}
playListClick(){
  this.searchText='';
}
onMessageModalClick() {
  debugger;
  // window.location.reload()
  // $('#messageModal').modal('hide');
  this.displaySubmitMessage=false;
 console.log("'"+this.router.url+"'");
  
  this.router.navigate([this.router.url]);
}
submitRequest() {
if(this.componentType=="consumption"){
  this.consumtionSumbit();

}
else if(this.componentType=="quickSelection"){
  this.quickSelectionSubmit();

}
}
ValidationCheck(){
  debugger;
  console.log(this.newMusicConsumptionRequest)
  console.log(this.componentType)
  console.log(this.episodeType)
  if(this.componentType=="consumption"){
    if(this.episodeType=='range'){
      let fromdate=new Date(this.newMusicConsumptionRequest.TelecastFrom)
      let todate=new Date(this.newMusicConsumptionRequest.TelecastTo)
      
      if(parseInt(this.newMusicConsumptionRequest.EpisodeFrom)>=parseInt(this.newMusicConsumptionRequest.EpisodeTo)){
        // $('#Modal_MusicHub').modal('hide');
       
        this.displayalertMessage=true;
        
        this.messageData={
          'header':"Error",
          'body':"Episode To should greater than Episode From"
        }
  
      }
      else if(this.newMusicConsumptionRequest.EpisodeFrom==null ||this.newMusicConsumptionRequest.EpisodeTo==null){
        // $('#Modal_MusicHub').modal('hide');
        this.displayalertMessage=true;
        
        this.messageData={
          'header':"Error",
          'body':"Episode should not be blank..!"
        }
      }
      else 
        if(fromdate>=todate){
          // $('#Modal_MusicHub').modal('hide');
          this.displayalertMessage=true;
        
        this.messageData={
          'header':"Error",
          'body':"From Date should be Less Than To Date"
        }
  //         this.displaysubmitalertMessage=true;
  // this.alertErrorMessage="From Date should Less Than To Date";
  // $( "#Telecastto" ).focus();
  // this.renderer.selectRootElement('#Telecastto').onElement.focus();
        }
        else if(this.newMusicConsumptionRequest.TelecastFrom==null || this.newMusicConsumptionRequest.TelecastTo==null){
          // $('#Modal_MusicHub').modal('hide');
          this.displayalertMessage=true;
        
        this.messageData={
          'header':"Error",
          'body':"Date should not be Blank"
        }
        }
        else{
          return true;
        }
      }
      else if(this.episodeType=='tentative'){
        if(this.newMusicConsumptionRequest.EpisodeFrom==null || this.newMusicConsumptionRequest.EpisodeFrom==""){
          // $('#Modal_MusicHub').modal('hide');
          this.displayalertMessage=true;
          
          this.messageData={
            'header':"Error",
            'body':"Episode should not be blank..!"
          }
        }
        else if(this.newMusicConsumptionRequest.TelecastFrom==null || this.newMusicConsumptionRequest.TelecastFrom==""){
          // $('#Modal_MusicHub').modal('hide');
          this.displayalertMessage=true;
        
        this.messageData={
          'header':"Error",
          'body':"Date should not be Blank"
        }
        }
        else{
          return true;
        }
      }
  
  }
  else if(this.componentType=="quickSelection"){
    debugger;
    // let fromdate=new Date(this.newMusicConsumptionRequest.TelecastFrom)
    // let todate=new Date(this.newMusicConsumptionRequest.TelecastTo)
  
    if(this.newMusicConsumptionRequest.ChannelCode.Channel_Code=="0"){
      // $('#Modal_MusicHub').modal('hide');
      this.displayalertMessage=true;
    
    this.messageData={
      'header':"Error",
      'body':"Please Select Channel"
    }
    }
    else if(this.episodeType=='range'){
      let fromdate=new Date(this.newMusicConsumptionRequest.TelecastFrom)
      let todate=new Date(this.newMusicConsumptionRequest.TelecastTo)
      
      if(parseInt(this.newMusicConsumptionRequest.EpisodeFrom)>=parseInt(this.newMusicConsumptionRequest.EpisodeTo)){
        // $('#Modal_MusicHub').modal('hide');
       
        this.displayalertMessage=true;
        
        this.messageData={
          'header':"Error",
          'body':"Episode To should greater than Episode From"
        }
  
      }
      else if(this.newMusicConsumptionRequest.EpisodeFrom==null ||this.newMusicConsumptionRequest.EpisodeFrom==""||this.newMusicConsumptionRequest.EpisodeTo==null || this.newMusicConsumptionRequest.EpisodeTo==""){
        // $('#Modal_MusicHub').modal('hide');
        this.displayalertMessage=true;
        
        this.messageData={
          'header':"Error",
          'body':"Episode should not be blank..!"
        }
      }
      else 
        if(fromdate>=todate){
          // $('#Modal_MusicHub').modal('hide');
          this.displayalertMessage=true;
        
        this.messageData={
          'header':"Error",
          'body':"From Date should be Less Than To Date"
        }
  //         this.displaysubmitalertMessage=true;
  // this.alertErrorMessage="From Date should Less Than To Date";
  // $( "#Telecastto" ).focus();
  // this.renderer.selectRootElement('#Telecastto').onElement.focus();
        }
        else if(this.newMusicConsumptionRequest.TelecastFrom==null || this.newMusicConsumptionRequest.TelecastFrom=="" || this.newMusicConsumptionRequest.TelecastTo==null || this.newMusicConsumptionRequest.TelecastTo==""){
          // $('#Modal_MusicHub').modal('hide');
          this.displayalertMessage=true;
        
        this.messageData={
          'header':"Error",
          'body':"Date should not be Blank"
        }
        }
        else{
          return true;
        }
      }
      else if(this.episodeType=='tentative'){
        if(this.newMusicConsumptionRequest.EpisodeFrom==null ||this.newMusicConsumptionRequest.EpisodeFrom==""){
          // $('#Modal_MusicHub').modal('hide');
          this.displayalertMessage=true;
          
          this.messageData={
            'header':"Error",
            'body':"Episode should not be blank..!"
          }
        }
        else if(this.newMusicConsumptionRequest.TelecastFrom==null || this.newMusicConsumptionRequest.TelecastFrom==""){
          // $('#Modal_MusicHub').modal('hide');
          this.displayalertMessage=true;
        
        this.messageData={
          'header':"Error",
          'body':"Date should not be Blank"
        }
        }
        else{
          return true;
        }
      }
    
    // if(this.newMusicConsumptionRequest.EpisodeFrom==null ||this.newMusicConsumptionRequest.EpisodeFrom==''){
    //         // $('#Modal_MusicHub').modal('hide');
    //         this.displayalertMessage=true;
            
    //         this.messageData={
    //           'header':"Error",
    //           'body':"Episode should not be blank..!"
    //         }
    //       }
    //       else if(this.newMusicConsumptionRequest.TelecastFrom==null||this.newMusicConsumptionRequest.TelecastFrom==''){
    //         // $('#Modal_MusicHub').modal('hide');
    //         this.displayalertMessage=true;
          
    //       this.messageData={
    //         'header':"Error",
    //         'body':"Date should not be Blank"
    //       }
    //       }
    //       else 
    //     if(fromdate>todate){
    //       // $('#Modal_MusicHub').modal('hide');
    //       this.displayalertMessage=true;
        
    //     this.messageData={
    //       'header':"Error",
    //       'body':"From Date should be Less Than To Date"
    //     }
    //   }
    //       else{
    //         return true;
    //       }
  
  }
  
}
cartModalShow(){
if(this.ValidationCheck()){
  $('#Modal_MusicHub').modal('show');
}
}
consumtionSumbit(){
  console.log(this.newMusicConsumptionRequest);
  debugger;
  var datePipe = new DatePipe('en-GB');
    
//   if(this.episodeType=='range'){
//     let fromdate=new Date(this.newMusicConsumptionRequest.TelecastFrom)
//     let todate=new Date(this.newMusicConsumptionRequest.TelecastTo)
    
//     if(parseInt(this.newMusicConsumptionRequest.EpisodeFrom)>=parseInt(this.newMusicConsumptionRequest.EpisodeTo)){
//       $('#Modal_MusicHub').modal('hide');
     
//       this.displayalertMessage=true;
      
//       this.messageData={
//         'header':"Error",
//         'body':"Episode To should greater than Episode From"
//       }

//     }
//     else if(this.newMusicConsumptionRequest.EpisodeFrom==null ||this.newMusicConsumptionRequest.EpisodeTo==null){
//       $('#Modal_MusicHub').modal('hide');
//       this.displayalertMessage=true;
      
//       this.messageData={
//         'header':"Error",
//         'body':"Episode should not be blank..!"
//       }
//     }
//     else 
//       if(fromdate>=todate){
//         $('#Modal_MusicHub').modal('hide');
//         this.displayalertMessage=true;
      
//       this.messageData={
//         'header':"Error",
//         'body':"From Date should Less Than or Not equal to To Date"
//       }
// //         this.displaysubmitalertMessage=true;
// // this.alertErrorMessage="From Date should Less Than To Date";
// // $( "#Telecastto" ).focus();
// // this.renderer.selectRootElement('#Telecastto').onElement.focus();
//       }
//       else if(this.newMusicConsumptionRequest.TelecastFrom==null || this.newMusicConsumptionRequest.TelecastTo==null){
//         $('#Modal_MusicHub').modal('hide');
//         this.displayalertMessage=true;
      
//       this.messageData={
//         'header':"Error",
//         'body':"Date should not be Blank"
//       }
//       }
//       else{

        
        this.cartList.forEach(track => {
          this.newMusicConsumptionRequest.MHRequestDetails.push({ MusicTitleCode: track.Music_Title_Code })
        });
        this.newMusicConsumptionRequest.Remarks=this.newMusicConsumptionRequest.Remarks.trim().toString();
    
        this.newMusicConsumptionRequest.EpisodeFrom = this.newMusicConsumptionRequest.EpisodeFrom.toString();
        this.newMusicConsumptionRequest.EpisodeTo = this.newMusicConsumptionRequest.EpisodeTo.toString();
        this.newMusicConsumptionRequest.TelecastFrom = datePipe.transform(this.newMusicConsumptionRequest.TelecastFrom.toString(), 'dd-MMM-yyyy') ;
        this.newMusicConsumptionRequest.TelecastTo = datePipe.transform(this.newMusicConsumptionRequest.TelecastTo.toString()==''?this.newMusicConsumptionRequest.TelecastFrom.toString():this.newMusicConsumptionRequest.TelecastTo.toString(), 'dd-MMM-yyyy') ;
        this.newMusicConsumptionRequest.TitleCode = this.newMusicConsumptionRequest.TitleCode.Title_Code;
        this.newMusicConsumptionRequest.ChannelCode=this.newMusicConsumptionRequest.ChannelCode.Channel_Code;
        
        this.load = true;
        this.addBlockUI();
        this._CommonUiService.submitMusicConsumptionRequest(this.newMusicConsumptionRequest).subscribe(response => {
          this.load = false;
        this.removeBlockUI();
          debugger;
          console.log("consumption request..!");
         console.log(response);
          var obj = response
          
          $('#Modal_MusicHub').modal('hide');
          // $('#messageModal').modal('show');
          this.displaySubmitMessage=true;
          this.alertHeader="Success Message";
          this.alertMessage = "Request ID " + obj.RequestID + " sent for approval.";
          
         
    
        }, error => { this.handleResponseError(error) });
      
    //     }
    // }
  //   else{
  //     if(this.newMusicConsumptionRequest.EpisodeFrom==null){
  //       $('#Modal_MusicHub').modal('hide');
  //       this.displayalertMessage=true;
        
  //       this.messageData={
  //         'header':"Error",
  //         'body':"Episode should not be blank..!"
  //       }
  //     }
  //     else if(this.newMusicConsumptionRequest.TelecastFrom==null){
  //       $('#Modal_MusicHub').modal('hide');
  //       this.displayalertMessage=true;
      
  //     this.messageData={
  //       'header':"Error",
  //       'body':"Date should not be Blank"
  //     }
  //     }
  //     else{
      
  //     this.cartList.forEach(track => {
  //       this.newMusicConsumptionRequest.MHRequestDetails.push({ MusicTitleCode: track.Music_Title_Code })
  //     });
  //     this.newMusicConsumptionRequest.Remarks=this.newMusicConsumptionRequest.Remarks.trim().toString();
  
  //     this.newMusicConsumptionRequest.EpisodeFrom = this.newMusicConsumptionRequest.EpisodeFrom.toString();
  //     this.newMusicConsumptionRequest.EpisodeTo = this.newMusicConsumptionRequest.EpisodeTo.toString();
  //     this.newMusicConsumptionRequest.TelecastFrom = datePipe.transform(this.newMusicConsumptionRequest.TelecastFrom.toString(), 'dd-MMM-yyyy') ;
  //     this.newMusicConsumptionRequest.TelecastTo = datePipe.transform(this.newMusicConsumptionRequest.TelecastTo.toString()==''?this.newMusicConsumptionRequest.TelecastFrom.toString():this.newMusicConsumptionRequest.TelecastTo.toString(), 'dd-MMM-yyyy') ;
  //     this.newMusicConsumptionRequest.TitleCode = this.newMusicConsumptionRequest.TitleCode.Title_Code;
  //     this.newMusicConsumptionRequest.ChannelCode=this.newMusicConsumptionRequest.ChannelCode.Channel_Code;
      
  //     this.load = true;
  // this.addBlockUI();
  //     this._CommonUiService.submitMusicConsumptionRequest(this.newMusicConsumptionRequest).subscribe(response => {
  //       this.load = false;
  //   this.removeBlockUI();
  //       debugger;
        
  //       var obj = response
        
  //       $('#Modal_MusicHub').modal('hide');
  //       this.displaySubmitMessage=true;
  //       // $('#messageModal').modal('show');
  //       this.alertHeader="Success Message";
  //       this.alertMessage = "Request Id " + obj.RequestID + " sent for approval.";
        
  //     });
  //   }
  //   }

}
quickSelectionSubmit(){
var datePipe = new DatePipe('en-GB');
    
  
// if(this.newMusicConsumptionRequest.ChannelCode.Channel_Code=="0"){
//   $('#Modal_MusicHub').modal('hide');
//   this.displayalertMessage=true;

// this.messageData={
//   'header':"Error",
//   'body':"Please Select Channel"
// }
// }
// else if(this.newMusicConsumptionRequest.EpisodeFrom==null ||this.newMusicConsumptionRequest.EpisodeFrom==''){
//         $('#Modal_MusicHub').modal('hide');
//         this.displayalertMessage=true;
        
//         this.messageData={
//           'header':"Error",
//           'body':"Episode should not be blank..!"
//         }
//       }
//       else if(this.newMusicConsumptionRequest.TelecastFrom==null||this.newMusicConsumptionRequest.TelecastFrom==''){
//         $('#Modal_MusicHub').modal('hide');
//         this.displayalertMessage=true;
      
//       this.messageData={
//         'header':"Error",
//         'body':"Date should not be Blank"
//       }
//       }
      // else{
      
      this.cartList.forEach(track => {
        this.newMusicConsumptionRequest.MHRequestDetails.push({ MusicTitleCode: track.Music_Title_Code })
      });
      this.newMusicConsumptionRequest.Remarks=this.newMusicConsumptionRequest.Remarks.trim().toString();
  
      this.newMusicConsumptionRequest.EpisodeFrom = this.newMusicConsumptionRequest.EpisodeFrom.toString();
      this.newMusicConsumptionRequest.EpisodeTo = this.newMusicConsumptionRequest.EpisodeTo.toString();
      this.newMusicConsumptionRequest.TelecastFrom = datePipe.transform(this.newMusicConsumptionRequest.TelecastFrom.toString(), 'dd-MMM-yyyy') ;
      this.newMusicConsumptionRequest.TelecastTo = datePipe.transform(this.newMusicConsumptionRequest.TelecastTo.toString(), 'dd-MMM-yyyy') ;
      this.newMusicConsumptionRequest.TitleCode = this.newMusicConsumptionRequest.TitleCode.Title_Code;
      this.newMusicConsumptionRequest.ChannelCode=this.newMusicConsumptionRequest.ChannelCode.Channel_Code;
  console.log("quick Selction body");
  console.log(JSON.stringify(this.newMusicConsumptionRequest));    
      this.load = true;
  this.addBlockUI();

      this._CommonUiService.submitMusicConsumptionRequest(this.newMusicConsumptionRequest).subscribe(response => {
        this.load = false;
    this.removeBlockUI();
        debugger;
        
        var obj = response
        
        $('#Modal_MusicHub').modal('hide');
        this.displaySubmitMessage=true;
        // $('#messageModal').modal('show');
        this.alertHeader="Success Message";
        this.alertMessage = "Request ID " + obj.RequestID + " sent for approval.";
        
      }, error => { this.handleResponseError(error) });
    // }
    
}
paginationchange(pagval){
  alert("Pagination change");
  alert(JSON.stringify(pagval));
}
loadDataOnPagination(event){
  debugger;
  console.log("Lazy Loading.....");
  var pageNo=event.first;
  var pageSize=event.rows;
if(this.rowonpage !=pageSize){
this.rowonpage=pageSize;
if(event.first==0){
  this.onpagechange(pageSize,pageNo);
}
else{
  this.first=0;
}

}
else{
this.first=event.first;
if(event.first==0){
  pageNo=event.first+1;
  this.onpagechange(pageSize,pageNo);
}
else{
  pageNo=(event.first/event.rows)+1;
  this.onpagechange(pageSize,pageNo);
}

}
  
}
onpagechange(pageSize,pageNo){
  console.log("onpageChanges");
  var body;
  if(this.componentType=="consumption"){
    
    body = {
      'MusicLabelCode': this.newSearchRequest.MusicLabelCode.MusicLabelCode,
      'MusicTrack': this.newSearchRequest.MusicTrack,
      'MovieName': this.newSearchRequest.MovieName,
      'GenreCode': this.newSearchRequest.GenreCode.Genres_Code == null ? 0 : this.newSearchRequest.GenreCode.Genres_Code,
      'TalentName': this.newSearchRequest.TalentName,
      'Tag': this.newSearchRequest.Tag,
      'MHPlayListCode':this.playListWiseClick=='Y'?this.serchCriteria:'',
      'PaginRequired':'N',
      'PageSize':pageSize,
      'PageNo':pageNo,
      'ChannelCode':this.playListWiseClick=='Y'?'':this.newMusicConsumptionRequest.ChannelCode.Channel_Code,
      'TitleCode':this.playListWiseClick=='Y'?'':this.newMusicConsumptionRequest.TitleCode.Title_Code
    }
  }
  else if(this.componentType=="quickSelection"){
    body = {
      'MusicLabelCode': '',
      'MusicTrack': '',
      'MovieName': '',
      'GenreCode': 0,
      'TalentName': '',
      'Tag': '',
      'MHPlayListCode':this.gridvalue==null?'':this.gridvalue.MHPlayListCode,
      'PaginRequired':'N',
      'PageSize':pageSize,
      'PageNo':pageNo,
      'ChannelCode':'',
      'TitleCode':''
    }
    // this.quickSelectionGridData(this.gridvalue);
   
  }
  // this.recordCount=0;
this.load = true;
this.addBlockUI();

console.log("onpage change body");
console.log(body);
this._CommonUiService.getRecommendations(body).subscribe(response => {
  
    this.load = false;
  this.removeBlockUI();
    console.log(response);
    this.recordCount=response.RecordCount;
    this.searchList = response.Show;
    // this.TotalRecords=this.searchList.length;
    // for(let i=0;i<this.searchList.length;i++){
      $(function(){
        $('.dropdwnbody').slimScroll({
          height: '100px',
          
        });
      });
    // }
    
   
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
modalclose(){
  this.newMusicConsumptionRequest.Remarks="";
  this.textRemarkCount=this.newMusicConsumptionRequest.Remarks.length;
}
}
