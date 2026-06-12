package com.learningdashboard.servlets;

import com.learningdashboard.dao.UserDAO;
import com.learningdashboard.models.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * AdminUserServlet - Handles admin actions on user accounts
 */
public class AdminUserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        if (session == null || !"admin".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        if ("toggleStatus".equals(action)) {
            try {
                int targetUserId = Integer.parseInt(request.getParameter("targetUserId"));
                User targetUser = userDAO.getUserById(targetUserId);

                if (targetUser != null) {
                    // Toggle status
                    targetUser.setActive(!targetUser.isActive());
                    if (userDAO.updateUser(targetUser)) {
                        request.setAttribute("successMessage", "User status updated successfully!");
                    } else {
                        request.setAttribute("errorMessage", "Failed to update user status.");
                    }
                } else {
                    request.setAttribute("errorMessage", "User not found.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid User ID.");
            }
        }

        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        if (session == null || !"admin".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            try {
                int targetUserId = Integer.parseInt(request.getParameter("targetUserId"));
                Integer currentAdminId = (Integer) session.getAttribute("userId");

                if (currentAdminId != null && currentAdminId == targetUserId) {
                    request.setAttribute("errorMessage", "Security Alert: You cannot delete your own admin account.");
                } else {
                    if (userDAO.deleteUser(targetUserId)) {
                        request.setAttribute("successMessage", "User account deleted successfully!");
                    } else {
                        request.setAttribute("errorMessage", "Failed to delete user account.");
                    }
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid User ID.");
            }
        }

        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }
}
