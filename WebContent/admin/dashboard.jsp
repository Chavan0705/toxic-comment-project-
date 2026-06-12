<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.learningdashboard.dao.*, com.learningdashboard.models.*, java.util.*, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Learning Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="container">
            <a href="../index.jsp" class="logo">Learning Dashboard</a>
            <ul>
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
        CourseDAO courseDAO = new CourseDAO();
        EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
        CertificateDAO certificateDAO = new CertificateDAO();
        
        int totalUsers = userDAO.getTotalUserCount();
        int studentCount = userDAO.getStudentCount();
        int adminCount = totalUsers - studentCount;
        int totalCourses = courseDAO.getTotalCourseCount();
        int totalCertificates = certificateDAO.getTotalCertificateCount();
        
        DecimalFormat df = new DecimalFormat("0.0");
    %>

    <div class="container dashboard">
        <h2>Admin Dashboard</h2>
        <p style="color: #666; margin-bottom: 2rem;">System overview and management tools</p>

        <!-- System Stats -->
        <div class="dashboard-cards">
            <div class="stat-card">
                <h3>Total Users</h3>
                <div class="stat-value"><%= totalUsers %></div>
                <p>Registered Users</p>
            </div>
            <div class="stat-card">
                <h3>Students</h3>
                <div class="stat-value"><%= studentCount %></div>
                <p>Active Learners</p>
            </div>
            <div class="stat-card">
                <h3>Admins</h3>
                <div class="stat-value"><%= adminCount %></div>
                <p>System Administrators</p>
            </div>
            <div class="stat-card">
                <h3>Total Courses</h3>
                <div class="stat-value"><%= totalCourses %></div>
                <p>Available Courses</p>
            </div>
            <div class="stat-card">
                <h3>Certificates Issued</h3>
                <div class="stat-value"><%= totalCertificates %></div>
                <p>Total Earned</p>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="card" style="margin-top: 3rem;">
            <h3>Quick Actions</h3>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
                <a href="users.jsp" class="btn btn-primary btn-block">View All Users</a>
                <a href="courses.jsp" class="btn btn-primary btn-block">Manage Courses</a>
                <a href="add-course.jsp" class="btn btn-secondary btn-block">Add New Course</a>
                <a href="analytics.jsp" class="btn btn-primary btn-block">View Analytics</a>
            </div>
        </div>

        <!-- Recent Users -->
        <div class="card" style="margin-top: 2rem;">
            <h3>Recent Users</h3>
            <%
                List<User> recentUsers = userDAO.getAllUsers();
            %>
            <% if (recentUsers.isEmpty()) { %>
                <p>No users found.</p>
            <% } else { %>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            int count = 0;
                            for (User user : recentUsers) { 
                                if (count >= 5) break;
                                count++;
                        %>
                            <tr>
                                <td><%= user.getUsername() %></td>
                                <td><%= user.getEmail() %></td>
                                <td><span style="text-transform: uppercase; font-size: 0.85rem;"><%= user.getRole() %></span></td>
                                <td>
                                    <span style="padding: 0.25rem 0.75rem; border-radius: 4px; 
                                         background-color: <%= user.isActive() ? "#d4edda" : "#f8d7da" %>; 
                                         color: <%= user.isActive() ? "#155724" : "#721c24" %>;">
                                        <%= user.isActive() ? "ACTIVE" : "INACTIVE" %>
                                    </span>
                                </td>
                                <td>
                                    <a href="view-user.jsp?userId=<%= user.getUserId() %>" class="btn btn-primary btn-sm">View</a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
                <a href="users.jsp" class="btn btn-secondary" style="margin-top: 1rem;">View All Users</a>
            <% } %>
        </div>

        <!-- Top Courses -->
        <div class="card" style="margin-top: 2rem;">
            <h3>Top Rated Courses</h3>
            <%
                List<Course> topCourses = courseDAO.getAllCourses();
            %>
            <% if (topCourses.isEmpty()) { %>
                <p>No courses available.</p>
            <% } else { %>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Course Title</th>
                            <th>Platform</th>
                            <th>Rating</th>
                            <th>Duration</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            count = 0;
                            for (Course course : topCourses) { 
                                if (count >= 5) break;
                                count++;
                        %>
                            <tr>
                                <td><%= course.getCourseTitle() %></td>
                                <td><%= course.getPlatform().toUpperCase() %></td>
                                <td><%= course.getRating() != null ? course.getRating() : "N/A" %>/5</td>
                                <td><%= course.getDurationHours() %> hrs</td>
                                <td>
                                    <a href="edit-course.jsp?courseId=<%= course.getCourseId() %>" class="btn btn-primary btn-sm">Edit</a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
                <a href="courses.jsp" class="btn btn-secondary" style="margin-top: 1rem;">View All Courses</a>
            <% } %>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 Learning Dashboard. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
