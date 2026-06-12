<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.learningdashboard.dao.*, com.learningdashboard.models.*, java.util.List, java.text.DecimalFormat, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Student Details - Admin Dashboard</title>
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
        Integer adminUserId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        if (adminUserId == null || !"admin".equals(role)) {
            response.sendRedirect("../login.jsp");
            return;
        }

        UserDAO userDAO = new UserDAO();
        UserProfileDAO profileDAO = new UserProfileDAO();
        EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
        CourseDAO courseDAO = new CourseDAO();
        
        User user = null;
        UserProfile profile = null;
        List<Enrollment> enrollments = null;
        
        String userIdParam = request.getParameter("userId");
        if (userIdParam != null && !userIdParam.isEmpty()) {
            try {
                int targetUserId = Integer.parseInt(userIdParam);
                user = userDAO.getUserById(targetUserId);
                if (user != null) {
                    profile = profileDAO.getUserProfileByUserId(targetUserId);
                    enrollments = enrollmentDAO.getUserEnrollments(targetUserId);
                }
            } catch (NumberFormatException e) {
                // Ignore
            }
        }

        if (user == null) {
            response.sendRedirect("users.jsp?error=user_not_found");
            return;
        }

        DecimalFormat df = new DecimalFormat("0.0");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    %>

    <div class="container dashboard">
        <div style="margin-bottom: 2rem; display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h2>User Profile Details</h2>
                <p style="color: #666; margin-top: 0.25rem;">Detailed view for account: <strong><%= user.getUsername() %></strong></p>
            </div>
            <a href="users.jsp" class="btn btn-secondary" style="margin-right: 0;">&larr; Back to Users</a>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 2rem;">
            <!-- Left Side: Profile Information Card -->
            <div>
                <div class="card" style="padding: 2rem;">
                    <div style="text-align: center; margin-bottom: 1.5rem;">
                        <div style="width: 100px; height: 100px; border-radius: 50%; background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)); display: flex; align-items: center; justify-content: center; color: white; font-size: 3rem; font-weight: bold; margin: 0 auto 1rem auto;">
                            <%= user.getUsername().substring(0, 1).toUpperCase() %>
                        </div>
                        <h3 style="margin: 0; color: var(--dark-color);"><%= user.getUsername() %></h3>
                        <span style="font-size: 0.85rem; font-weight: 600; text-transform: uppercase; color: #777;"><%= user.getRole() %></span>
                    </div>

                    <div style="border-top: 1px solid var(--light-color); padding-top: 1.5rem;">
                        <span style="color: #777; font-size: 0.85rem; display: block;">Full Name</span>
                        <p style="font-weight: 600; color: var(--dark-color); margin-bottom: 1rem;">
                            <%= (profile != null && profile.getFullName().trim().length() > 0) ? profile.getFullName() : "Not Provided" %>
                        </p>

                        <span style="color: #777; font-size: 0.85rem; display: block;">Email Address</span>
                        <p style="font-weight: 600; color: var(--dark-color); margin-bottom: 1rem;"><%= user.getEmail() %></p>

                        <span style="color: #777; font-size: 0.85rem; display: block;">Phone Number</span>
                        <p style="font-weight: 600; color: var(--dark-color); margin-bottom: 1rem;">
                            <%= (profile != null && profile.getPhone() != null && profile.getPhone().length() > 0) ? profile.getPhone() : "Not Provided" %>
                        </p>

                        <span style="color: #777; font-size: 0.85rem; display: block;">Location</span>
                        <p style="font-weight: 600; color: var(--dark-color); margin-bottom: 1rem;">
                            <% if (profile != null && (profile.getCity().length() > 0 || profile.getCountry().length() > 0)) { %>
                                <%= profile.getCity() %>, <%= profile.getCountry() %>
                            <% } else { %>
                                Not Provided
                            <% } %>
                        </p>

                        <span style="color: #777; font-size: 0.85rem; display: block;">Joined On</span>
                        <p style="font-weight: 600; color: var(--dark-color); margin-bottom: 1rem;">
                            <%= user.getCreatedAt() != null ? sdf.format(user.getCreatedAt()) : "N/A" %>
                        </p>

                        <span style="color: #777; font-size: 0.85rem; display: block;">Biography</span>
                        <p style="color: #555; line-height: 1.5; font-size: 0.95rem;">
                            <%= (profile != null && profile.getBio() != null && profile.getBio().length() > 0) ? profile.getBio() : "No bio provided yet." %>
                        </p>
                    </div>
                </div>
            </div>

            <!-- Right Side: Course Enrolled & Progress Logs -->
            <div>
                <div class="card" style="padding: 2rem;">
                    <h3>Syllabus Enrolled & Study Metrics</h3>
                    
                    <% if (enrollments == null || enrollments.isEmpty()) { %>
                        <p style="color: #777; padding: 2rem 0; text-align: center;">This user is not enrolled in any courses yet.</p>
                    <% } else { %>
                        <table class="table" style="margin-top: 1.5rem;">
                            <thead>
                                <tr>
                                    <th>Course Title</th>
                                    <th>Platform</th>
                                    <th>Status</th>
                                    <th>Syllabus Completion</th>
                                    <th>Hours Spent</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Enrollment e : enrollments) { 
                                    Course c = courseDAO.getCourseById(e.getCourseId());
                                %>
                                    <tr>
                                        <td><strong><%= (c != null) ? c.getCourseTitle() : "Course #" + e.getCourseId() %></strong></td>
                                        <td>
                                            <span style="text-transform: uppercase; font-size: 0.8rem;"><%= (c != null) ? c.getPlatform() : "N/A" %></span>
                                        </td>
                                        <td>
                                            <span style="padding: 0.25rem 0.5rem; border-radius: 4px; font-weight: bold; font-size: 0.8rem;
                                                 background-color: <%= "completed".equals(e.getStatus()) ? "#d4edda" : "enrolled".equals(e.getStatus()) ? "#d1ecf1" : "#f8d7da" %>; 
                                                 color: <%= "completed".equals(e.getStatus()) ? "#155724" : "enrolled".equals(e.getStatus()) ? "#0c5460" : "#721c24" %>;">
                                                <%= e.getStatus().toUpperCase() %>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="progress-bar" style="margin-bottom: 0.25rem;">
                                                <div class="progress-bar-fill" style="width: <%= e.getCompletionPercentage() %>%;"></div>
                                            </div>
                                            <%= df.format(e.getCompletionPercentage()) %>%
                                        </td>
                                        <td><%= df.format(e.getHoursSpent()) %> hrs</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
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
