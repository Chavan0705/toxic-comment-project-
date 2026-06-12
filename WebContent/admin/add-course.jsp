<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Course - Admin Dashboard</title>
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
    %>

    <div class="container" style="max-width: 800px; margin: 3rem auto; padding: 0 20px;">
        <div class="card">
            <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                <h3>Add New Course Offering</h3>
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
                    <input type="hidden" name="action" value="add">
                    
                    <div class="form-group">
                        <label for="course_title">Course Title</label>
                        <input type="text" id="course_title" name="course_title" placeholder="e.g. Master React and Next.js" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="platform">Learning Platform</label>
                            <select id="platform" name="platform" required>
                                <option value="coursera">Coursera</option>
                                <option value="udemy">Udemy</option>
                                <option value="edx">edX</option>
                                <option value="youtube">YouTube</option>
                                <option value="linkedin">LinkedIn</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="category">Category</label>
                            <input type="text" id="category" name="category" placeholder="e.g. Web Development" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="instructor_name">Instructor Name</label>
                            <input type="text" id="instructor_name" name="instructor_name" placeholder="e.g. John Doe">
                        </div>
                        <div class="form-group">
                            <label for="duration_hours">Duration (Hours)</label>
                            <input type="number" id="duration_hours" name="duration_hours" min="0" value="0" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="price">Price ($)</label>
                            <input type="number" id="price" name="price" min="0" step="0.01" value="0.00" required>
                            <span style="font-size: 0.85rem; color: #777;">Set to 0.00 for free courses</span>
                        </div>
                        <div class="form-group">
                            <label for="rating">Initial Rating (0.0 - 5.0)</label>
                            <input type="number" id="rating" name="rating" min="0" max="5" step="0.1" value="0.0" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="course_url">Course Access URL</label>
                        <input type="url" id="course_url" name="course_url" placeholder="https://example.com/course" required>
                    </div>

                    <div class="form-group">
                        <label for="thumbnail_url">Thumbnail Image URL</label>
                        <input type="url" id="thumbnail_url" name="thumbnail_url" placeholder="https://example.com/image.jpg">
                    </div>

                    <div class="form-group">
                        <label for="description">Course Description</label>
                        <textarea id="description" name="description" rows="5" placeholder="Provide a detailed overview of what is covered in this course..." style="resize: vertical;"></textarea>
                    </div>

                    <div style="margin-top: 2.5rem; display: flex; gap: 1rem;">
                        <button type="submit" class="btn btn-primary" style="flex: 1;">Create Course</button>
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
