<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, com.learningdashboard.models.Course, com.learningdashboard.dao.CourseDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Courses - Learning Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="container">
            <a href="index.jsp" class="logo">Learning Dashboard</a>
            <ul>
                <li><a href="index.jsp">Home</a></li>
                <li><a href="courses.jsp">Courses</a></li>
                <% if (session.getAttribute("userId") != null) { %>
                    <li><a href="student/dashboard.jsp">Dashboard</a></li>
                    <li><a href="logout">Logout</a></li>
                <% } else { %>
                    <li><a href="login.jsp">Login</a></li>
                <% } %>
            </ul>
        </div>
    </nav>

    <div class="container" style="padding: 2rem 0;">
        <h1>Browse Courses</h1>

        <!-- Search Bar -->
        <div class="card" style="margin-bottom: 2rem;">
            <h3>Search Courses</h3>
            <form method="GET" action="search" style="display: grid; grid-template-columns: 1fr 1fr 1fr auto; gap: 1rem;">
                <div class="form-group" style="margin: 0;">
                    <select name="searchType" style="width: 100%; padding: 0.75rem; border: 1px solid #bdc3c7; border-radius: 8px;">
                        <option value="title">Search by Title</option>
                        <option value="category">Search by Category</option>
                        <option value="platform">Search by Platform</option>
                    </select>
                </div>
                <div class="form-group" style="margin: 0;">
                    <input type="text" name="query" placeholder="Enter search term..." style="width: 100%; padding: 0.75rem; border: 1px solid #bdc3c7; border-radius: 8px;">
                </div>
                <div style="display: flex; gap: 1rem;">
                    <button type="submit" class="btn btn-primary">Search</button>
                    <a href="courses.jsp" class="btn btn-secondary">Clear</a>
                </div>
            </form>
        </div>

        <!-- Quick Filters -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; margin-bottom: 2rem;">
            <a href="search?searchType=platform&query=udemy" class="btn" style="background-color: #ec5252; color: white; text-align: center;">Udemy</a>
            <a href="search?searchType=platform&query=coursera" class="btn" style="background-color: #0066cc; color: white; text-align: center;">Coursera</a>
            <a href="search?searchType=platform&query=edx" class="btn" style="background-color: #025be8; color: white; text-align: center;">edX</a>
            <a href="search?searchType=platform&query=youtube" class="btn" style="background-color: #ff0000; color: white; text-align: center;">YouTube</a>
        </div>

        <!-- Courses Grid -->
        <%
            CourseDAO courseDAO = new CourseDAO();
            List<Course> courses = courseDAO.getAllCourses();
        %>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <% if (courses.isEmpty()) { %>
            <div class="alert alert-info">
                <strong>No courses found.</strong> Try a different search or browse all courses.
            </div>
        <% } else { %>
            <div class="courses-grid">
                <% for (Course course : courses) { %>
                    <div class="course-card">
                        <div class="course-thumbnail">
                            <%= course.getCourseTitle().substring(0, Math.min(3, course.getCourseTitle().length())).toUpperCase() %>
                        </div>
                        <div class="course-content">
                            <h3><a href="courseDetail?courseId=<%= course.getCourseId() %>" style="color: inherit; text-decoration: none;"><%= course.getCourseTitle() %></a></h3>
                            <div class="course-meta">
                                <strong><%= course.getPlatform().toUpperCase() %></strong> • 
                                <%= course.getDurationHours() %> hours
                            </div>
                            <div class="course-rating">
                                Rating: <%= course.getRating() != null ? course.getRating() : "N/A" %>/5.0
                            </div>
                            <div class="course-price">
                                <%= course.getPrice() != null && course.getPrice().doubleValue() > 0 ? 
                                    "$" + course.getPrice() : "FREE" %>
                            </div>
                            <p style="color: #666; font-size: 0.9rem; margin-bottom: 1rem;">
                                By <%= course.getInstructorName() %>
                            </p>
                            <% if (session.getAttribute("userId") != null) { %>
                                <form method="POST" action="enrollCourse" style="margin-bottom: 0;">
                                    <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
                                    <button type="submit" class="btn btn-primary btn-block">Enroll Now</button>
                                </form>
                            <% } else { %>
                                <a href="login.jsp" class="btn btn-primary btn-block">Login to Enroll</a>
                            <% } %>
                            <a href="<%= course.getCourseUrl() %>" target="_blank" class="btn btn-secondary btn-block" style="margin-top: 0.5rem;">View Course</a>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 Learning Dashboard. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
