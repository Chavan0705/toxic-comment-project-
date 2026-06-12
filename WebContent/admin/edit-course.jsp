<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.learningdashboard.dao.CourseDAO, com.learningdashboard.models.Course" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Course - Admin Dashboard</title>
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
        Course course = null;
        
        String courseIdParam = request.getParameter("courseId");
        if (courseIdParam != null && !courseIdParam.isEmpty()) {
            try {
                int courseId = Integer.parseInt(courseIdParam);
                course = courseDAO.getCourseById(courseId);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }

        if (course == null) {
            response.sendRedirect("courses.jsp?error=not_found");
            return;
        }
    %>

    <div class="container" style="max-width: 800px; margin: 3rem auto; padding: 0 20px;">
        <div class="card">
            <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                <h3>Edit Course offering #<%= course.getCourseId() %></h3>
                <a href="courses.jsp" class="btn btn-secondary btn-sm" style="margin-right: 0;">Cancel</a>
            </div>

            <div id="formError" class="alert alert-error" style="display: none; margin-top: 1rem;"></div>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-error" style="margin-top: 1rem;">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <div class="card-body" style="margin-top: 1.5rem;">
                <form id="courseForm" action="../admin/courses" method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
                    
                    <div class="form-group">
                        <label for="course_title">Course Title</label>
                        <input type="text" id="course_title" name="course_title" 
                               value="<%= course.getCourseTitle() %>" placeholder="e.g. Master React and Next.js" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="platform">Learning Platform</label>
                            <select id="platform" name="platform" required>
                                <option value="coursera" <%= "coursera".equals(course.getPlatform()) ? "selected" : "" %>>Coursera</option>
                                <option value="udemy" <%= "udemy".equals(course.getPlatform()) ? "selected" : "" %>>Udemy</option>
                                <option value="edx" <%= "edx".equals(course.getPlatform()) ? "selected" : "" %>>edX</option>
                                <option value="youtube" <%= "youtube".equals(course.getPlatform()) ? "selected" : "" %>>YouTube</option>
                                <option value="linkedin" <%= "linkedin".equals(course.getPlatform()) ? "selected" : "" %>>LinkedIn</option>
                                <option value="other" <%= "other".equals(course.getPlatform()) ? "selected" : "" %>>Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="category">Category</label>
                            <input type="text" id="category" name="category" 
                                   value="<%= course.getCategory() %>" placeholder="e.g. Web Development" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="instructor_name">Instructor Name</label>
                            <input type="text" id="instructor_name" name="instructor_name" 
                                   value="<%= course.getInstructorName() != null ? course.getInstructorName() : "" %>" placeholder="e.g. John Doe">
                        </div>
                        <div class="form-group">
                            <label for="duration_hours">Duration (Hours)</label>
                            <input type="number" id="duration_hours" name="duration_hours" 
                                   value="<%= course.getDurationHours() %>" min="0" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="price">Price ($)</label>
                            <input type="number" id="price" name="price" 
                                   value="<%= course.getPrice() %>" min="0" step="0.01" required>
                        </div>
                        <div class="form-group">
                            <label for="rating">Rating (0.0 - 5.0)</label>
                            <input type="number" id="rating" name="rating" 
                                   value="<%= course.getRating() %>" min="0" max="5" step="0.1" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="course_url">Course Access URL</label>
                        <input type="url" id="course_url" name="course_url" 
                               value="<%= course.getCourseUrl() != null ? course.getCourseUrl() : "" %>" placeholder="https://example.com/course" required>
                    </div>

                    <div class="form-group">
                        <label for="thumbnail_url">Thumbnail Image URL</label>
                        <input type="url" id="thumbnail_url" name="thumbnail_url" 
                               value="<%= course.getThumbnailUrl() != null ? course.getThumbnailUrl() : "" %>" placeholder="https://example.com/image.jpg">
                    </div>

                    <div class="form-group">
                        <label for="description">Course Description</label>
                        <textarea id="description" name="description" rows="5" placeholder="Provide a detailed overview of what is covered in this course..." style="resize: vertical;"><%= course.getDescription() != null ? course.getDescription() : "" %></textarea>
                    </div>

                    <div style="margin-top: 2.5rem; display: flex; gap: 1rem;">
                        <button type="submit" class="btn btn-primary" style="flex: 1;">Save Changes</button>
                        <a href="courses.jsp" class="btn btn-secondary" style="text-align: center; text-decoration: none;">Cancel</a>
                    </div>
                </form>
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
