<%@page contentType="text/html;charset=UTF-8" language="java"%>
<html>
	<head>
		<title>Create Meet-up Map</title>
		<link rel="stylesheet" href="css/bootstrap.min.css">
		<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
		<script type="text/javascript">
			var map;
			var initialLocation = new google.maps.LatLng(34.415454, -119.845180);
			var geocoder;
			
			function init() {
				geocoder = new google.maps.Geocoder();
				var mapOptions = {
					zoom : 15,
					center : initialLocation,
					mapTypeId : google.maps.MapTypeId.HYBRID
				};
		
				map = new google.maps.Map(document.getElementById("locationmap"), mapOptions);
		
				google.maps.event.addListener(map, 'click', function(event) {
					placeMarker(event.latLng);
				});
			}
		
			function placeMarker(location) {
				var address = document.getElementById('address').value;
				geocoder.geocode({'latLng' : location}, function(results, status) {
					if (status == google.maps.GeocoderStatus.OK) {
						map.setCenter(results[0].geometry.location);
						var marker = new google.maps.Marker({
							map : map,
							position : results[0].geometry.location
						});
						document.getElementById("address").value=results[0].formatted_address;
					} else {
						alert('Geocode was not successful for the following reason: ' + status);
					}
				});
			}
		</script>
	</head>
	<body onload="init()">
		<jsp:include page="navbar.jsp"></jsp:include>
		<form class="form-horizontal" style="width: 50%" action="/addMap"
			method="post">
			<fieldset>
				<legend>Create Meet-up Map</legend>
				<div class="form-group">
					<label class="col-lg-2 control-label">Title</label>
					<div class="col-lg-10">
						<input type="text" name="MapTitle" class="form-control"
							placeholder="Title">
					</div>
				</div>
				<div class="form-group">
					<label class="col-lg-2 control-label">Users</label>
					<div class="col-lg-10">
						<input type="text" name="user" class="form-control" placeholder="User"> 
						<div id="locationmap" style="width: 50%; height: 300px; margin-left: auto; margin-right: auto; padding: 5px"></div>
						<input id="address" type="text" name="address" class="form-control" placeholder="Address" readonly>
					</div>
				</div>
				<div class="form-group">
					<label for="textArea" name="description"
						class="col-lg-2 control-label">Description</label>
					<div class="col-lg-10">
						<textarea class="form-control" rows="3" id="textArea"></textarea>
					</div>
				</div>
				<div class="form-group">
					<div class="col-lg-10 col-lg-offset-2">
						<button class="btn btn-default">Cancel</button>
						<button type="submit" class="btn btn-primary">Submit</button>
					</div>
				</div>
			</fieldset>
		</form>
	</body>
</html>
