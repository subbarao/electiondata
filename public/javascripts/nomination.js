google.setOnLoadCallback(onLoadFunction);

function onLoadFunction(){

  var greenIcon = new GIcon();
  greenIcon.shadow = '/images/mm_20_shadow.png';
  greenIcon.iconSize = new GSize(12, 20);
  greenIcon.shadowSize = new GSize(22, 20);
  greenIcon.iconAnchor = new GPoint(6, 20);
  greenIcon.infoWindowAnchor = new GPoint(5, 1);
  greenIcon.image = '/images/mm_20_green.png';

  var map = new google.maps.Map2(document.getElementById("map"));
  map.setCenter(new GLatLng(17.047762,80.098187), 7);

  map.addControl(
    new TextualZoomControl(),
    new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(7,7)));
  map.enableContinuousZoom();

  var otherOpts = { 
    buttonStartingStyle: {display:"block",color:"black",background:"white",width:"7em",textAlign:"center",
      fontFamily:"Verdana",fontSize:"12px",fontWeight:"bold",border:"1px solid gray",paddingBottom:"1px",cursor:"pointer"},
    buttonHTML: "Drag Zoom",
    buttonZoomingHTML: 'Drag a region on the map (click here to reset)',
    buttonZoomingStyle: {background:"yellow"},
    backButtonHTML: "Drag Zoom Back",  
    backButtonStyle: {display:"none",marginTop:"3px",background:"#FFFFC8"},
    backButtonEnabled: true} ;

  map.addControl(new DragZoomControl({}, otherOpts, {}), new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(7,39)));






  function addMarker(opt){
    var marker = new GMarker( new GLatLng(opt.lat,opt.lng),greenIcon);
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

