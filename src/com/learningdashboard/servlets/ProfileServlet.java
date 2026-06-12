package com.learningdashboard.servlets;

import com.learningdashboard.dao.UserProfileDAO;
import com.learningdashboard.models.UserProfile;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class ProfileServlet extends HttpServlet {
    private UserProfileDAO profileDAO = new UserProfileDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.getRequestDispatcher("student/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("userId");
            int formUserId = Integer.parseInt(request.getParameter("userId"));

            if (userId != formUserId) {
                request.setAttribute("errorMessage", "Access Denied: You cannot edit another user's profile.");
                request.getRequestDispatcher("student/profile.jsp").forward(request, response);
                return;
            }

            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String city = request.getParameter("city");
            String country = request.getParameter("country");
            String bio = request.getParameter("bio");

            // Load existing profile or create one
            UserProfile profile = profileDAO.getUserProfileByUserId(userId);
            profile.setFirstName(firstName);
            profile.setLastName(lastName);
            profile.setPhone(phone);
            profile.setCity(city);
            profile.setCountry(country);
            profile.setBio(bio);

            if (profileDAO.updateUserProfile(profile)) {
                request.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
            }

        } catch (NumberFormatException e) {
            System.out.println("[ERROR] Invalid user ID in ProfileServlet: " + e.getMessage());
            request.setAttribute("errorMessage", "Invalid profile parameters.");
        }

        request.getRequestDispatcher("student/profile.jsp").forward(request, response);
    }
}
