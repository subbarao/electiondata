google.load("jquery", "1.3.2");
google.load("maps", "2");
google.load("visualization", "1", {
    packages: ["piechart"]
})
google.setOnLoadCallback(function() {

    map = new GMap2(jQuery("#map")[0]);
    map.setCenter(new GLatLng(17.0478, 80.0982), 7);
    map.addControl(new GSmallMapControl());
    $(function() {
        ELECTION = {
            data: {},
            cities: [],
            init: function(jsonObj) {
                for (var j = 0; j < jsonObj.length; j++) {
                    var city_name = jsonObj[j].constituency.name
                    this.cities.push(city_name);
                    this.data[city_name] = jsonObj[j].constituency.id;
                    (function(city) {
                        var point = new GLatLng(city.lat, city.lng);
                        var marker = new GMarker(point);
                        map.addOverlay(marker);
                        GEvent.addListener(marker, 'click',
                        function() {
                            redrawCity(city.id);
                            marker.openInfoWindowHtml("<b>" + city.name + "</b>");
                        });
                    })(jsonObj[j].constituency);

                }
                jQuery("#search_box").autocomplete(ELECTION.cities);
            }
        };

        $.getJSON("/constituencies",
        function(jsonObj) {
            ELECTION.init(jsonObj);
            startInit();
        });
        function redrawCity(city) {
            $.getJSON("/constituencies/" + city,
            function(jsonObj) {
                var opt = {
                    legend: "bottom",
                    width: 200,
                    height: 200,
                    is3D: true
                };
                $('#chart_div').html("");
                var years = ["2004", "1999", "1994", "1989", "1985", "1983", "1978"];
                var info = jsonObj.map;
                var piedata = jsonObj.piedata;
                for (var x = 0; x < years.length; x++) {

                    (
                    function(data, year) {
                        var table = new google.visualization.DataTable(data);
                        var chart = new google.visualization.PieChart(document.getElementById("chart_div"));
                        chart.draw(table, jQuery.extend(opt, {
                            title: year + " Results"
                        }));
                    }

                    )(piedata[years[x]], years[x]);
                }

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
            jQuery("#message_box").show();
        };
    });
});

