google.load("jquery", "1.3.2");
google.load("maps", "2");
google.load("visualization", "1", {packages:["piechart","barchart","table"]});

google.setOnLoadCallback(onLoadFunction);

function onLoadFunction(){

  $("#container").ajaxStart(function(){
      $(this).slideUp('slow');
    }).ajaxComplete(function(){
        $(this).slideDown('fast');
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
      $.getJSON("/constituencies/" + city, function(currentCity) {
          var opt = {
            legend:"label",
            width:400,
            height:300,
            is3D:true
          };
          $('#city_name').html("<h3>"+currentCity.core.name+" Results</h3>");
          map.setCenter(new GLatLng(currentCity.core.lat, currentCity.core.lng), 10);
          map.addControl(new GSmallMapControl());
          map.addControl(new GMapTypeControl());
          map.clearOverlays();
          markCities(currentCity.near);
          $("#select_box").unbind().show().html("");
          var years = [2004, 1999, 1994, 1989, 1985, 1983, 1978];
          jQuery.each(years, function(){
              if( currentCity.barchart[""+this] != -1 )
                $("#select_box").append("<option value='" + this + "'>" + this + "</option>");
            });
          $("#select_box").change(function(e) {
              var year = $(this).val();
              $('#chart_div').html("");
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
        });
    }
    jQuery("#search_box").change(function(e) {
        redrawCity(jQuery("#search_box").val());
        return false;
      });
    jQuery("#search_box").val(parseInt($("option").size()*Math.random(),10)).trigger("change");
  }
