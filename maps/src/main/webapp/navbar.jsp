<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="com.google.appengine.api.users.User"%>
<%@page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@page import="com.google.appengine.api.users.UserService"%>
<%@page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@page import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@page import="com.google.appengine.api.datastore.Query" %>
<%@page import="com.google.appengine.api.datastore.Query.Filter" %>
<%@page import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@page import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@page import="com.google.appengine.api.datastore.Entity" %>
<%@page import="com.google.appengine.api.datastore.PreparedQuery" %>
<%@page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@page import="java.util.List" %>
<!DOCTYPE HTML>
<html>
	<head>
		<meta charset="utf-8">
	</head>
	<body>
		<div class="navbar navbar-default">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target=".navbar-responsive-collapse">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="/">Meet-up Map</a>
			</div>
			<div class="navbar-collapse collapse navbar-responsive-collapse">
				<%
					UserService userService = UserServiceFactory.getUserService();
					User user = userService.getCurrentUser();
					if (user == null) {
				%>
				<ul class="nav navbar-nav navbar-right">
					<li><a
						href="<%=userService.createLoginURL(request.getRequestURI())%>">Sign
							in</a></li>
				</ul>
				<%
					} else if(user != null){
				%>
				<ul class="nav navbar-nav navbar-left">
					<li><form class="navbar-form navbar-left">
							<input type="text" class="form-control col-lg-8"
								placeholder="Search User">
						</form>
					</li>
					<li><a href="/create_meet_map.jsp">Create Meet-up Map</a></li>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
					<%=user.getNickname()%>
					<b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li><a href="<%=userService.createLogoutURL(request.getRequestURI())%>">Sign out</a></li>
						</ul>
					</li>
				</ul>
				<%
					}//If maps not empty
				%>
			</div>
		</div>
	</body>
</html>