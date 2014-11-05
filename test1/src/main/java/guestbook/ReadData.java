package guestbook;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Entity;

public class ReadData extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		
		PrintWriter pw = response.getWriter();
		
		pw.println("<html>");
		pw.println("<head>");
		pw.println("<title>DataTasks</title>");
		pw.println("</head>");
		pw.println("</html>");
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Query query = new Query("dataKey").addSort("date",Query.SortDirection.DESCENDING);
		List<Entity> entities = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(20));
		
		if(entities.isEmpty()){
			pw.println("<p>No tasks has been fired yet</p>");
		}else{
			for(Entity entity: entities) {
				String key = (String)entity.getProperty("key");
				String date = entity.getProperty("date").toString();
				String value = (String)entity.getProperty("value");
				
				pw.println("<tr>");
				pw.println("<td>" + key + "</td>");
				pw.println("<td>" + value + "</td>");
				pw.println("<td>" + date + "</td>");
				pw.println("</tr>");
				pw.println("<br>");
			}
			pw.println("</table>");
		}
		
	}
}