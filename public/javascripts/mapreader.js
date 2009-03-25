google.load("jquery", "1.3.2");
google.load("maps", "2");
google.load("visualization", "1", {packages:["piechart"]})
google.setOnLoadCallback(function() {
    $(function() {
    		ELECTION = {
      data : {},
      cities : [],
      init: function(jsonObj){
        for (var j=0 ; j < jsonObj.length ; j++) {
            var city_name = jsonObj[j].constituency.name
            var city = jsonObj[j].constituency;
            var current_id = jsonObj[j].constituency.id
            this.cities.push(city_name);
            this.data[city_name] = jsonObj[j];
    				var geocoder = new GClientGeocoder();
            ( function(inner_city){
              if(!inner_city.lang){
                geocoder.getLatLng( inner_city.name+",Andhra Pradesh", function(point) {
                if(!point){
//                  alert(inner_city.name + inner_city.id);
                } else {
                  $.post("/constituencies/"+(inner_city.id),"_method=put&lat="+point.lat()+"&lng="+point.lng(),function(){});
                }});
              }
            })(city);
        }
      }
    };
    $.getJSON("/constituencies",function(jsonObj) {
        ELECTION.init(jsonObj);
    }); 
});
});
