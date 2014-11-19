<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="com.google.appengine.api.users.User"%>
<%@page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@page import="com.google.appengine.api.users.UserService"%>
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
			<a class="navbar-brand" href="#">Meet-up Map</a>
		</div>
		<div class="navbar-collapse collapse navbar-responsive-collapse">
			<%
				UserService userService = UserServiceFactory.getUserService();
				User user = userService.getCurrentUser();
				if (user == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li><a
					href="<%=userService.createLoginURL(request.getRequestURI())%>">Sign in</a></li>
			</ul>
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-left">
				<li><form class="navbar-form navbar-left">
						<input type="text" class="form-control col-lg-8"
							placeholder="Search User">
					</form></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="/create_meet_map.jsp">Create Meet-Map</a></li>
				<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><%=user.getNickname()%><b class="caret"></b></a>
					<ul class="dropdown-menu">
						<li><a href="<%=userService.createLogoutURL(request.getRequestURI())%>">Sign out</a></li>
					</ul>
				</li>
			</ul>
		</div>
		<%
			}
		%>
	</div>
</body>
</html>