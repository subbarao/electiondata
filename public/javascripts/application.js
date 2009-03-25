google.load("jquery", "1.3.2");
google.load("maps", "2");
google.load("visualization", "1", {
    packages: ["piechart","table"]
})
google.load("elements", "1", {packages : ["newsshow"]});
google.setOnLoadCallback(function() {

    var map = new google.maps.Map2(document.getElementById("map"));
    map.setCenter(new GLatLng(17.0478, 80.0982), 7);
    map.addControl(new GSmallMapControl());
    $(function() {
var options = {
    "queryList" : [
			{
				"title": "Andrha Election News",
					"ned": "te_in",
					"q":"chiranjeevi",
 					"rsz" : "small"
			},

			{
				"title": "Andrha Election News",
					"ned": "te_in",
					"q":"BalaKrishna",
 					"rsz" : "small"
			},

			{
				"title": "Andrha Election News",
					"ned": "te_in",
					"q":"Jr.N.T.R",
 					"rsz" : "small"
			},
			{
				"title": "Andrha Election News",
					"ned": "te_in",
					"q":"Chandra Babu Naidu",
 					"rsz" : "small"
			},
		],
		 "displayTime" : 2000,
		 "transitionTime" : 200, 
		 "format" : "728x90"			
  }
  var content = document.getElementById('content');
  var newsShow = new google.elements.NewsShow(content, options);

        ELECTION = {
            data: {},
            cities: [],
            init: function(jsonObj) {
                for (var j = 0; j < jsonObj.length; j++) {
                    var city_name = jsonObj[j].constituency.name
                    this.cities.push(city_name);
                    this.data[city_name] = jsonObj[j].constituency.id;
                    (
                    function(city) {
                        var point = new GLatLng(city.lat, city.lng);
                        var marker = new GMarker(point);
                        map.addOverlay(marker);
                        GEvent.addListener(marker, 'click',
                        function() {
                            redrawCity(city.id);
                            marker.openInfoWindowHtml("<b>" + city.name + "</b>");
                        });
                    }
                    )(jsonObj[j].constituency);

                }

                jQuery("#search_box").autocomplete(ELECTION.cities);
            }
        };

        $.getJSON("/constituencies",
        function(jsonObj) {
            ELECTION.init(jsonObj);
            startInit();
            var city =  ELECTION.data["Vijayawada East"];
            redrawCity(city);
        });
        function redrawCity(city) {
            $.getJSON("/constituencies/" + city,
            function(jsonObj) {
                var opt = {
                    legend: "label",
                    width: 300,
                    height: 200
                };
                $('#chart_div').html("");
                //var years = ["2004", "1999", "1994", "1989", "1985", "1983", "1978"];
                var years = ["2004"];
                var info = jsonObj.map;
                var piedata = jsonObj.piedata;
                var table = jsonObj.table;
                for (var x = 0; x < years.length; x++) {

                    (
                    function(data, year) {
                        var table = new google.visualization.DataTable(data);
                        var chart = new google.visualization.PieChart(document.getElementById("chart_div"));
                        chart.draw(table, jQuery.extend(opt, {
                            title: year 
                        }));
                    }
                    )(piedata[years[x]], years[x]);
                }
                var tableData = new google.visualization.DataTable(table);
                // Create and draw the visualization.
                var visualization = new google.visualization.Table(document.getElementById('table'));
                visualization.draw(tableData, null);
                
                map.setCenter(new GLatLng(info.lat, info.lng), 10);
                map.addControl(new GSmallMapControl());
                map.addControl(new GMapTypeControl());
            });

        }
        function startInit() {
            var globaldata = ELECTION.data;
            jQuery("#search_button").click(function(e) {
                var key = jQuery("#search_box").val();
                var city = (ELECTION.data[key] || ELECTION.data["Secunderabad"]);
                redrawCity(city);
                return false;
            });

            jQuery("#search_box").keypress(function(e) {
            if(e.which===0){
                var key = jQuery("#search_box").val();
                var city = (ELECTION.data[key] || ELECTION.data["Secunderabad"]);
                redrawCity(city);
                return false;
                }
            });
        };
    });
});

