package com.johannes.maps;

import java.io.IOException;

import javax.servlet.ServletException;
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
public class AddFriendServlet extends HttpServlet{
	
	/**
	 * Method doPost()
	 * 
	 * Retrieves name of friend and puts the friend as an enitity
	 * with properties name and the user as friend of.
	 */
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException{
		String friend = req.getParameter("friend");
		
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		Entity entFriend = new Entity("Friends");
		entFriend.setProperty("FriendOf",user.getNickname());
		entFriend.setProperty("Name", friend); 	//Can be key because everything before 
												//@gmail.com must be unique.
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		
		datastore.put(entFriend);
		
		res.sendRedirect("/viewFriends.jsp");
	}
}
