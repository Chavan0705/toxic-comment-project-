package com.learningdashboard.servlets;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * LogoutServlet - Handles user logout
 * Invalidates session and redirects to home page
 */
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            String username = (String) session.getAttribute("username");
            System.out.println("[INFO] User logged out: " + username);
            session.invalidate();
        }
        
        response.sendRedirect("index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

