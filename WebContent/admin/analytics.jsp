<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.learningdashboard.dao.*, com.learningdashboard.models.*, java.util.*, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Analytics - Admin Dashboard</title>
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
        CourseDAO courseDAO = new CourseDAO();
        EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
        CertificateDAO certificateDAO = new CertificateDAO();

        int totalUsers = userDAO.getTotalUserCount();
        int studentCount = userDAO.getStudentCount();
        int adminCount = totalUsers - studentCount;
        int totalCourses = courseDAO.getTotalCourseCount();
        int totalEnrollments = enrollmentDAO.getSystemEnrollmentCount();
        int completedCount = enrollmentDAO.getSystemCompletedCount();
        int activeEnrollments = totalEnrollments - completedCount;
        double avgCompletion = enrollmentDAO.getSystemAverageCompletionPercentage();
        int totalCertificates = certificateDAO.getTotalCertificateCount();
        
        DecimalFormat df = new DecimalFormat("0.0");
        DecimalFormat dfPercent = new DecimalFormat("0.0%");

        List<Course> allCourses = courseDAO.getAllCourses();
        
        // Sort by rating desc
        List<Course> topRatedCourses = new ArrayList<>(allCourses);
        topRatedCourses.sort((c1, c2) -> Double.compare(c2.getRating(), c1.getRating()));

        // Sort by price desc (just for comparison/insights)
        List<Course> premiumCourses = new ArrayList<>(allCourses);
        premiumCourses.sort((c1, c2) -> Double.compare(c2.getPrice(), c1.getPrice()));
    %>

    <div class="container dashboard">
        <div style="margin-bottom: 2rem; display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h2>System Analytics & Insights</h2>
                <p style="color: #666; margin-top: 0.25rem;">Real-time metrics on users, course engagement, and completions</p>
            </div>
            <a href="dashboard.jsp" class="btn btn-secondary" style="margin-right: 0;">&larr; Back to Dashboard</a>
        </div>

        <!-- System Aggregations Row -->
        <div class="dashboard-cards">
            <div class="stat-card">
                <h3>Students Enrolled</h3>
                <div class="stat-value"><%= studentCount %></div>
                <p>Registered learners</p>
            </div>
            <div class="stat-card">
                <h3>Total Courses</h3>
                <div class="stat-value"><%= totalCourses %></div>
                <p>Active course catalog size</p>
            </div>
            <div class="stat-card">
                <h3>System Enrollments</h3>
                <div class="stat-value"><%= totalEnrollments %></div>
                <p>Course selections made</p>
            </div>
            <div class="stat-card">
                <h3>Completion Rate</h3>
                <div class="stat-value"><%= df.format(avgCompletion) %>%</div>
                <p>Average syllabus progress</p>
            </div>
            <div class="stat-card">
                <h3>Certificates Issued</h3>
                <div class="stat-value"><%= totalCertificates %></div>
                <p>Completed course credentials</p>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-top: 3rem;">
            <!-- Left Side: Top Rated -->
            <div class="card">
                <h3>Top Rated Courses</h3>
                <p style="color: #666; margin-bottom: 1.5rem;">Highest rated course aggregates according to students</p>
                <% if (topRatedCourses.isEmpty()) { %>
                    <p style="color: #777;">No courses registered yet.</p>
                <% } else { %>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Platform</th>
                                <th>Rating</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                int limit = Math.min(topRatedCourses.size(), 5);
                                for (int i = 0; i < limit; i++) {
                                    Course c = topRatedCourses.get(i);
                            %>
                                <tr>
                                    <td><strong><%= c.getCourseTitle() %></strong></td>
                                    <td><span style="text-transform: uppercase; font-size: 0.8rem;"><%= c.getPlatform() %></span></td>
                                    <td style="color: #f39c12; font-weight: bold;">★ <%= df.format(c.getRating()) %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>

            <!-- Right Side: Course Prices & Financial Structure -->
            <div class="card">
                <h3>Course Price Matrix</h3>
                <p style="color: #666; margin-bottom: 1.5rem;">Highest cost resources currently loaded in catalog</p>
                <% if (premiumCourses.isEmpty()) { %>
                    <p style="color: #777;">No courses registered yet.</p>
                <% } else { %>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Platform</th>
                                <th>Price</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                int limit = Math.min(premiumCourses.size(), 5);
                                for (int i = 0; i < limit; i++) {
                                    Course c = premiumCourses.get(i);
                            %>
                                <tr>
                                    <td><strong><%= c.getCourseTitle() %></strong></td>
                                    <td><span style="text-transform: uppercase; font-size: 0.8rem;"><%= c.getPlatform() %></span></td>
                                    <td style="color: var(--primary-color); font-weight: bold;">
                                        <%= c.getPrice() == 0 ? "Free" : "$" + df.format(c.getPrice()) %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
        </div>

        <!-- Enrollment Details Card -->
        <div class="card" style="margin-top: 2rem;">
            <h3>Course Engagement Breakdown</h3>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 2rem; margin-top: 1.5rem; text-align: center;">
                <div style="background-color: var(--light-color); padding: 1.5rem; border-radius: var(--radius);">
                    <h4 style="color: #555; margin-bottom: 0.5rem;">Completed Enrollments</h4>
                    <span style="font-size: 2rem; font-weight: bold; color: var(--success-color);"><%= completedCount %></span>
                    <p style="font-size: 0.85rem; color: #777; margin-top: 0.25rem;">
                        <%= (totalEnrollments > 0) ? dfPercent.format((double)completedCount / totalEnrollments) : "0%" %> of total
                    </p>
                </div>
                <div style="background-color: var(--light-color); padding: 1.5rem; border-radius: var(--radius);">
                    <h4 style="color: #555; margin-bottom: 0.5rem;">In Progress (Active)</h4>
                    <span style="font-size: 2rem; font-weight: bold; color: var(--info-color);"><%= activeEnrollments %></span>
                    <p style="font-size: 0.85rem; color: #777; margin-top: 0.25rem;">
                        <%= (totalEnrollments > 0) ? dfPercent.format((double)activeEnrollments / totalEnrollments) : "0%" %> of total
                    </p>
                </div>
                <div style="background-color: var(--light-color); padding: 1.5rem; border-radius: var(--radius);">
                    <h4 style="color: #555; margin-bottom: 0.5rem;">Average Duration</h4>
                    <%
                        double totalCourseHours = 0;
                        for (Course c : allCourses) {
                            totalCourseHours += c.getDurationHours();
                        }
                        double avgHours = allCourses.isEmpty() ? 0 : totalCourseHours / allCourses.size();
                    %>
                    <span style="font-size: 2rem; font-weight: bold; color: var(--secondary-color);"><%= df.format(avgHours) %> hrs</span>
                    <p style="font-size: 0.85rem; color: #777; margin-top: 0.25rem;">Per course in catalog</p>
                </div>
            </div>
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
