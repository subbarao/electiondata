google.load("visualization", "1", {
  packages: ["piechart", "barchart", "table"]
});

google.setOnLoadCallback(onLoadFunction);

MapCanvas = {
  constructOptions: function(currentCity) {
    $("#select_box").unbind().show().html("");
    $.each([2004, 1999, 1994, 1989, 1985, 1983, 1978], function() {
      if (currentCity["" + this] != - 1) {
        $("#select_box").append("<option value='" + this + "'>" + this + "</option>");
      }
    });
  },
  constructBar:function(barData,year){
    if(barData){
      var barJson = new google.visualization.DataTable(barData);
      var barChart = new google.visualization.BarChart(document.getElementById("chart_div"));
      barChart.draw(barJson, jQuery.extend(MapCanvas.opt, {
        title: year + " Votes (Thousands)"
      }));
    }
  },
  constructPie:function(pieData,year){
    if(pieData){
      var pieJson = new google.visualization.DataTable(pieData);
      var pieChart = new google.visualization.PieChart(document.getElementById("chart_div"));
      pieChart.draw(pieJson, jQuery.extend(MapCanvas.opt, {
        title: year + " Percentage Votes"
      }));
    }
  },
  constructInfo:function(infoYear){
    for (var property in infoYear ) {
      if ($("." + property)) {
        var value = infoYear[property];
        value = (/\d+/).exec("" + value) ? parseInt(value, 10) : value.toLowerCase();
        $("." + property).html(value);
      }
    }
  },
  bindEvents: function(currentCity,year) {
    $('#chart_div').html("");
    MapCanvas.constructPie(currentCity.piecharts[year],year);
    MapCanvas.constructBar(currentCity.barcharts[year],year);
    MapCanvas.constructInfo(currentCity.overview[year],year);
    $("#content").show();
  },
  init: function(map) {
    this.opt = {
      legend: "label",
      width: 400,
      height: 250,
      is3D: true
    };
    this.map = map;
  },
  handleJson: function(currentCity) {
    GoogleMap.map.clearOverlays();
    MapCanvas.constructOptions(currentCity);
    $("#select_box").change(function(e) {
      MapCanvas.bindEvents(currentCity,$(this).val());
    }).trigger('change');
    //GoogleMap.moveToLatlng(new GLatLng(currentCity.core.lat, currentCity.core.lng),currentCity.core.name);
  },
  selectCity: function(latlng){
    $.getJSON("/seats/nearest?lat=" + latlng.lat()+"&lng="+latlng.lng(), function(json) {
      MapCanvas.handleJson(json);
    });
  },
  changeCity:function(){
    $.getJSON("/seats/" + $("#search_box").val(), function(json) {
      MapCanvas.handleJson(json);
    });
  }
};
GoogleMap={
  moveToLatlng:function(latlng,cityName){
    this.map.setCenter(latlng, 10);
    this.map.addOverlay(new GMarker(latlng));
    this.map.openInfoWindow(latlng, cityName);
    this.map.addControl(new GSmallMapControl());
    this.map.addControl(new GMapTypeControl());
  },
  init:function(){
    this.map = new google.maps.Map2(document.getElementById("map"));
    this.map.setCenter(new GLatLng(17.0478, 80.0982), 7);
    this.map.addControl(new GSmallMapControl());
    MapCanvas.init(this.map);
  },
  handleClick:function(latlng){
    $.getJSON("/constituencies/find", "lat=" + latlng.lat() + "&lng=" + latlng.lng(), function(jsonResponse) {
      var myHtml = jsonResponse.core.name;
      MapCanvas.handleJson(jsonResponse);
      GoogleMap.map.addOverlay(new GMarker(latlng));
      GoogleMap.map.openInfoWindow(latlng, myHtml);
      $("#select_box").val(jsonResponse.core.id);
    });
  }
};

function onLoadFunction() {
  GoogleMap.init();

  GEvent.addListener(GoogleMap.map, "click", function(overlay, latlng) {
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
