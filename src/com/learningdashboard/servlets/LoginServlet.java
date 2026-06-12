package com.learningdashboard.servlets;

import com.learningdashboard.models.User;
import com.learningdashboard.dao.UserDAO;
import com.learningdashboard.utils.PasswordUtil;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * LoginServlet - Handles user login logic
 * Validates credentials and creates session
 */
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Input validation
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Hash the password
        String passwordHash = PasswordUtil.hashPassword(password);

        // Check if user exists and password matches
        User user = userDAO.getUserByUsernameAndPassword(username, passwordHash);

        if (user != null && user.isActive()) {
            // Create session and store user info
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            System.out.println("[INFO] User logged in: " + username);

            // Redirect based on role
            if ("admin".equals(user.getRole())) {
                response.sendRedirect("admin/dashboard.jsp");
            } else {
                response.sendRedirect("student/dashboard.jsp");
            }
        } else {
            // Login failed
            request.setAttribute("errorMessage", "Invalid username or password!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}

