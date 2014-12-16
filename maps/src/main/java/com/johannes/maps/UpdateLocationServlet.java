package com.johannes.maps;

import java.io.IOException;

import javax.servlet.ServletException;
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
import com.sun.org.apache.bcel.internal.generic.LNEG;

@SuppressWarnings("serial")
public class UpdateLocationServlet extends HttpServlet{
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException{
		
		String title = req.getParameter("title");
		String latitude = req.getParameter("lat");
		String longitude = req.getParameter("long");
		
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		HttpSession session = req.getSession();

		if(session.getAttribute("tracking").equals("guest")){
			Filter guest = new FilterPredicate("guest",FilterOperator.EQUAL,user.getNickname());
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			Query query = new Query("Invites").setFilter(guest);
			PreparedQuery pq = datastore.prepare(query);
			Entity entity = pq.asSingleEntity();
			datastore.delete(entity.getKey());
			System.out.println(latitude + " " + longitude);
			entity.setProperty("glat", latitude);
			entity.setProperty("glong", longitude);
			datastore.put(entity);
		}
		else if(session.getAttribute("tracking").equals("owner")){
			Filter owner = new FilterPredicate("owner",FilterOperator.EQUAL,user.getNickname());
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			Query query = new Query("Invites").setFilter(owner);
			PreparedQuery pq = datastore.prepare(query);
			Entity entity = pq.asSingleEntity();
			datastore.delete(entity.getKey());
			entity.setProperty("olat", latitude);
			entity.setProperty("olong", longitude);
			datastore.put(entity);
		}
		
		res.sendRedirect("/");
	}
}