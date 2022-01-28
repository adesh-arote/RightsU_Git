import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

import { LABELS, MESSAGES } from 'src/app/shared/constant';

@Component({
  selector: 'app-menu',
  templateUrl: './menu.component.html',
  styleUrls: ['./menu.component.scss']
})
export class MenuComponent implements OnInit {

  showComponent: boolean = true;
  LABEL;
  MESSAGE;

  constructor(private readonly router: Router) {
    this.LABEL = LABELS;
    this.MESSAGE = MESSAGES;
  }

  ngOnInit(): void {
  }

  navigateToFeature(product: string) {
    if (product === 'search') {
      this.showComponent = true;
    } else {
      this.showComponent = false;
    }
  }

}
