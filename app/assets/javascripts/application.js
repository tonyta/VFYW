// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(function() {

// SLIDERS

  // timeSlider.prototype = {
  //   initialize: function(cssSelector) {},
  //   convert12Hour: function(hour) {},
  //   getTimeStr: function(start, end) {}
  // }

  var getTime = function(hour) {
    if (hour === 0 || hour === 24) {
      return "12 am";
    } else if (hour === 12) {
      return "12 pm";
    } else if (hour > 11) {
      return (hour - 12) + " pm";
    } else {
      return hour + " am";
    }
  };

  var initialTimeRange = [8, 12];

  $( "#time-range" ).slider({
    range: true,
    min: 0,
    max: 24,
    values: initialTimeRange,
    slide: function( event, ui ) {
      $( "#time" ).text(getTime(ui.values[0]) + " to " + getTime(ui.values[1]));
    },
    stop: function( event, ui ) {
      console.log('stopped');
    }
  });

  $("#time").text(getTime(initialTimeRange[0]) +
    " to " + getTime(initialTimeRange[1]) );


// MAP

  var map = L.mapbox.map('map', 'tonyta.if74jkhj')
  map.setView([30,11], 2);

  window.map = map;

})