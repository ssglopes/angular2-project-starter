import {Component, OnInit} from 'angular2/core';
import {FORM_DIRECTIVES} from 'angular2/common';
import {DATEPICKER_DIRECTIVES} from 'ng2-bootstrap/ng2-bootstrap';
import * as moment from 'moment'; // for dates in calender


@Component({
  selector: 'home',
  directives: [...FORM_DIRECTIVES, DATEPICKER_DIRECTIVES],
  pipes: [],
  template: require('../../templates/home/home.html'),
  styles: [require('../../styles/home/home.scss')]
})

export class Home implements OnInit {
  public date:Date = new Date ();

  constructor() {
    // Do stuff
  }

  ngOnInit() {
    console.log('Hello Home');
  }

  public today() {
    $("#test-jquery").delay(10).text('Hello, world of Jquery!');
    this.date = new Date();
  }
}
