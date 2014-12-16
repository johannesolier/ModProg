<%@page import="com.google.appengine.api.datastore.PreparedQuery"%>
<%@page import="java.util.List"%>
<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@page import="com.google.appengine.api.datastore.Query.Filter"%>
<%@page
	import="com.google.appengine.api.datastore.Query.FilterPredicate"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page
	import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>Meet-up Map</title>
<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
<meta charset="utf-8">
<script type="text/javascript"
	src="http://maps.google.com/maps/api/js?sensor=true"></script>
<script>
	var map;
	var initialLocation;

	function getLocation() {
		if (navigator.geolocation) {
			navigator.geolocation.getCurrentPosition(setPosition);
		} else {
			alert("Geolocation not supported!");
		}
	}

	function setPosition(position) {
		initialLocation = new google.maps.LatLng(position.coords.latitude,
				position.coords.longitude);
		document.getElementById("lat").value = position.coords.latitude;
		document.getElementById("long").value = position.coords.longitude;
		init();
		placeMarker(new google.maps.LatLng(
				document.getElementById("otherLat").value, document
						.getElementById("otherLong").value));
	}

	function init() {
		var mapOptions = {
			zoom : 15,
			center : initialLocation,
			mapTypeId : google.maps.MapTypeId.HYBRID
		};

		map = new google.maps.Map(document.getElementById("map_canvas"),
				mapOptions);
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
			position : location,
			map : map
		});
	}
</script>
<script type="text/javascript"
	src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
</head>
<body onload="getLocation()">
	<jsp:include page="/navbar.jsp"></jsp:include>
	<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();

		if (user != null) {
			Filter guest = new FilterPredicate("guest", FilterOperator.EQUAL, user.getNickname());
			Filter owner = new FilterPredicate("owner", FilterOperator.EQUAL, user.getNickname());
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			Query query = new Query("Invites").setFilter(guest);
			PreparedQuery pq = datastore.prepare(query);
			Entity entity = pq.asSingleEntity();
			if (entity == null) {
				query = new Query("Invites").setFilter(owner);
				pq = datastore.prepare(query);
				entity = pq.asSingleEntity();
				if (entity == null)
					session.setAttribute("tracking", null);
				else {
					session.setAttribute("tracking", "owner");
					pageContext.setAttribute("otherLat", entity.getProperty("glat"));
					pageContext.setAttribute("otherLong", entity.getProperty("glong"));
				}
			} else {
				session.setAttribute("tracking", "guest");
				pageContext.setAttribute("otherLat", entity.getProperty("olat"));
				pageContext.setAttribute("otherLong", entity.getProperty("olong"));
			}
		}
	%>
	<input id="otherLat" type="hidden" value="${fn:escapeXml(otherLat)}"
		name="otherLat" class="form-control">
	<input id="otherLong" type="hidden" value="${fn:escapeXml(otherLong)}"
		name="otherLong" class="form-control">
	<div id="map_canvas" style="width: 100%; height: 850px"></div>
	<form action="/updateLocation" method="post">
		<input id="lat" type="hidden" name="lat" class="form-control">
		<input id="long" type="hidden" name="long" class="form-control">
		<button type="submit">OPPDATER</button>
	</form>
</body>
</html>