google.load("jquery", "1.3.2");
google.load("maps", "2");
google.load("visualization", "1", {packages:["piechart","barchart","table"]});

google.setOnLoadCallback(onLoadFunction);

function onLoadFunction(){

  $("#container").ajaxStart(function(){
      $(this).hide('slow');
    }).ajaxComplete(function(){
        $(this).show('slow');
      });



    var map = new google.maps.Map2(document.getElementById("map"));
    map.setCenter(new GLatLng(17.0478, 80.0982), 7);
    map.addControl(new GSmallMapControl());
    function  markCities(nearCities) {
      for (var i = 0; i < nearCities.length; i++) {
        (
          function(markedCity) {
            var point = new GLatLng(markedCity.lat, markedCity.lng);
            var marker = new GMarker(point);
            map.addOverlay(marker);
            GEvent.addListener(marker, 'click', function() {
                redrawCity(markedCity.id);
                marker.openInfoWindowHtml(markedCity.name);
              });
          }) (nearCities[i]);
      }
    }

    function redrawCity(city) {
      $.getJSON("/constituencies/" + city, function(jsonObj) {
          var opt = {
            legend:"label",
            width:300,
            height:200
          };
          var info = jsonObj.map;
          var near = jsonObj.near;
          $('#city_name').html("<h3>"+info.name+" Results</h3>");
          map.setCenter(new GLatLng(info.lat, info.lng), 10);
          map.addControl(new GSmallMapControl());
          map.addControl(new GMapTypeControl());
          map.clearOverlays();
          markCities(near);
          var piedata = jsonObj.piedata;
          var barchart_by_year = jsonObj.barchart_by_year;
          var barchart = jsonObj.barchart;
          var table = jsonObj.table;
          $("#select_box").unbind().show().html("");
          var years = [2004, 1999, 1994, 1989, 1985, 1983, 1978];
          jQuery.each(years, function(){
              if( barchart_by_year[""+this] != -1 )
                $("#select_box").append("<option value='" + this + "'>" + this + "</option>");
            });
          $("#select_box").change(function(e) {
              var year = $(this).val();
              $('#chart_div').html("");
              var data = piedata[year];
              var table = new google.visualization.DataTable(data);
              var chart = new google.visualization.PieChart(document.getElementById("chart_div"));
              chart.draw(table, jQuery.extend(opt, { title: year }));
              var year_bar_chart = new google.visualization.DataTable(barchart_by_year[year]);
              var barchartBar = new google.visualization.BarChart(document.getElementById("chart_div"));
              barchartBar.draw(year_bar_chart, jQuery.extend(opt,{label: "none"}));
            });
          $("#select_box").trigger('change'); 

        });
    }
    jQuery("#search_box").change(function(e) {
        redrawCity(jQuery("#search_box").val());
        return false;
      });
    jQuery("#search_box").val(parseInt($("option").size()*Math.random(),10)).trigger("change");
  }
