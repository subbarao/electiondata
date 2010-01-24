google.load("visualization", "1", {
  packages: ["piechart", "barchart", "table"]
});

google.setOnLoadCallback(onLoadFunction);

MapCanvas = {
  visualizationDefaultOptions : {
    legend: "label",
    width: 400,
    height: 250,
    is3D: true
  },
  replaceYearSelectBox: function(currentCity) {
    $("#select_box").unbind().change(function(e) {
      MapCanvas.handleYearChange(currentCity,$(this).val());
    }).val("2004").trigger('change');
  },
  constructBar:function(barData,year){
    if(barData){
      var barJson = new google.visualization.DataTable(barData);
      var barChart = new google.visualization.BarChart(document.getElementById("chart_div"));
      barChart.draw(barJson, $.extend(MapCanvas.visualizationDefaultOptions, {
        title: year + " Votes Polled For Candidates"
      }));
    }
  },
  constructPie:function(pieData,year){
    if(pieData){
      var pieJson = new google.visualization.DataTable(pieData);
      var pieChart = new google.visualization.PieChart(document.getElementById("chart_div"));
      pieChart.draw(pieJson, $.extend(MapCanvas.visualizationDefaultOptions, {
        title: year + " Percentage Of Votes For Party"
      }));
    }
  },
  constructResult:function(infoYear){
    for (var property in infoYear ) {
      if ($("." + property)) {
        var value = infoYear[property];
        value = (/\d+/).exec("" + value) ? parseInt(value, 10) : value.toLowerCase();
        $("." + property).html(value);
      }
    }
  },
  handleYearChange: function(currentCity,year) {
    $('#chart_div').html("");
    MapCanvas.constructPie(currentCity.piecharts[year],year);
    MapCanvas.constructBar(currentCity.barcharts[year],year);
    MapCanvas.constructResult(currentCity.overview[year],year);
    $("#content").show();
  },
  init: function(map) {
    this.map = map;
  },
  handleJson: function(currentCity) {

    this.replaceYearSelectBox(currentCity);
    this.createMarker(new GLatLng(currentCity.info.lat, currentCity.info.lng),currentCity.info.name);


  },
  createMarker:function(latlng,markerName){
    this.map.clearOverlays();
    this.map.setCenter(latlng, 10);
    this.map.addOverlay(new GMarker(latlng));
    this.map.openInfoWindow(latlng, markerName);
    this.map.addControl(new GSmallMapControl());
    this.map.addControl(new GMapTypeControl());
  }
};

function onLoadFunction() {

  //initialize map and set center as the map integerested
  var map = new google.maps.Map2(document.getElementById("map"));
  map.setCenter(new GLatLng(17.0478, 80.0982), 7);
  map.addControl(new GSmallMapControl());

  MapCanvas.init(map);

  GEvent.addListener(MapCanvas.map, "click", function(overlay, latlng) {
    $.getJSON("/seats/nearest?lat=" + latlng.lat()+"&lng="+latlng.lng(), function(json) {
      MapCanvas.handleJson(json);
    });
    return false;
  });

  $("#search_box").change(function(e) {
    $.getJSON("/seats/" + $("#search_box").val(), function(json) {
      MapCanvas.handleJson(json);
    });
    return false;
  }).val(parseInt($("option").size() * Math.random(), 10)).trigger("change");

}
