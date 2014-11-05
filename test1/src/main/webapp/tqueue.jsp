<%@page import="com.google.appengine.api.datastore.EntityNotFoundException"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.Query.SortDirection"%>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<html>
<head>
	<link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
</head>
<body>

	<%
	String key = request.getParameter("key");
	if(key == null){
	%>
	<p>Nothing was added to the key</p>
	<%
	}else{
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Key qKey = KeyFactory.createKey("dataKey",key);
		Query query = new Query(qKey);	
		List<Entity> entities = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(20));
		if(entities.isEmpty()){
	%>
			<p>No tasks in the datastore</p>
	<%
		}
		else{
			Entity entity = entities.get(entities.size()-1);
			String value = (String)entity.getProperty("value");
			%>
			<p>Key: <%= key %> - Value: <%= value %></p> 
			<%
		}
	}
	%>

</body>
</html>