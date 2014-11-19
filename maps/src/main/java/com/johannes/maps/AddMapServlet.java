package com.johannes.maps;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class AddMapServlet extends HttpServlet{
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException{
		String mapTitle = req.getParameter("MapTitle");
		String otherUser = req.getParameter("user");
		String description = req.getParameter("description");
		
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		/**
		 * TODO:
		 * Change String user to an Entity
		 */
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		
		List<String> users = new ArrayList<String>();
		users.add(otherUser);
		users.add(user.getNickname());
		
		Entity map = new Entity("Map");
		map.setProperty("title", mapTitle);
		map.setProperty("user", users);
		map.setProperty("Description", description);
		
		datastore.put(map);
		
		res.sendRedirect("/");
	}
}