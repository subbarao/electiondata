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
    $("#year_select_box").unbind().change(function(e) {
      MapCanvas.handleYearChange(currentCity,$(this).val());
    }).val("2004").trigger('change');
  },
  constructBar:function(barData,year){
    if(barData){
      var barJson = new google.visualization.DataTable(barData);
      var barChart = new google.visualization.BarChart(document.getElementById("barchart"));
      barChart.draw(barJson, $.extend(MapCanvas.visualizationDefaultOptions, {
        title: year + " Votes Polled For Candidates (Thousands)"
      }));
    }
    else{
      $("#barchart").html("Data Is Not Available");
    }
  },
  constructPie:function(pieData,year){
    if(pieData){
      var pieJson = new google.visualization.DataTable(pieData);
      var pieChart = new google.visualization.PieChart(document.getElementById("piechart"));
      pieChart.draw(pieJson, $.extend(MapCanvas.visualizationDefaultOptions, {
        title: year + " Percentage Of Votes For Party"
      }));
    }
    else{
      $("#piechart").html("Data Is Not Available");
    }
  },
  constructResult:function(result){
    $(".winner").html(result["winner"]+" (won)");
    $(".defeated").html(result["defeated"]+" (lost)");
    //$(".total_votes").html(result["total_votes"]+" (votes polled)");
    //$(".margin").html(result["margin"]+" (margin)");
  },
  handleYearChange: function(currentCity,year) {
    $('#barchart,#piechart').html("");
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

  $("#city_select_box").change(function(e) {
    $.getJSON("/seats/" + $("#city_select_box").val(), function(json) {
      MapCanvas.handleJson(json);
    });
    return false;
  }).val(parseInt($("option").size() * Math.random(), 10)).trigger("change");

}
