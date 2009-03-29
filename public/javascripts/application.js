google.load("visualization", "1", {packages:["piechart","barchart","table"]});

google.setOnLoadCallback(onLoadFunction);

function onLoadFunction(){

  var map = new google.maps.Map2(document.getElementById("map"));
  map.setCenter(new GLatLng(17.0478, 80.0982), 7);
  map.addControl(new GSmallMapControl());

  GEvent.addListener(map,"click", function(overlay,latlng) {     
      $.getJSON("/constituencies/find" , "lat="+latlng.lat()+"&lng="+latlng.lng(),function(currentCity) {
          var myHtml = currentCity.core.name;
          handleJson(currentCity);
          map.addOverlay(new GMarker(latlng));
          map.openInfoWindow(latlng, myHtml);
          $("#select_box").val(currentCity.core.id);
        });
    });

  function handleJson(currentCity) {
    map.clearOverlays();
    var opt = {
      legend:"label",
      width:400,
      height:250,
      is3D:true
    };
    $("#select_box").unbind().show().html("");
    var years = [2004, 1999, 1994, 1989, 1985, 1983, 1978];
    jQuery.each(years, function(){
        if( currentCity.barchart[""+this] != -1 )
          $("#select_box").append("<option value='" + this + "'>" + this + "</option>");
      });
    $("#select_box").change(function(e) {
        var year = $(this).val();
        $('#chart_div').html("");
        $('#chart_div').fadeOut(1000, function () {
            $('#chart_div').fadeIn(1000);
          });
        var pieJson = new google.visualization.DataTable(currentCity.piechart[year]);
        var pieChart = new google.visualization.PieChart(document.getElementById("chart_div"));
        pieChart.draw(pieJson, jQuery.extend(opt, { title: year+" Percentage Votes" }));
        var barJson = new google.visualization.DataTable(currentCity.barchart[year]);
        var barChart = new google.visualization.BarChart(document.getElementById("chart_div"));
        barChart.draw(barJson, jQuery.extend(opt,{title: year+ " Votes (Thousands)"}));
        for( var property in currentCity.table[year]){
          if($("."+property)){
            var value = currentCity.table[year][property];
            value =  (/\d+/).exec(""+value)  ? parseInt(value,10) : value.toLowerCase() ; 
            $("."+property).html(value);
          }
        }
        $("#content").show();
      });
    $("#select_box").trigger('change'); 
  }
  jQuery("#search_box").change(function(e) {
      var id =jQuery("#search_box").val();
      $.getJSON("/constituencies/" + id,function(currentCity){
          var latlng = new GLatLng(currentCity.core.lat, currentCity.core.lng);
          var myHtml = currentCity.core.name;
          handleJson(currentCity);
          map.setCenter(latlng, 10);
          map.addOverlay(new GMarker(latlng));
          map.openInfoWindow(latlng, myHtml);
          map.addControl(new GSmallMapControl());
          map.addControl(new GMapTypeControl());
        });
      return false;
    });
  jQuery("#search_box").val(parseInt($("option").size()*Math.random(),10)).trigger("change");
}
