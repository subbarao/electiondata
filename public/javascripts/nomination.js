google.setOnLoadCallback(onLoadFunction);
function onLoadFunction(){
  var map = new google.maps.Map2(document.getElementById("map"));
  map.setCenter(new GLatLng(17.047762,80.098187), 8);
  map.addControl(new GLargeMapControl());
  map.addControl(new DragZoomControl());

  function addMarker(opt){
    var marker = new GMarker( new GLatLng(opt.lat,opt.lng) );
    GEvent.addListener(marker, 'click', function(){ 
        marker.openExtInfoWindow(
          map,
          "custom_info_window_red",
          "<div>Loading...</div>",
          {
            ajaxUrl: '/results/'+opt.id, 
            beakOffset: 3
          }
        ); 
      });
    map.addOverlay(marker);
  }

  $.getJSON("/results",function(responseObj){
      $.each(responseObj.seats,function(n,opt){
          addMarker(opt);
        });
    });

}

