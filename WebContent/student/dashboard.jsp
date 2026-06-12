<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.learningdashboard.dao.*, com.learningdashboard.models.*, java.util.*, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Dashboard - Learning Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="container">
            <a href="../index.jsp" class="logo">Learning Dashboard</a>
            <ul>
                <li><a href="../index.jsp">Home</a></li>
                <li><a href="../courses.jsp">Courses</a></li>
                <li><a href="dashboard.jsp">My Dashboard</a></li>
                <li><a href="profile.jsp">Profile</a></li>
                <li><a href="../logout">Logout</a></li>
            </ul>
        </div>
    </nav>

    <%
        Integer userId = (Integer) session.getAttribute("userId");
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");
        
        if (userId == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
        CertificateDAO certificateDAO = new CertificateDAO();
        ProgressDAO progressDAO = new ProgressDAO();
        
        int totalEnrollments = enrollmentDAO.getUserEnrollmentCount(userId);
        int completedCourses = enrollmentDAO.getCompletedCoursesCount(userId);
        int inProgressCourses = enrollmentDAO.getInProgressCoursesCount(userId);
        double totalHours = enrollmentDAO.getTotalHoursSpent(userId);
        int totalCertificates = certificateDAO.getUserCertificateCount(userId);
        
        List<Enrollment> enrollments = enrollmentDAO.getUserEnrollments(userId);
        DecimalFormat df = new DecimalFormat("0.0");
    %>

    <div class="container dashboard">
        <h2>Welcome, <%= username %>!</h2>
        <p style="color: #666; margin-bottom: 2rem;">Track your learning progress and manage your courses</p>

        <!-- Stats Cards -->
        <div class="dashboard-cards">
            <div class="stat-card">
                <h3>Enrollments</h3>
                <div class="stat-value"><%= totalEnrollments %></div>
                <p>Courses Enrolled</p>
            </div>
            <div class="stat-card">
                <h3>Completed</h3>
                <div class="stat-value"><%= completedCourses %></div>
                <p>Courses Completed</p>
            </div>
            <div class="stat-card">
                <h3>In Progress</h3>
                <div class="stat-value"><%= inProgressCourses %></div>
                <p>Active Courses</p>
            </div>
            <div class="stat-card">
                <h3>Learning Hours</h3>
                <div class="stat-value"><%= df.format(totalHours) %></div>
                <p>Total Hours</p>
            </div>
            <div class="stat-card">
                <h3>Certificates</h3>
                <div class="stat-value"><%= totalCertificates %></div>
                <p>Earned</p>
            </div>
            <div class="stat-card">
                <h3>Average Progress</h3>
                <div class="stat-value"><%= df.format(progressDAO.getAverageCompletionPercentage(userId)) %>%</div>
                <p>Completion Rate</p>
            </div>
        </div>

        <!-- My Courses Section -->
        <div class="card" style="margin-top: 3rem;">
            <h3>My Enrolled Courses</h3>
            
            <% if (request.getParameter("message") != null && "enrolled".equals(request.getParameter("message"))) { %>
                <div class="alert alert-success">
                    Successfully enrolled in course! Start learning now.
                </div>
            <% } %>

            <% if (enrollments.isEmpty()) { %>
                <p style="text-align: center; color: #666; padding: 2rem 0;">
                    You haven't enrolled in any courses yet. 
                    <a href="../courses.jsp">Browse available courses</a>
                </p>
            <% } else { %>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Course Title</th>
                            <th>Status</th>
                            <th>Completion</th>
                            <th>Hours Spent</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Enrollment e : enrollments) { %>
                            <tr>
                                <td><strong>Course #<%= e.getCourseId() %></strong></td>
                                <td>
                                    <span style="padding: 0.25rem 0.75rem; border-radius: 4px; 
                                         background-color: <%= "completed".equals(e.getStatus()) ? "#d4edda" : "enrolled".equals(e.getStatus()) ? "#d1ecf1" : "#f8d7da" %>; 
                                         color: <%= "completed".equals(e.getStatus()) ? "#155724" : "enrolled".equals(e.getStatus()) ? "#0c5460" : "#721c24" %>;">
                                        <%= e.getStatus().toUpperCase() %>
                                    </span>
                                </td>
                                <td>
                                    <div class="progress-bar">
                                        <div class="progress-bar-fill" style="width: <%= e.getCompletionPercentage() %>%;"></div>
                                    </div>
                                    <%= df.format(e.getCompletionPercentage()) %>%
                                </td>
                                <td><%= df.format(e.getHoursSpent()) %> hrs</td>
                                <td>
                                    <a href="course-detail.jsp?enrollmentId=<%= e.getEnrollmentId() %>" class="btn btn-primary btn-sm">View</a>
                                    <% if ("completed".equals(e.getStatus())) { %>
                                        <a href="certificates.jsp?enrollmentId=<%= e.getEnrollmentId() %>" class="btn btn-secondary btn-sm">Certificate</a>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>

        <!-- Certificates Section -->
        <div class="card" style="margin-top: 2rem;">
            <h3>My Certificates</h3>
            <%
                List<Certificate> certificates = certificateDAO.getUserCertificates(userId);
            %>
            <% if (certificates.isEmpty()) { %>
                <p style="color: #666;">No certificates earned yet. Complete courses to earn certificates!</p>
            <% } else { %>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Certificate Number</th>
                            <th>Issue Date</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Certificate cert : certificates) { %>
                            <tr>
                                <td><%= cert.getCertificateNumber() %></td>
                                <td><%= cert.getIssueDate() %></td>
                                <td>
                                    <% if (cert.getCertificateUrl() != null) { %>
                                        <a href="<%= cert.getCertificateUrl() %>" target="_blank" class="btn btn-primary btn-sm">View PDF</a>
                                    <% } %>
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
</body>
</html>
