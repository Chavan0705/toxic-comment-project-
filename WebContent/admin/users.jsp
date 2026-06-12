<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.learningdashboard.dao.UserDAO, com.learningdashboard.models.User, java.util.List, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="container">
            <a href="../index.jsp" class="logo">Learning Dashboard</a>
            <ul id="navMenu">
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="users.jsp">Manage Users</a></li>
                <li><a href="courses.jsp">Manage Courses</a></li>
                <li><a href="analytics.jsp">Analytics</a></li>
                <li><a href="../logout">Logout</a></li>
            </ul>
        </div>
    </nav>

    <%
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        if (userId == null || !"admin".equals(role)) {
            response.sendRedirect("../login.jsp");
            return;
        }

        UserDAO userDAO = new UserDAO();
        List<User> usersList = userDAO.getAllUsers();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    %>

    <div class="container dashboard">
        <div style="margin-bottom: 2rem; display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h2>User Management</h2>
                <p style="color: #666; margin-top: 0.25rem;">Monitor system accounts and control access privileges</p>
            </div>
            <a href="dashboard.jsp" class="btn btn-secondary" style="margin-right: 0;">&larr; Back to Dashboard</a>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success">
                <%= request.getAttribute("successMessage") %>
            </div>
        <% } %>

        <div class="card">
            <h3>Registered User Accounts (<%= usersList.size() %>)</h3>
            
            <% if (usersList.isEmpty()) { %>
                <p style="text-align: center; padding: 2rem 0; color: #777;">No users found in database.</p>
            <% } else { %>
                <table class="table" style="margin-top: 1.5rem;">
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Username</th>
                            <th>Email Address</th>
                            <th>System Role</th>
                            <th>Joined Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (User u : usersList) { %>
                            <tr>
                                <td>#<%= u.getUserId() %></td>
                                <td><strong><%= u.getUsername() %></strong></td>
                                <td><%= u.getEmail() %></td>
                                <td>
                                    <span style="font-weight: 600; text-transform: uppercase; font-size: 0.8rem;
                                          padding: 0.15rem 0.5rem; border-radius: 4px;
                                          background-color: <%= "admin".equals(u.getRole()) ? "#e1bee7" : "#cfd8dc" %>;
                                          color: <%= "admin".equals(u.getRole()) ? "#4a148c" : "#263238" %>;">
                                        <%= u.getRole() %>
                                    </span>
                                </td>
                                <td style="font-size: 0.9rem; color: #555;">
                                    <%= u.getCreatedAt() != null ? sdf.format(u.getCreatedAt()) : "N/A" %>
                                </td>
                                <td>
                                    <span style="padding: 0.25rem 0.75rem; border-radius: 4px; font-weight: bold; font-size: 0.85rem;
                                         background-color: <%= u.isActive() ? "#d4edda" : "#f8d7da" %>; 
                                         color: <%= u.isActive() ? "#155724" : "#721c24" %>;">
                                        <%= u.isActive() ? "ACTIVE" : "SUSPENDED" %>
                                    </span>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 0.25rem;">
                                        <a href="view-user.jsp?userId=<%= u.getUserId() %>" class="btn btn-primary btn-sm" style="margin: 0; padding: 0.4rem 0.8rem;">View</a>
                                        
                                        <!-- Actions submit to AdminUserServlet -->
                                        <form action="../admin/users" method="POST" style="display: inline; margin: 0;">
                                            <input type="hidden" name="action" value="toggleStatus">
                                            <input type="hidden" name="targetUserId" value="<%= u.getUserId() %>">
                                            <button type="submit" class="btn btn-secondary btn-sm" style="margin: 0; padding: 0.4rem 0.8rem; background-color: #3498db;">
                                                Toggle
                                            </button>
                                        </form>

                                        <% if (u.getUserId() != userId) { %>
                                            <!-- Do not allow admin to delete themselves -->
                                            <a href="javascript:void(0);" 
                                               onclick="confirmDelete('Are you sure you want to permanently delete user: <%= u.getUsername() %>? This will clear all their progress logs and enrollments.', '../admin/users?action=delete&targetUserId=<%= u.getUserId() %>')"
                                               class="btn btn-danger btn-sm" style="margin: 0; padding: 0.4rem 0.8rem;">
                                                Delete
                                            </a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 Learning Dashboard. All rights reserved.</p>
        </div>
    </footer>
    <script src="../js/main.js"></script>
</body>
</html>
