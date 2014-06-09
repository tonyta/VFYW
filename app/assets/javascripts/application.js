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

// var geojson = [
//   {"type":"Feature","geometry":{"type":"Point","coordinates":["100.258333","19.833333"]},"properties":{"id": 123, "title":"Khuntan, Thailand","description":"Khuntan, Thailand, 6 pm","marker-color":"#fc4353","marker-size":"small"}},
//   {"type":"Feature","geometry":{"type":"Point","coordinates":["-73.507061","43.639232"]},"properties":{"id": 456, "title":"Hulett’s Landing, New York","description":"Hulett’s Landing, New York, 5 pm","marker-color":"#fc4353","marker-size":"small"}},
//   {"type":"Feature","geometry":{"type":"Point","coordinates":["-124.318632","49.321623"]},"properties":{"id": 789, "title":"Parksville, British Columbia","description":"Parksville, British Columbia, 6.57 am","marker-color":"#fc4353","marker-size":"small"}}
// ];


$(function() {

// MAP

  var map = L.mapbox.map('map', 'tonyta.if74jkhj')
    .setView([30,11], 2)

  var markers = map.featureLayer

  markers.on('click', function(s) {
    console.log(s.layer.feature);
  });

  var markerCtrl = {
    timeRange: [8, 12],
    dateRange: [Date.now() - 31556900000, Date.now()],
    filtered: null,
    filterTimeDate: function() {
      this.filtered = window.geojson;
      this.filterTime();
      this.filterDate();

      map.featureLayer.setGeoJSON(this.filtered);
    },
    filterTime: function() {
      var start = this.timeRange[0];
      var end = this.timeRange[1];
      this.filtered = this.filtered.filter(function(feature) {
        var time = feature.properties.time;
        if (end === 24 && time == 0) {
          return true;
        } else {
          return time >= start && time <= end;
        }
      });
    },
    filterDate: function() {
      var start = this.dateRange[0];
      var end = this.dateRange[1];
      this.filtered = this.filtered.filter(function(feature) {
        var date = feature.properties.date;
        return date >= start && date <= end;
      });
    }
  };

  window.map = map;

// SLIDERS

  var timeUtilities = {
    initialRange: [8, 12],
    get12Hour: function(hour) {
      if (hour === 0 || hour === 24) {
        return "midnight";
      } else if (hour === 12) {
        return "noon";
      } else if (hour > 11) {
        return (hour - 12) + " pm";
      } else {
        return hour + " am";
      }
    },
    getTimeStr: function(range) {
      range = range || this.initialRange;
      return this.get12Hour(range[0]) + " to " + this.get12Hour(range[1]);
    }
  }

  $( "#time-range" ).slider({
    range: true,
    min: 0,
    max: 24,
    values: timeUtilities.initialRange,
    slide: function( event, ui ) {
      $( "#time" ).text(timeUtilities.getTimeStr(ui.values));
    },
    stop: function( event, ui ) {
      markerCtrl.timeRange = ui.values;
      markerCtrl.filterTimeDate();
    }
  });

  var dateUtilities = {
    initialRange: [Date.now() - 31556900000, Date.now()],
    formatDate: function(msecs) {
      return new Date(msecs).toLocaleDateString('en-US', {
        month: 'long',
        day: 'numeric',
        year: 'numeric'
      })
    },
    getDateStr: function(range) {
      range = range || this.initialRange;
      return this.formatDate(range[0]) + " to " + this.formatDate(range[1]);
    }
  }

  $( "#date-range" ).slider({
    range: true,
    min: 1148336220000,
    max: Date.now(),
    values: dateUtilities.initialRange,
    slide: function( event, ui ) {
      $( "#date" ).text(dateUtilities.getDateStr(ui.values));
    },
    stop: function( event, ui ) {
      markerCtrl.dateRange = ui.values;
      markerCtrl.filterTimeDate();    }
  });


  markerCtrl.filterTimeDate();

  $("#time").text(timeUtilities.getTimeStr());
  $("#date").text(dateUtilities.getDateStr());

})