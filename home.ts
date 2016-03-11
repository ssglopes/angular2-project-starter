import {Component, OnInit} from 'angular2/core';
import {FORM_DIRECTIVES} from 'angular2/common';
import {Alert, DATEPICKER_DIRECTIVES} from 'ng2-bootstrap/ng2-bootstrap';
import * as moment from 'moment'; // for dates in calender

@Component({
  selector: 'home',
  directives: [...FORM_DIRECTIVES, Alert, DATEPICKER_DIRECTIVES],
  pipes: [],
  styles: [require('./home.scss')],
  template: require('./home.html')
})

export class Home implements OnInit {
  public date:Date = new Date();

  constructor() {
    // Do stuff
  }

  ngOnInit() {
    console.log('Hello Home');
  }

  private today() {
    $("#hello").delay(10).text('Jquery WORKS');
    this.date = new Date();
  }
}

