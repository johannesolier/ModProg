package com.johannes.maps;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class StartTrackingServlet extends HttpServlet{
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException{
		String title = req.getParameter("title");
		String glatitude = req.getParameter("glat");
		String glongitude = req.getParameter("glong");
		
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		Filter filter = new FilterPredicate("guest",FilterOperator.EQUAL,user.getNickname());
		Filter filter2 = new FilterPredicate("title",FilterOperator.EQUAL,title);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Query query = new Query("Invites").setFilter(filter).setFilter(filter2);
		PreparedQuery pq = datastore.prepare(query);
		Entity entity = pq.asSingleEntity();
		datastore.delete(entity.getKey());
		entity.setProperty("glat", glatitude);
		entity.setProperty("glong", glongitude);
		datastore.put(entity);
		
		HttpSession session = req.getSession(true);
		session.setAttribute("started", true);
		
		res.sendRedirect("/viewInvites.jsp");
	}
}