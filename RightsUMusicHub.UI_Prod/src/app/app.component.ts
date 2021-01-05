import { Component } from '@angular/core';



@Component({
  selector: 'app-root',
  template: '<router-outlet></router-outlet>'
})

export class AppComponent{
}

@Component({
  selector: 'app-frame',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  
})
// declare var $: any;

export class AppFrameComponent {

  title = 'app';
// constructor(){
  // $( "body" ).removeClass( "fixed" );
  // alert("app component");
  // $( "body" ).addClass( "fixed" );
  // $( "body" ).toggleClass( "fixed" );
  // var a = $("body").attr('class');
  // alert(a);
// }

  
}
