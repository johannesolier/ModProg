<%@page import="com.google.appengine.api.datastore.PreparedQuery"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@page import="com.google.appengine.api.datastore.Query.Filter"%>
<%@page
	import="com.google.appengine.api.datastore.Query.FilterPredicate"%>
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

<%@ page import="java.util.List"%>
<%
	BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
%>

<html>
<head>
<title>Meet-up: Profile</title>
<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
<script type="text/javascript"
	src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
</head>
<body>
	<jsp:include page="/navbar.jsp"></jsp:include>
	<div class="jumbotron"
		style="width: 50%; margin-left: auto; margin-right: auto; text-align: center;">
		<h1>Profile picture</h1>
		<p>Upload your own personal profile picture</p>
		<form action="<%=blobstoreService.createUploadUrl("/upload")%>"
			method="post" enctype="multipart/form-data">
			<input type="file" name="Image" style="color: #ffffff; background-color: #f39c12; border-color: #f39c12;" required>
			<button type="submit" class="btn btn-primary">Submit</button>
		</form>
		<%
			/**
			*	Searches the datastore for images uploaded by the user.
			* 	Selects the most recent for the profile pic.
			*/
			String filename = "";
			UserService userService = UserServiceFactory.getUserService();
			User user = userService.getCurrentUser();
			Filter filter = new FilterPredicate("User", FilterOperator.EQUAL, user.getUserId());
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			Query query = new Query("Images").addSort("Date", Query.SortDirection.DESCENDING).setFilter(filter);
			List<Entity> entity = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(1));
			if (!entity.isEmpty()) {
				filename = entity.get(0).getProperty("Image").toString();
				String url = "/serve?blob-key=" + filename;
				System.out.println(filename);
				if (user != null && filename.length() > 0) {
		%>
		<img src=<%=url%>></img>
		<%
			}
			}
		%>
	</div>
</body>
</html>