google.load("visualization", "1", {packages:["piechart","barchart","table"]});
google.load("elements", "1", {packages: "transliteration"});
google.load("language", "1");
google.setOnLoadCallback(onLoadFunction);
function onLoadFunction(){
  map = new GMap2(document.getElementById("map"));
  map.setCenter(new GLatLng(17.047762,80.098187), 9);
  map.addControl(new GLargeMapControl());
  map.addControl(new DragZoomControl({},{ 
        buttonHTML: "దగ్గరగా చూడు ", 
        buttonZoomingHTML: "దూరంగా చూడు" ,
        backButtonStyle: {display:"none",top:"93px",background:"#FFFFC8"}
      }));
  var options = {
    sourceLanguage:
    google.elements.transliteration.LanguageCode.ENGLISH,
    destinationLanguage:
    [google.elements.transliteration.LanguageCode.TELUGU],
    shortcutKey: 'ctrl+g',
    transliterationEnabled: true
  };


  function addMarker(opt){
    var marker = new GMarker( new GLatLng(opt.lat,opt.lng) );
    GEvent.addListener(marker, 'click', function(){ 
        google.language.transliterate([opt.name], "en", "te", 
          function(result) {
            marker.openExtInfoWindow(
              map,
              "custom_info_window_red",
 result.transliterations[0].transliteratedWords[0],             
              {beakOffset: 3}
            ); 
          });
      });
    map.addOverlay(marker);
  }
  $.getJSON("/results",function(responseObj){
      $.each(responseObj,function(n,opt){
          addMarker(opt.constituency);
        });
    });
}
