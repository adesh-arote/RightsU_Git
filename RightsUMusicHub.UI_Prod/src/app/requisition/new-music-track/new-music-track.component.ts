import { Component, OnInit } from '@angular/core';
import { RequisitionService } from '../requisition.service'
import { Message } from 'primeng/components/common/api';
import { Subject } from 'rxjs';
import { DatePipe } from '@angular/common';
import {Router} from '@angular/router'

// import * as $ from 'jquery';
declare var $: any;
@Component({
  selector: 'app-new-music-track',
  templateUrl: './new-music-track.component.html',
  styleUrls: ['./new-music-track.component.css'],
  providers: [RequisitionService]
})
export class NewMusicTrackComponent implements OnInit {


  msgs: Message[] = [];
  msgs1: Message[] = [];
  
  public musicSearch: any;
  public movieSearch: any;
  public tablMusicList: any[] = [];
  public tablMovieAlbumList: any[] = [];
  public noOfRowMusic;
  public noOfRowAlbm;
  public musicLabelList;
  public movieList;
  public musicResponse;
  public albumResponse;
  public submitHeader;
  public submitMessage;
  public breadcrumbtext = 'Music';
  // public musicRemark;
  // private moviealbumRemark;
  public textRemarkCount = 0;
  public movieAlbumRemarkCount = 0;
  // public saveMusicList:any[]=[];
  public saveMusicBody = {
    Remarks: '',
    MHRequestDetails: []

  }

  public saveMovieAlbumBody = {
    Remarks: '',
    MHRequestDetails: []
  }
  public requestMusicListBody = {
    MHRequestTypeCode: '2'
  }
  public requestAlbumListBody = {
    MHRequestTypeCode: '3'
  }
  public requestMusicList;
  public requestAlbumList;
  public musicDetailList;
  public musicReuestHeader;
  public isMusicDetail: boolean = false;
  public isAlbumDetail: boolean = false;
  public albumDetailList;
  // public rBtnMovieAlbum='Movie';
  public display: boolean = false;
  public displayAlbum: boolean = false;
  public displayFinal: Boolean = false;
  public dialogRequestDetail: boolean = false;
  public load: boolean = false;
  constructor(private _requisitionService: RequisitionService,private router:Router) {
    
  }

