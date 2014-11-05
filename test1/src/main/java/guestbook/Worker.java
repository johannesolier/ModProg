package guestbook;

import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class Worker extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String key = request.getParameter("key");
		String value = request.getParameter("value");
		Date date = new Date();
		Key dataKey = KeyFactory.createKey("dataKey", key);
		Entity taskData = new Entity(dataKey);
		taskData.setProperty("key", key);
		taskData.setProperty("value", value);
		taskData.setProperty("date", date);
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		datastore.put(taskData);
	}
}