<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Meeting Map</title>
		<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
		<meta charset="utf-8">
		<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
		<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
		<script type="text/javascript" src="mapFunc.js"></script>
	</head>
	<body onload="init()">
		<jsp:include page="/navbar.html"></jsp:include>
		<div id="map_canvas" style="width: 100%; height: 850px"></div>
	</body>
</html>