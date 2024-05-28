import { Component } from '@angular/core';



@Component({
  selector: 'app-root',
  template: '<router-outlet></router-outlet>'
})

export class AppComponent {
}

@Component({
  selector: 'app-frame',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],

})
// declare var $: any;

export class AppFrameComponent {

  title = 'app';
  public VersionNo: any;
  public lastModified: any;
  // constructor(){
  // $( "body" ).removeClass( "fixed" );
  // alert("app component");
  // $( "body" ).addClass( "fixed" );
  // $( "body" ).toggleClass( "fixed" );
  // var a = $("body").attr('class');
  // alert(a);
  // }

  constructor() {
    this.VersionNo = localStorage.getItem('SYSTEM_VERSION');
    this.lastModified = localStorage.getItem('LAST_MODIFIED');
  }

}
