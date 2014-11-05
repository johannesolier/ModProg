package guestbook;

import static com.google.appengine.api.taskqueue.TaskOptions.Builder.*;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;

public class Enqueue extends HttpServlet {
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String key = request.getParameter("key");
		String value = request.getParameter("value");

		// Add the task to the default queue.
		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/worker").param("key", key).param("value",value));
		//queue.add(withUrl("/worker").param("value", value));

		//response.sendRedirect("/done.html");
		response.sendRedirect("/tqueue.jsp?key="+key);
	}
}