  ngOnInit() {

  
    this.noOfRowMusic = "1";
    this.noOfRowAlbm = "1";
    this.load = true;
    this.addBlockUI();
    var musicLabelBody={
      "ChannelCode":'',
      "TitleCode":''
      }
    this._requisitionService.getMusicLabels(musicLabelBody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();

      this.musicLabelList = response.Music;
      console.log(this.musicLabelList);
    }, error => { this.handleResponseError(error) });
    this.load = true;
    this.addBlockUI();
    this._requisitionService.getMusicAlbumLabels().subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      this.movieList = response.Music_Album;
      console.log(this.movieList);
    }, error => { this.handleResponseError(error) });
    this.requestAlbumListMethod();
    this.requestMusicListMethod();
  }
  public totalCountOfMusicTrack=0;
  public totalCountofMovieAlbum=0;
  public albumList:any;
  requestAlbumListMethod() {
    this.load = true;
    this.addBlockUI();
    this._requisitionService.GetMovieAlbumMusicList(this.requestAlbumListBody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      console.log("Album List");
      console.log(response);
      this.requestAlbumList = response.RequestList;
      this.albumList=response.RequestList;
      this.totalCountofMovieAlbum=response.RequestList.length;
      console.log("Request Album List")
      console.log(this.requestAlbumList);
    }, error => { this.handleResponseError(error) });
  }
  public musicList:any;
  requestMusicListMethod() {
    this.load = true;
    this.addBlockUI();
    this._requisitionService.GetMovieAlbumMusicList(this.requestMusicListBody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
      this.musicList=response.RequestList;
      this.requestMusicList = response.RequestList;
      this.totalCountOfMusicTrack=response.RequestList.length;
      console.log("this is music list");
      console.log(response)
      console.log(this.requestMusicList);


    }, error => { this.handleResponseError(error) });


  }
  filter(listFilter,filterby){
    var datePipe = new DatePipe('en-GB');
    //console.log(JSON.stringify(listFilter));
    debugger;
    if(filterby=='Music'){
      this.requestMusicList = this.musicList.filter(item => (item.RequestID.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
      || item.CountRequest.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
      || item.RequestedBy.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.Status.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || datePipe.transform(item.RequestDate.toString(), 'dd-MMM-yyyy').toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      // || item.AdvertiserNAme.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      // || item.Startdate.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      // || item.Enddate.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
    )
      );
    }
    else if(filterby=='Movie'){
      this.requestAlbumList = this.albumList.filter(item => (item.RequestID.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
    || item.CountRequest.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
    || item.RequestedBy.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
    || item.Status.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
    || datePipe.transform(item.RequestDate.toString(), 'dd-MMM-yyyy').toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
    // || item.AdvertiserNAme.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
    // || item.Startdate.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
    // || item.Enddate.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
  )
    );
    }
    else if(filterby=='musicDetail'){
      this.musicDetailFilterList=this.musicDetailList.filter(item => (item.RequestedMusicTitleName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
      || item.ApprovedMusicTitleName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
      || item.MusicLabelName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.MusicMovieAlbumName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.CreateMap.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.IsApprove.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      // || item.Startdate.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      // || item.Enddate.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
    ))
    }
    else if(filterby=='albumDetail'){
      this.albumDetailFilterList=this.albumDetailList.filter(item => (item.RequestedMovieAlbumName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
      || item.ApprovedMovieAlbumName.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1 
      || item.MovieAlbum.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.CreateMap.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      || item.IsApprove.toString().toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      // || item.IsApprove.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      // || item.Startdate.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
      // || item.Enddate.toLocaleLowerCase().indexOf(listFilter.toLocaleLowerCase()) > -1
    ))
    }

     
  }
  public filteredMoviesSingle: any[] = [];
  public singerList:any[]=[];
  public startCastList:any[]=[];
  filteredMovieSingle(event) {
    // alert(JSON.stringify(event));
    let query = event.query;
    let movieTextSearchbody = {
      'MusicAlbumName': query
    };
    this.load = true;
    this.addBlockUI();
    console.log(JSON.stringify(movieTextSearchbody));
    this._requisitionService.getMusicAlbumTextSearch(movieTextSearchbody).subscribe(response => {
      console.log("Text to search");
      console.log(response);
      this.load = false;
      this.removeBlockUI();
      this.filteredMoviesSingle = response.Music_Album;
      console.log(this.filteredMoviesSingle);
    }, error => { this.handleResponseError(error) })
  }
  filteredSingerList(singerData){
    let query = singerData.query;
    let singerTextSearchbody = {
      'RoleCode':13,
      'strSearch': query
    };
    
    console.log(JSON.stringify(singerTextSearchbody));
    this._requisitionService.getTalents(singerTextSearchbody).subscribe(response => {
      console.log("Singer Text to search");
      console.log(response);
      this.singerList = response.Talents;
      console.log(this.singerList);
    }, error => { this.handleResponseError(error) })
  }
  filteredStartCastList(starCastData){
    let query = starCastData.query;
    let singerTextSearchbody = {
      'RoleCode':2,
      'strSearch': query
    };
    
    console.log(JSON.stringify(singerTextSearchbody));
    this._requisitionService.getTalents(singerTextSearchbody).subscribe(response => {
      console.log("Singer Text to search");
      console.log(response);
      this.startCastList = response.Talents;
      console.log(this.startCastList);
    }, error => { this.handleResponseError(error) })
  }
  breadCrumbChangeClick(text) {
    this.breadcrumbtext = text;
  }
  public rowMusicCount=0;
  public rowMovieAlbumCount=0;
  addRowMusic() {
    // this.tablMusicList=[];
    debugger;
    if (parseInt(this.noOfRowMusic) == 0) {
      // alert("Row should be greater than 0")
      this.msgs.push({ severity: 'error', summary: '', detail: 'Row should be greater than 0' });
    }
    else {

      for (let i = 0; i < this.noOfRowMusic; i++) {
        let musicRow = {
          'Srno': this.rowMusicCount + 1,
          'MusicTrackName': '',
          'MusicLabelCode': '',
          'MovieAlbumCode': '',
          'Singers':'',
          'StarCasts':''

        }
        this.tablMusicList.push(musicRow);
        this.rowMusicCount=this.rowMusicCount+1;
        console.log(this.rowMusicCount);
        console.log(JSON.stringify(this.tablMusicList));
      }
      // alert(this.tablMusicList.length);
      // alert(JSON.stringify(this.tablMusicList));
    }
    this.noOfRowMusic = "1";
  }
  addRowAlbum() {

    if (parseInt(this.noOfRowAlbm) == 0) {
      this.msgs.push({ severity: 'error', summary: '', detail: 'Row should be greater than 0' });

    }
    else {
      for (let i = 0; i < this.noOfRowAlbm; i++) {
        let movieAlbumRow = {

          'Srno': this.rowMovieAlbumCount + 1,
          'TitleName': '',
          'MovieAlbum': 'M',
          // 'movieName': ''

        }
        this.tablMovieAlbumList.push(movieAlbumRow);
        this.rowMovieAlbumCount=this.rowMovieAlbumCount+1;
      }
    }
    this.noOfRowAlbm = "1";
  }
  newCreateMusic() {
    this.msgs = [];
    this.tablMusicList = [];
    this.saveMusicBody.Remarks = '';
    this.saveMusicBody.MHRequestDetails = [];
    this.textRemarkCount = 0;
    this.noOfRowMusic = "1";
    this.rowMusicCount=0;
    this.display = true;
    
    $( document ).tooltip({ items: ":not(.ui-dialog *)" });
    
    let musicRow = {
      'Srno': this.rowMusicCount + 1,
      'MusicTrackName': null,
      'MusicLabelCode': null,
      'MovieAlbumCode': null,
      'Singers':null,
      'StarCasts':null

    }
    this.tablMusicList.push(musicRow);
    this.rowMusicCount=this.rowMusicCount+1;
  }
  newCreateAlbum() {
    this.msgs = [];
    this.tablMovieAlbumList = [];
    this.saveMovieAlbumBody.Remarks = '';
    this.saveMovieAlbumBody.MHRequestDetails = [];
    this.noOfRowAlbm = "1";
    this.movieAlbumRemarkCount = 0;
    this.rowMovieAlbumCount=0;
    this.displayAlbum = true;
    $( document ).tooltip({ items: ":not(.ui-dialog *)" });
    
    let movieAlbumRow = {
      // 'srno': this.movieAlbumList.length + 1,
      'TitleName': '',
      'MovieAlbum': 'M',
      // 'movieName': ''

    }
    this.tablMovieAlbumList.push(movieAlbumRow);
  }
  removeMusicItem(row) {
    console.log(JSON.stringify(row));
    debugger;
    if (this.tablMusicList.length != 1) {
      // this.tablMusicList.splice(index, 1);
      console.log(this.tablMusicList);
      this.tablMusicList = this.tablMusicList.filter(x => x.Srno != row.Srno);
      console.log(this.tablMusicList);
      this.musicRemarkChange();
    }
  }
  removeAlbumItem(index) {
    // alert(JSON.stringify(index));
    if (this.tablMovieAlbumList.length != 1) {
      // this.tablMovieAlbumList.splice(index, 1);
      this.tablMovieAlbumList = this.tablMovieAlbumList.filter(x => x.Srno != index.Srno);
    }
    this.movieAlbumRemarkChange();
  }
  public validateMusicRemark: boolean = true;
  public validateAlbumRemark: boolean = true;
  public muaicTrckValCondtn: boolean = false;
  public movieAlbumValCondtn: boolean = false;
  
  musicTrackChange(muaicTrckValue) {

    // if (muaicTrckValue.trim().length == 0) {

    //   this.validateMusicRemark = true;
    //   this.muaicTrckValCondtn = true;
    //   // this.textRemarkCount = this.saveMusicBody.Remarks.length;
    // }
    // else {
    //   this.validateMusicRemark = false;
    //   this.muaicTrckValCondtn = false;
    // }
    this.musicRemarkChange();
  }
  musicRemarkChange() {
    // alert(this.saveMusicBody.Remarks.trim().length)

    if (this.saveMusicBody.Remarks.trim().length == 0) {
      this.saveMusicBody.Remarks = '';
      this.validateMusicRemark = true;
      // this.textRemarkCount = this.saveMusicBody.Remarks.length;
    }
    else {
      for(let i=0;i<this.tablMusicList.length;i++){
        
        if(i==0){
          this.tablMusicList[i].MusicTrackName.trim().length==0?this.validateMusicRemark=true:this.validateMusicRemark=false;

        }
        else{
          if(this.validateMusicRemark==false){
            this.tablMusicList[i].MusicTrackName.trim().length==0?this.validateMusicRemark=true:this.validateMusicRemark=false;
          }
        }
      }
      // if (this.muaicTrckValCondtn == true) {
      //   this.validateMusicRemark = true;
      // }
      // else {
      //   this.validateMusicRemark = false;
      // }
    }
    // this.saveMusicBody.Remarks.trim().length==0?this.saveMusicBody.Remarks=null:this.saveMusicBody.Remarks=this.saveMusicBody.Remarks;
    this.textRemarkCount = this.saveMusicBody.Remarks.trim().length;
  }
  movieAlbumChange(movieAlbumValue) {
    // if (movieAlbumValue.trim().length == 0) {

    //   this.validateAlbumRemark = true;
    //   this.movieAlbumValCondtn = true;
    // }
    // else {
    //   this.validateAlbumRemark = false;
    //   this.movieAlbumValCondtn = false;
    // }
    this.movieAlbumRemarkChange();
  }
  movieAlbumRemarkChange() {
    if (this.saveMovieAlbumBody.Remarks.trim().length == 0) {
      this.saveMovieAlbumBody.Remarks = '';
      this.validateAlbumRemark = true;
    }
    else {
      for(let i=0;i<this.tablMovieAlbumList.length;i++){
        
        if(i==0){
          this.tablMovieAlbumList[i].TitleName.trim().length==0?this.validateAlbumRemark=true:this.validateAlbumRemark=false;

        }
        else{
          if(this.validateAlbumRemark==false){
            this.tablMovieAlbumList[i].TitleName.trim().length==0?this.validateAlbumRemark=true:this.validateAlbumRemark=false;
          }
        }
      }
    }
    this.movieAlbumRemarkCount = this.saveMovieAlbumBody.Remarks.trim().length;
  }

  public displayalertMessage:boolean=false;
  public messageData: any;
  validateData(){
    var count=0;
    var list=[]
    console.log(this.tablMusicList);
    this.tablMusicList.forEach((item,index)=>{
      if(item.MovieAlbumCode.Music_Album_Code==null){
        this.tablMusicList[index].MovieAlbumCode='';
        list.push({id:"#MusicTrackName"+item.Srno});
        // this.validateMusicRemark = true;
        // this.saveMusicBody.Remarks='';
        // this.textRemarkCount=this.saveMusicBody.Remarks.length;
        console.log("counting");
        count=1;
    }
  else{
    if(count !=1){
      console.log("counting");
      // this.validateMusicRemark = false;
    }
    
  }})
  if(count==1){
    console.log(list);
    $(list[0].id).focus();
    
  console.log("counting 1");
    return false;
  }
  else{
  console.log("counting =0");
  return true;
  }
  }
