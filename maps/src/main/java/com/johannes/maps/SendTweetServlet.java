package com.johannes.maps;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import twitter4j.Logger;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;

@SuppressWarnings("serial")
public class SendTweetServlet extends HttpServlet{
	
	private static Logger LOG = Logger.getLogger(SendTweetServlet.class);   

	/**
	 * Method doGet
	 * 
	 * Instantiates a twitter instance and writes a message.
	 */
	 
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException{
		String meetUser = req.getParameter("meetUser");
		try {
			Twitter twitter = (Twitter)req.getSession().getAttribute("twitter");
	        Status status = twitter.updateStatus("I am using Meet-up Map to meet my friend " + meetUser + "!");
	        LOG.debug("Successfully updated status to " + status.getText());
		} catch (TwitterException e) {
			e.printStackTrace();
		}
		res.sendRedirect("/");
	}
}