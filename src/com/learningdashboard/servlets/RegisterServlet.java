package com.learningdashboard.servlets;

import com.learningdashboard.models.User;
import com.learningdashboard.dao.UserDAO;
import com.learningdashboard.utils.PasswordUtil;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.regex.Pattern;

/**
 * RegisterServlet - Handles user registration logic
 * Validates input and creates new user account
 */
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation
        if (username == null || username.isEmpty() || 
            email == null || email.isEmpty() || 
            password == null || password.isEmpty()) {
            
            request.setAttribute("errorMessage", "All fields are required!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Validate username length
        if (username.length() < 3 || username.length() > 50) {
            request.setAttribute("errorMessage", "Username must be between 3 and 50 characters!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Validate email format
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            request.setAttribute("errorMessage", "Invalid email format!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Validate password strength
        if (!PasswordUtil.isStrongPassword(password)) {
            request.setAttribute("errorMessage", "Password must be at least 8 characters with uppercase, lowercase, and numbers!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Check if email or username already exists
        if (userDAO.emailExists(email)) {
            request.setAttribute("errorMessage", "Email already exists!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (userDAO.usernameExists(username)) {
            request.setAttribute("errorMessage", "Username already exists!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Create new user
        User newUser = new User(username, email, PasswordUtil.hashPassword(password), "student");
        if (userDAO.registerUser(newUser)) {
            request.setAttribute("successMessage", "Registration successful! Please login.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Registration failed! Try again.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }
}

