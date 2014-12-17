<%@page import="com.google.appengine.api.datastore.Query.SortDirection"%>
<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="java.util.List"%>
<%@page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@page import="com.google.appengine.api.datastore.Query"%>
<%@page import="com.google.appengine.api.users.User"%>
<%@page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@page import="com.google.appengine.api.users.UserService"%>
<%@page import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@page import="com.google.appengine.api.datastore.Query.Filter"%>
<%@page import="com.google.appengine.api.datastore.Query.FilterPredicate"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="css/bootstrap.min.css">
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Meet-up: Friends</title>
</head>
<body>
<jsp:include page="/navbar.jsp"></jsp:include>
<div class="list-group" style="width:50%; text-align:center; margin-left:auto; margin-right:auto;">
  <a href="" class="list-group-item active">Friends</a>
  <%
  DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
  
  UserService userService = UserServiceFactory.getUserService();
  User user = userService.getCurrentUser();
   
  /**
  *	Searches the datastore for friends that are friends with this user.
  *	Adds them to the friend list.
  */
  
  if(user == null)
	  response.sendRedirect("/");
  else{
	  Filter me = new FilterPredicate("FriendOf",FilterOperator.EQUAL, user.getNickname());
	  Query query = new Query("Friends").addSort("Name",SortDirection.ASCENDING).setFilter(me);
	  List<Entity> friends = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(20));
	  for(Entity friend: friends){
		  %>
		  <a href="" class="list-group-item"><%=friend.getProperty("Name")%></a>
		  <%
	  }
  }
  %>
</div>
</body>
</html>










