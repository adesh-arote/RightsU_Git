import {Directive,Input} from '@angular/core'

@Directive({
    selector: '[var]',
    exportAs: 'var'
  })
  export class VarDirective {
    @Input() var:any;
    constructor(){
        console.log("This Is directives...!")
        console.log(this.var)

    }
  }