// show(data){
//   console.log("Focus Data...!!");
//   console.log(data);
//   if(data==null){
//     return true;
//   }
// }
  submitMusicClick() {
    this.msgs = [];
    var SingersListData=[];
    var StarCastData=[];
    console.log(this.tablMusicList);
    
    if (this.tablMusicList.length == 0) {

      this.msgs.push({ severity: 'error', summary: '', detail: "At Least One Record should be Enter" });

    }

    else {
      
      // if(this.validateData()){
        console.log(JSON.stringify(this.saveMusicBody));
        for(let i=0;i<this.tablMusicList.length;i++){
          // console.log("Singer data");
          // console.log(this.tablMusicList[i].Singers.length);
          if(this.tablMusicList[i].Singers==null){
            SingersListData.push(null);
          }
          else{
            var List=[];
            for(let j=0;j<this.tablMusicList[i].Singers.length;j++){
              List.push(this.tablMusicList[i].Singers[j].TalentCode);
            }
            SingersListData.push(List.toString());
          }
        }
        for(let i=0;i<this.tablMusicList.length;i++){
          // console.log("Singer data");
          // console.log(this.tablMusicList[i].Singers.length);
          if(this.tablMusicList[i].StarCasts==null){
            StarCastData.push(null);
          }
          else{
            var List=[];
            for(let j=0;j<this.tablMusicList[i].StarCasts.length;j++){
              List.push(this.tablMusicList[i].StarCasts[j].TalentCode);
            }
            StarCastData.push(List.toString());
          }
        }
        console.log(SingersListData);
        console.log(StarCastData);
        var finalList=[];
        for(let k=0;k<this.tablMusicList.length;k++){
          
          let body={
            'MusicTrackName': this.tablMusicList[k].MusicTrackName,
        'MusicLabelCode': this.tablMusicList[k].MusicLabelCode,
        'MovieAlbumCode': this.tablMusicList[k].MovieAlbumCode,
        'Singers':SingersListData[k]==null?"":SingersListData[k].toString(),
        'StarCasts':StarCastData[k]==null?"":StarCastData[k].toString()
          }
          finalList.push(body);
        }
  
        this.saveMusicBody.MHRequestDetails = finalList;
        
        
        this.saveMusicBody.MHRequestDetails.forEach(x => (x.MusicLabelCode = x.MusicLabelCode==null?'': x.MusicLabelCode.MusicLabelCode));
        this.saveMusicBody.MHRequestDetails.forEach(x => (x.MovieAlbumCode = x.MovieAlbumCode==null?'': x.MovieAlbumCode.Music_Album_Code) );
        console.log("once again");
      
      

      console.log("Final List");
        console.log(JSON.stringify(this.saveMusicBody));
       
        this.load = true;
        this.addBlockUI();
        this._requisitionService.saveMusicRequest(this.saveMusicBody).subscribe(response => {
          this.load = false;
          this.removeBlockUI();
          this.tablMusicList = [];
          this.saveMusicBody.Remarks = '';
          this.saveMusicBody.MHRequestDetails = [];
          console.log("Save Sucessfully..!!!");
          console.log(response);
          this.musicResponse = response;
          // $('#musicModal').modal('hide');
          this.display = false;
          // this.displayFinal = true;
          // $('#submitModal').modal('show');
          this.requestMusicListMethod();
          if (this.musicResponse.Return.IsSuccess) {
            this.displayalertMessage=true;
            this.messageData={
              'header':"Message",
              'body':"Request ID " + this.musicResponse.RequestID + " sent for approval."
            }
            // this.submitHeader = "Success  Message";
            // this.submitMessage = "Request Id " + this.musicResponse.RequestID + " sent for approval.";
          }
          else {
            this.displayalertMessage=true;
            this.messageData={
              'header':"Error",
              'body':this.musicResponse.Return.Message
            }
            // this.submitHeader = "Error  Message";
            // this.submitMessage = this.musicResponse.Return.Message
          }
        }, error => { this.handleResponseError(error) }
        );
      // }   
      }
      // else{
      //   this.displayalertMessage=true;
      //   this.messageData = {
      //     'header': "Message",
      //     'body': "Select Movie/ Album Name from List...!"
      //   }

      // }
     
  }

  submitAlbumClick() {
    this.msgs1 = [];
    if (this.tablMovieAlbumList.length == 0) {
      // alert(this.tablMovieAlbumList);
      this.msgs1.push({ severity: 'error', summary: '', detail: "At Least One Record should be Enter" });

    }
    else {
      this.saveMovieAlbumBody.MHRequestDetails = this.tablMovieAlbumList;

      console.log("Welcome::" + JSON.stringify(this.saveMovieAlbumBody));
      this.load = true;
      this.addBlockUI();
      this._requisitionService.saveAlbumRequest(this.saveMovieAlbumBody).subscribe(response => {
        // console.log(response);
        this.load = false;
        this.removeBlockUI();
        this.saveMovieAlbumBody.Remarks = '';
        this.saveMovieAlbumBody.MHRequestDetails = [];
        this.tablMovieAlbumList = [];
        this.albumResponse = response;

        // $('#albumModal').modal('hide');
        this.displayAlbum = false;
        
        // $('#submitModal').modal('show');

        this.requestAlbumListMethod();
        if (this.albumResponse.Return.IsSuccess) {
          this.displayalertMessage=true;
          this.messageData={
            'header':"Message",
            'body':"Request ID " + this.albumResponse.RequestID + " sent for approval."
          }
          
          // this.msgs1.push({severity:'success', summary:'Success  Message', detail:this.albumResponse.Return.Message + this.albumResponse.Show});
        }
        else {
          this.displayalertMessage=true;
          this.messageData={
            'header':"Error",
            'body':this.albumResponse.Return.Message
          }
          // this.submitHeader = "Error  Message";
          // this.submitMessage = this.albumResponse.Return.Message
          // this.msgs1.push({severity:'error', summary:'Error Message', detail:this.albumResponse.Return.Message});
        }


      }, error => { this.handleResponseError(error) })
    }


  }
