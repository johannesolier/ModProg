package com.johannes.maps;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class Upload extends HttpServlet {
	
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	
	/**
	 * Method doPost
	 * 
	 * Retrieves the file uploaded by the user. Puts it in the datastore. Add the date
	 * as a property to easily sort and get most recently uploaded file.
	 * 
	 * The redirect to error.jsp is now useless because of the 'required' property 
	 * of the file <input>-field.
	 * 
	 * Kept because I want to make it work right.
	 */
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException{
		Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(req);
		List<BlobKey> blobKey = blobs.get("Image");
		Date date = new Date();
		
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		System.out.println(req.getParameter("Image") + " IMAGE");
		if (blobKey == null || blobKey.isEmpty() ) {
			System.out.println("blobKey == null");
			res.sendRedirect("/error.jsp");
		}
		else{
			Entity entity = new Entity("Images");
			entity.setProperty("User", user.getUserId());
			entity.setProperty("Image", blobKey.get(0).getKeyString());
			entity.setProperty("Date", date.getTime());
			
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.put(entity);
			
			res.sendRedirect("/profile.jsp");
		}
	}

}
