<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.learningdashboard.dao.CourseDAO, com.learningdashboard.models.Course, java.util.List, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Courses - Admin Dashboard</title>
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

        CourseDAO courseDAO = new CourseDAO();
        List<Course> coursesList = courseDAO.getAllCourses();
        DecimalFormat df = new DecimalFormat("0.00");
    %>

    <div class="container dashboard">
        <div style="margin-bottom: 2rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h2>Course Directory Management</h2>
                <p style="color: #666; margin-top: 0.25rem;">Create, update, and manage aggregated online courses</p>
            </div>
            <div style="display: flex; gap: 0.5rem;">
                <a href="add-course.jsp" class="btn btn-secondary" style="margin-right: 0;">+ Add New Course</a>
                <a href="dashboard.jsp" class="btn btn-primary" style="margin-right: 0;">&larr; Back</a>
            </div>
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
            <h3>All Course Offerings (<%= coursesList.size() %>)</h3>
            
            <% if (coursesList.isEmpty()) { %>
                <p style="text-align: center; padding: 2rem 0; color: #777;">No courses found in database. Create one by clicking "Add New Course".</p>
            <% } else { %>
                <table class="table" style="margin-top: 1.5rem;">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Platform</th>
                            <th>Category</th>
                            <th>Instructor</th>
                            <th>Duration</th>
                            <th>Price</th>
                            <th>Rating</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Course c : coursesList) { %>
                            <tr>
                                <td>#<%= c.getCourseId() %></td>
                                <td><strong><%= c.getCourseTitle() %></strong></td>
                                <td>
                                    <span style="text-transform: uppercase; font-size: 0.8rem; font-weight: bold;"><%= c.getPlatform() %></span>
                                </td>
                                <td><%= c.getCategory() %></td>
                                <td><%= c.getInstructorName() != null ? c.getInstructorName() : "N/A" %></td>
                                <td><%= c.getDurationHours() %> hrs</td>
                                <td>
                                    <strong style="color: var(--primary-color);">
                                        <%= c.getPrice() == 0 ? "Free" : "$" + df.format(c.getPrice()) %>
                                    </strong>
                                </td>
                                <td style="color: #f39c12; font-weight: bold;">
                                    ★ <%= df.format(c.getRating() != null ? c.getRating() : 0.0) %>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 0.25rem;">
                                        <a href="edit-course.jsp?courseId=<%= c.getCourseId() %>" class="btn btn-secondary btn-sm" style="margin: 0; padding: 0.4rem 0.8rem; background-color: #3498db;">
                                            Edit
                                        </a>
                                        <a href="javascript:void(0);" 
                                           onclick="confirmDelete('Are you sure you want to permanently delete this course? This will remove all enrollments and progress logs for this course.', '../admin/courses?action=delete&courseId=<%= c.getCourseId() %>')"
                                           class="btn btn-danger btn-sm" style="margin: 0; padding: 0.4rem 0.8rem;">
                                            Delete
                                        </a>
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