public totalMusicDetailCount=0;
public totalAlbumDetailCount=0;
public searchMusicDetail;
public musicDetailFilterList:any;
public albumDetailFilterList:any;
public searchAlbumDetail:any;
  musicRequestDetail(musicRequestedDetail: any) {
    debugger;
    this.musicReuestHeader = "Music Detail for : "+musicRequestedDetail.RequestID;
    this.dialogRequestDetail = true;
    this.searchMusicDetail=null;
    this.isMusicDetail = true;
    this.isAlbumDetail = false;
    // alert(JSON.stringify(musicRequestedDetail));
    let body = {
      'MHRequestCode': musicRequestedDetail.RequestCode
    }
    this.load = true;
    this.addBlockUI();
    this._requisitionService.GetMusicTrackRequestDetails(body).subscribe(response => {
      console.log("Music Request List");
      console.log(response);
      this.load = false;
      this.removeBlockUI();
      this.musicDetailList = response.RequestDetails;
      this.musicDetailFilterList=response.RequestDetails
      this.totalMusicDetailCount=response.RequestDetails.length;
    }, error => { this.handleResponseError(error) })
  }
  albumRequestDetail(albumRequestedDetail: any) {
    this.isMusicDetail = false;
    this.isAlbumDetail = true;
    this.searchAlbumDetail=null;
    this.musicReuestHeader = "Movie / Album Detail for : "+albumRequestedDetail.RequestID;
    this.dialogRequestDetail = true;
    let body = {
      'MHRequestCode': albumRequestedDetail.RequestCode
    }
    this.load = true;
    this.addBlockUI();
    this._requisitionService.GetMovieAlbumRequestDetails(body).subscribe(response => {
      console.log("Music Request List");
      console.log(response);
      this.load = false;
      this.removeBlockUI();
      this.albumDetailList = response.RequestDetails;
      this.albumDetailFilterList=response.RequestDetails;
      this.totalAlbumDetailCount=response.RequestDetails.length;

    }, error => { this.handleResponseError(error) })

  }



  Done() {
    // $('#submitModal').modal('hide');
    // window.location.reload();
    this.displayFinal = false;
  }
  close() {
    this.dialogRequestDetail = false;
  }
  addBlockUI() {
    $('body').addClass("overlay");
    $('body').on("keydown keypress keyup", false);
  }
  removeBlockUI() {
    $('body').removeClass("overlay");
    $('body').off("keydown keypress keyup", false);
  }

  exportToExcel(value){
    this.load = true;
    this.addBlockUI();
    var exportMovieAlbumMusicBody={
      MHRequestTypeCode:value
    }
   console.log(exportMovieAlbumMusicBody);
    this._requisitionService.getExportMovieAlbumMusicList(exportMovieAlbumMusicBody).subscribe(response => {
      this.load = false;
      this.removeBlockUI();
  console.log("Export Response");
  console.log(response);
  this.Download(response.Return.Message)
  // this.recordCount=response.RecordCount
  //     this.requestList = response.RequestList;
  //     console.log(this.requestList);
    }, error => { this.handleResponseError(error) });
  }
  Download(b) {
     debugger; 
     window.location.href = (this._requisitionService.DownloadFile().toString() + b).toString(); }

     handleResponseError(errorCode) {    
      if (errorCode == 403 ) {
        this.load = false;
      this.removeBlockUI();
      sessionStorage.clear();
      localStorage.clear();
        this.router.navigate(['/login']);
      }
    }
}
