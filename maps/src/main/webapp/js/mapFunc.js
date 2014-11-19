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
}