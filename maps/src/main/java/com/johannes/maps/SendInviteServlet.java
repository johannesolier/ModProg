package com.johannes.maps;

import java.io.IOException;
import java.util.logging.Level;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.memcache.ErrorHandlers;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class SendInviteServlet extends HttpServlet{
	
	/**
	 * Method doPost
	 * 
	 * Retrieves information about the invitation, most important is who the invite
	 * comes from and the longitude and latitude of that person.
	 * 
	 * Also puts the invite in memcache.
	 */
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException{
		String mapTitle = req.getParameter("MapTitle");
		String otherUser = req.getParameter("user");
		String description = req.getParameter("description");
		String latitude = req.getParameter("lat");
		String longitude = req.getParameter("long");
		String olatitude = req.getParameter("olat");
		String olongitude = req.getParameter("olong");
		
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		
		Entity map = new Entity("Invites");
		map.setProperty("title", mapTitle);
		map.setProperty("owner", user.getNickname());
		map.setProperty("guest", otherUser);
		map.setProperty("goalLat", latitude);
		map.setProperty("goalLong", longitude);
		map.setProperty("Description", description);
		map.setProperty("olat", olatitude);
		map.setProperty("olong", olongitude);
		map.setProperty("glat", "");
		map.setProperty("glong", "");
		
		datastore.put(map);

		/**
		 * If a map is not in memcache, put it in memcache.
		 * If a map is in memcache, delete the old and put the new one in.
		 */
		if(syncCache.get(user.getUserId()) == null){
			syncCache.put(user.getUserId(), map);
		}
		else{
			syncCache.delete(user.getUserId());
			syncCache.put(user.getUserId(), map);
		}
		
		res.sendRedirect("/");
	}
}