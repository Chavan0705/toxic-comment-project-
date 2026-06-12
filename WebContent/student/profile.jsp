<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.learningdashboard.dao.UserProfileDAO, com.learningdashboard.models.UserProfile" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Learning Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="container">
            <a href="../index.jsp" class="logo">Learning Dashboard</a>
            <ul id="navMenu">
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
        if (userId == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        UserProfileDAO profileDAO = new UserProfileDAO();
        UserProfile profile = profileDAO.getUserProfileByUserId(userId);
    %>

    <div class="container" style="max-width: 800px; margin: 3rem auto; padding: 0 20px;">
        <div class="card">
            <div class="card-header" style="text-align: center;">
                <h2>My Profile Settings</h2>
                <p style="color: #666; margin-top: 0.5rem;">Manage your public profile information</p>
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

            <div class="card-body">
                <form action="../profile" method="POST" style="margin-top: 2rem;">
                    <input type="hidden" name="userId" value="<%= userId %>">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="firstName">First Name</label>
                            <input type="text" id="firstName" name="firstName" 
                                   value="<%= profile.getFirstName() != null ? profile.getFirstName() : "" %>" 
                                   placeholder="Enter first name">
                        </div>
                        <div class="form-group">
                            <label for="lastName">Last Name</label>
                            <input type="text" id="lastName" name="lastName" 
                                   value="<%= profile.getLastName() != null ? profile.getLastName() : "" %>" 
                                   placeholder="Enter last name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="text" id="phone" name="phone" 
                               value="<%= profile.getPhone() != null ? profile.getPhone() : "" %>" 
                               placeholder="e.g. +123456789">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="city">City</label>
                            <input type="text" id="city" name="city" 
                                   value="<%= profile.getCity() != null ? profile.getCity() : "" %>" 
                                   placeholder="Enter city">
                        </div>
                        <div class="form-group">
                            <label for="country">Country</label>
                            <input type="text" id="country" name="country" 
                                   value="<%= profile.getCountry() != null ? profile.getCountry() : "" %>" 
                                   placeholder="Enter country">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="bio">Biography / About Me</label>
                        <textarea id="bio" name="bio" rows="4" placeholder="Tell us about your learning goals, skills, and background..." style="resize: vertical;"><%= profile.getBio() != null ? profile.getBio() : "" %></textarea>
                    </div>

                    <div style="margin-top: 2rem; display: flex; gap: 1rem;">
                        <button type="submit" class="btn btn-primary" style="flex: 1;">Save Changes</button>
                        <a href="dashboard.jsp" class="btn btn-secondary" style="text-align: center; text-decoration: none;">Cancel</a>
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
