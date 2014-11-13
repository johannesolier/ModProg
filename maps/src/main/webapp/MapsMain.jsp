<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
<head>
<title>Meeting Map</title>
<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
<meta charset="utf-8">
<script type="text/javascript"
	src="http://maps.google.com/maps/api/js?sensor=false"></script>
<script type="text/javascript">
	var map;
	var initialLocation = new google.maps.LatLng(-44.6895642, 169.1320571);
	function init() {
		var duckOptions = {
			zoom : 12,
			center : initialLocation,
			mapTypeId : google.maps.MapTypeId.HYBRID
		};
		map = new google.maps.Map(document.getElementById("map_canvas"),
				duckOptions);
		var marker = new google.maps.Marker({
			position : initialLocation,
			map : map
		});
	}
</script>
</head>
<body onload="init()">
	<div class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse"
				data-target=".navbar-responsive-collapse">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand"
				href="https://github.com/johannesolier/ModProg">Github</a>
		</div>
		<div class="navbar-collapse collapse navbar-responsive-collapse">
			<ul class="nav navbar-nav">
				<li class="SignUp"><a href="/sign-in">Sign In</a></li>
			</ul>
			<form class="navbar-form navbar-left">
				<input type="text" class="form-control col-lg-8"
					placeholder="Search">
			</form>
		</div>
	</div>
	<h1>Meeting Map</h1>
	<div id="map_canvas" style="width: 100%; height: 800px"></div>
</body>
</html>