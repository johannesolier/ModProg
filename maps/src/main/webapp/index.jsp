<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Meet-up Map</title>
		<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
		<meta charset="utf-8">
		<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
		<script>
			var map;
			var initialLocation = new google.maps.LatLng(34.415454, -119.845180);
	
			function init() {
				var mapOptions = {
					zoom : 15,
					center : initialLocation,
					mapTypeId : google.maps.MapTypeId.HYBRID
				};
	
				map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
				var marker = new google.maps.Marker({
					position : initialLocation,
					map : map
				});
				
				google.maps.event.addListener(map, 'click', function(event) {
			        placeMarker(event.latLng);
			    });
			}
	
			function placeMarker(location) {
			    var marker = new google.maps.Marker({
			        position: location, 
			        map: map
			    });
			}
		</script>
		<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
		<!--  script type="text/javascript" src="js/mapfunc.js"></script-->
		<script type="text/javascript" src="js/bootstrap.js"></script>
	</head>
	<body onload="init()">
		<jsp:include page="/navbar.jsp"></jsp:include>
		<div id="map_canvas" style="width: 100%; height: 850px"></div>
	</body>
</html>