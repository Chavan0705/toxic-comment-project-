<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.learningdashboard.dao.*, com.learningdashboard.models.*, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Details - Learning Dashboard</title>
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
        DecimalFormat df = new DecimalFormat("0.0");

        // Attempt to extract details set by CourseDetailServlet first
        Course course = (Course) request.getAttribute("course");
        Enrollment enrollment = (Enrollment) request.getAttribute("enrollment");
        Progress progress = (Progress) request.getAttribute("progress");

        CourseDAO courseDAO = new CourseDAO();
        EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
        ProgressDAO progressDAO = new ProgressDAO();

        String enrollmentIdParam = request.getParameter("enrollmentId");
        String courseIdParam = request.getParameter("courseId");

        // Fallback to direct parameters if not forwarded by servlet
        if (course == null && enrollmentIdParam != null && !enrollmentIdParam.isEmpty() && userId != null) {
            try {
                int enrollmentId = Integer.parseInt(enrollmentIdParam);
                enrollment = enrollmentDAO.getEnrollment(enrollmentId);
                if (enrollment != null) {
                    if (enrollment.getUserId() == userId) {
                        course = courseDAO.getCourseById(enrollment.getCourseId());
                        progress = progressDAO.getProgressByEnrollmentId(enrollmentId);
                    }
                }
            } catch (NumberFormatException e) { }
        }

        if (course == null && courseIdParam != null && !courseIdParam.isEmpty()) {
            try {
                int courseId = Integer.parseInt(courseIdParam);
                course = courseDAO.getCourseById(courseId);
                if (course != null && userId != null) {
                    enrollment = enrollmentDAO.getEnrollmentByUserAndCourse(userId, courseId);
                    if (enrollment != null) {
                        progress = progressDAO.getProgressByEnrollmentId(enrollment.getEnrollmentId());
                    }
                }
            } catch (NumberFormatException e) { }
        }

        if (course == null) {
            response.sendRedirect("../courses.jsp?error=not_found");
            return;
        }
    %>

    <div class="container" style="padding: 2rem 20px;">
        <div style="margin-bottom: 2rem;">
            <a href="dashboard.jsp" style="text-decoration: none; color: var(--primary-color); font-weight: 500;">&larr; Back to Dashboard</a>
        </div>

        <div style="display: grid; grid-template-columns: 3fr 2fr; gap: 2rem;">
            <!-- Left Side: Course Details -->
            <div>
                <div class="card" style="padding: 2.5rem;">
                    <span style="display: inline-block; padding: 0.25rem 0.75rem; background-color: var(--light-color); border-radius: 20px; font-size: 0.85rem; font-weight: 600; text-transform: uppercase; margin-bottom: 1rem; color: var(--dark-color);">
                        <%= course.getPlatform().toUpperCase() %>
                    </span>
                    <h2 style="font-size: 2rem; margin-bottom: 1rem; color: var(--dark-color);"><%= course.getCourseTitle() %></h2>
                    <p style="color: #666; font-size: 1.1rem; line-height: 1.8; margin-bottom: 2rem;">
                        <%= course.getDescription() != null ? course.getDescription() : "No description available for this course." %>
                    </p>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; border-top: 1px solid var(--light-color); padding-top: 1.5rem;">
                        <div>
                            <span style="color: #777; font-size: 0.9rem;">Instructor</span>
                            <p style="font-weight: 600; color: var(--dark-color); margin-top: 0.25rem;">
                                <%= course.getInstructorName() != null ? course.getInstructorName() : "N/A" %>
                            </p>
                        </div>
                        <div>
                            <span style="color: #777; font-size: 0.9rem;">Category</span>
                            <p style="font-weight: 600; color: var(--dark-color); margin-top: 0.25rem;">
                                <%= course.getCategory() != null ? course.getCategory() : "N/A" %>
                            </p>
                        </div>
                        <div>
                            <span style="color: #777; font-size: 0.9rem;">Duration</span>
                            <p style="font-weight: 600; color: var(--dark-color); margin-top: 0.25rem;">
                                <%= course.getDurationHours() %> hours
                            </p>
                        </div>
                        <div>
                            <span style="color: #777; font-size: 0.9rem;">Rating</span>
                            <p style="font-weight: 600; color: #f39c12; margin-top: 0.25rem;">
                                ★ <%= df.format(course.getRating()) %> / 5.0
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Side: Enrollment & Progress Control -->
            <div>
                <% if (enrollment == null) { %>
                    <!-- Not Enrolled State -->
                    <div class="card" style="padding: 2.5rem; text-align: center;">
                        <h3 style="margin-bottom: 1rem; color: var(--dark-color);">Start Your Learning Journey</h3>
                        <p style="color: #666; margin-bottom: 2rem;">Enroll in this course today and start tracking your hours, setting goals, and earning a certificate.</p>
                        
                        <div style="font-size: 2rem; font-weight: bold; color: var(--primary-color); margin-bottom: 2rem;">
                            <%= course.getPrice() == 0 ? "FREE" : "$" + df.format(course.getPrice()) %>
                        </div>

                        <% if (userId != null) { %>
                            <form action="../enrollCourse" method="POST">
                                <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
                                <button type="submit" class="btn btn-primary btn-block" style="padding: 1rem; font-size: 1.1rem;">Enroll Now</button>
                            </form>
                        <% } else { %>
                            <a href="../login.jsp" class="btn btn-primary btn-block" style="padding: 1rem; font-size: 1.1rem; text-decoration: none; display: block; margin-right: 0;">Login to Enroll</a>
                        <% } %>
                    </div>
                <% } else { %>
                    <!-- Enrolled State -->
                    <div class="card" style="padding: 2.5rem;">
                        <h3 style="margin-bottom: 1.5rem; color: var(--dark-color);">Learning Progress</h3>

                        <!-- Progress Bar Display -->
                        <div style="margin-bottom: 2rem;">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem; font-weight: 600;">
                                <span>Completion</span>
                                <span id="progressText"><%= df.format(enrollment.getCompletionPercentage()) %>%</span>
                            </div>
                            <div class="progress-bar" style="height: 12px;">
                                <div class="progress-bar-fill" id="progressBarFill" style="width: <%= enrollment.getCompletionPercentage() %>%;"></div>
                            </div>
                            <div style="display: flex; justify-content: space-between; margin-top: 0.5rem; font-size: 0.85rem; color: #666;">
                                <span>Hours Logged: <strong id="hoursLoggedText"><%= df.format(enrollment.getHoursSpent()) %> hrs</strong></span>
                                <span>Status: <strong style="text-transform: uppercase;"><%= enrollment.getStatus() %></strong></span>
                            </div>
                        </div>

                        <!-- Update Progress Form -->
                        <div id="toastMessage" class="alert alert-success" style="display: none; padding: 0.75rem; font-size: 0.9rem;"></div>

                        <form id="progressForm" style="border-top: 1px solid var(--light-color); padding-top: 1.5rem;">
                            <input type="hidden" name="enrollmentId" id="enrollmentId" value="<%= enrollment.getEnrollmentId() %>">
                            
                            <div class="form-group">
                                <label for="completionInput">Update Completion %</label>
                                <input type="number" id="completionInput" name="completion" min="0" max="100" step="1" 
                                       value="<%= (int)enrollment.getCompletionPercentage() %>" required>
                            </div>

                            <div class="form-group">
                                <label for="hoursInput">Add Learning Hours (today)</label>
                                <input type="number" id="hoursInput" name="hours" min="0" step="0.5" placeholder="e.g. 1.5" required>
                            </div>

                            <div class="form-group">
                                <label for="notesInput">Study Notes / Logs</label>
                                <textarea id="notesInput" name="notes" rows="3" placeholder="What did you learn today?..." style="resize: vertical;"><%= (progress != null && progress.getNotes() != null) ? progress.getNotes() : "" %></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary btn-block">Log Progress</button>
                        </form>

                        <% if ("completed".equals(enrollment.getStatus())) { %>
                            <div style="margin-top: 1.5rem; border-top: 1px dashed var(--border-color); padding-top: 1.5rem; text-align: center;">
                                <span style="font-size: 1.5rem;">🏆</span>
                                <h4 style="margin: 0.5rem 0; color: var(--dark-color);">Course Completed!</h4>
                                <a href="certificates.jsp?enrollmentId=<%= enrollment.getEnrollmentId() %>" class="btn btn-secondary btn-sm" style="margin-top: 0.5rem;">View Certificate</a>
                            </div>
                        <% } %>
                    </div>
                <% } %>
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
    <script>
        // Inline script to handle AJAX updates for progress
        const progressForm = document.getElementById("progressForm");
        if (progressForm) {
            progressForm.addEventListener("submit", function(e) {
                e.preventDefault();
                
                const enrollmentId = document.getElementById("enrollmentId").value;
                const completion = document.getElementById("completionInput").value;
                const hours = document.getElementById("hoursInput").value;
                const notes = document.getElementById("notesInput").value;

                const params = new URLSearchParams();
                params.append("enrollmentId", enrollmentId);
                params.append("completion", completion);
                params.append("hours", hours);
                params.append("notes", notes);

                const toast = document.getElementById("toastMessage");

                fetch("../updateProgress", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: params
                })
                .then(response => {
                    if (response.ok) {
                        toast.className = "alert alert-success";
                        toast.innerText = "✓ Progress updated successfully!";
                        toast.style.display = "block";
                        
                        // Update UI values locally
                        document.getElementById("progressText").innerText = parseFloat(completion).toFixed(1) + "%";
                        document.getElementById("progressBarFill").style.width = completion + "%";
                        document.getElementById("hoursInput").value = ""; // Reset hours input
                        
                        setTimeout(() => {
                            window.location.reload(); // Reload to fetch fresh DB details and certificates
                        }, 1000);
                    } else {
                        response.text().then(text => {
                            toast.className = "alert alert-error";
                            toast.innerText = "❌ Error: " + text;
                            toast.style.display = "block";
                        });
                    }
                })
                .catch(err => {
                    toast.className = "alert alert-error";
                    toast.innerText = "❌ Network connection error.";
                    toast.style.display = "block";
                });
            });
        }
    </script>
</body>
</html>
