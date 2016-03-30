import {Component, OnInit} from 'angular2/core';

@Component({
  selector: 'about',
  template: require('../../templates/about/about.html'),
  styles: [require('../../styles/about/about.scss')],
  providers: [],
  directives: [],
  pipes: []
})
export class About implements OnInit {

  constructor() {
    // Do stuff
  }

  ngOnInit() {
    console.log('Hello About');
  }

}
