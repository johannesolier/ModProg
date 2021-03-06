<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.logging.Level"%>
<%@page import="com.google.appengine.api.memcache.ErrorHandlers"%>
<%@page
	import="com.google.appengine.api.memcache.MemcacheServiceFactory"%>
<%@page import="com.google.appengine.api.memcache.MemcacheService"%>
<%@page import="java.util.List"%>
<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@page import="com.google.appengine.api.datastore.Query.Filter"%>
<%@page import="com.google.appengine.api.datastore.Query.FilterPredicate"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<title>Meet-up: Invites</title>
<link rel="stylesheet" href="css/bootstrap.min.css">
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script>
<script type="text/javascript">
	function getLocation() {
		if (navigator.geolocation) {
			navigator.geolocation.getCurrentPosition(setPosition);
		} else {
			alert("Geolocation not supported!");
		}
	}

	function setPosition(position) {
		document.getElementById("glat").value = position.coords.latitude;
		document.getElementById("glong").value = position.coords.longitude;
	}
</script>
</head>
<body>
	<jsp:include page="/navbar.jsp"></jsp:include>
	<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();

		boolean showInvites = false;

		MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		
		/**
		*	Searches the memcache for the invite.
		*	If it is not there, it searches the datastore, and adds it to the memcache.
		*	Shows 'You have no invites' if there are no invites waiting for this user.
		*	Otherwise, it lists the invites with a start button 
		*/
		
		if (user == null)
			response.sendRedirect("/");
		else {
			Entity invite = (Entity)syncCache.get(user.getUserId());
			if (invite == null) {
				Filter filter = new FilterPredicate("guest", FilterOperator.EQUAL, user.getNickname());
				DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
				Query query = new Query("Invites").setFilter(filter);
				List<Entity> entity = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
				if (entity.isEmpty()) {
					%>
						<h4>You have no invites..</h4>
					<%
				} 
				else {
					for (Entity ent : entity) {
						pageContext.setAttribute("invite_title", ent.getProperty("title"));
					}
					showInvites = true;
				}
			} 
			else {
				if(invite.getProperty("guest") == user.getNickname()){
					%>
					document.getElementById("meetUser").value=<%=invite.getProperty("owner")%>;
					<%
					pageContext.setAttribute("invite_title", invite.getProperty("title"));
					showInvites = true;
				}
				else{
					%>
						<h4>You have no invites..</h4>
					<%
				}
			}
			if (showInvites) {
				%>
					<form action="/startTracking" method="post" onsubmit="getLocation()">
						<h1>Invite: ${fn:escapeXml(invite_title)}</h1>
						<input type="hidden" name="title"
							value="${fn:escapeXml(invite_title)}"></input>
						<button type="submit" class="btn btn-primary">Start</button>
						<input id="glat" type="hidden" name="glat" class="form-control">
						<input id="glong" type="hidden" name="glong" class="form-control">
					</form>
						<%
						if(session.getAttribute("twitter") != null){
						%>
						<form action="/sendTweet" method="get">
							<button type="submit" class="btn btn-primary">Send Tweet</button>
							<input id="meetUser" type="hidden" name="meetUser" class="form-control">
						</form>
						<%} %>
				<%
			}
		}
	%>
</body>
</html>