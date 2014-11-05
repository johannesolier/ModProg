package guestbook;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.memcache.ErrorHandlers;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;

public class Memcache extends HttpServlet {

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		String key = request.getParameter("key");
		String _value = request.getParameter("value");

		// Using the synchronous cache
		MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
//		syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		String value = (String) syncCache.get(key); // read from cache

		PrintWriter pw = response.getWriter();
		pw.println("<html>");
		pw.println("<body>");

		if (value == null) {
			DatastoreService datastore = DatastoreServiceFactory
					.getDatastoreService();
			Key mKey = KeyFactory.createKey("MemCache", key);
			Query query = new Query("MemCache", mKey);
			List<Entity> entities = datastore.prepare(query).asList(
					FetchOptions.Builder.withLimit(1));
			if(!entities.isEmpty()){
				syncCache.put(key, _value);
				System.out.println("Key " + key + " value " +value);
				pw.println("<p>Key was now stored in memcache</p>");
				Entity e = entities.get(0);
				String valueDS = (String)e.getProperty("value");
				pw.println("<p>Value: " + valueDS + " - was read from datastore</p>");
			}
			else{
				pw.println("<p>Key was not in memcache or datastore</p>");
				Entity e = new Entity(mKey);
				e.setProperty("key", key);
				e.setProperty("value", _value);
				datastore.put(e);
				pw.println("<p>Key and value of the entity is now stored</p>");
			}
		}
		else{
			pw.println("<p>Already in memcache</p>");
		}
		pw.println("</body>");
		pw.println("</html>");
	}
}