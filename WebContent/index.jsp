<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Learning Dashboard - Home</title>
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
                    <li><a href="register.jsp">Register</a></li>
                <% } %>
            </ul>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h2>Discover and Master New Skills</h2>
            <p>Access thousands of courses from Coursera, Udemy, edX, and YouTube in one centralized platform</p>
            <a href="courses.jsp" class="btn btn-primary">Explore Courses</a>
            <% if (session.getAttribute("userId") == null) { %>
                <a href="register.jsp" class="btn btn-secondary">Get Started Free</a>
            <% } %>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features">
        <div class="container">
            <h2>Why Choose Learning Dashboard?</h2>
            <div class="feature-grid">
                <div class="feature-card">
                    <h3>🎯 AI Recommendations</h3>
                    <p>Get personalized course recommendations based on your skills and career goals</p>
                </div>
                <div class="feature-card">
                    <h3>🌐 Multiple Platforms</h3>
                    <p>Search and compare courses from Coursera, Udemy, edX, and YouTube in one place</p>
                </div>
                <div class="feature-card">
                    <h3>📊 Progress Tracking</h3>
                    <p>Track your learning journey with detailed analytics and completion insights</p>
                </div>
                <div class="feature-card">
                    <h3>🤖 Smart Chatbot</h3>
                    <p>Get instant guidance and course recommendations from our AI assistant</p>
                </div>
                <div class="feature-card">
                    <h3>🏆 Certifications</h3>
                    <p>Earn and showcase digital certificates to boost your professional profile</p>
                </div>
                <div class="feature-card">
                    <h3>💼 Career Guidance</h3>
                    <p>Get personalized learning paths aligned with your career aspirations</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section style="background: white; padding: 3rem 0; margin: 3rem 0;">
        <div class="container">
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 2rem; text-align: center;">
                <div>
                    <h3 style="font-size: 2.5rem; color: var(--primary-color);">10,000+</h3>
                    <p>Courses Available</p>
                </div>
                <div>
                    <h3 style="font-size: 2.5rem; color: var(--primary-color);">50,000+</h3>
                    <p>Active Learners</p>
                </div>
                <div>
                    <h3 style="font-size: 2.5rem; color: var(--primary-color);">98%</h3>
                    <p>Student Satisfaction</p>
                </div>
                <div>
                    <h3 style="font-size: 2.5rem; color: var(--primary-color);">6</h3>
                    <p>Top Learning Platforms</p>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section style="background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)); color: white; padding: 4rem 2rem; text-align: center; margin: 3rem 0;">
        <div class="container">
            <h2 style="margin-bottom: 1rem;">Ready to Start Learning?</h2>
            <p style="margin-bottom: 2rem; font-size: 1.1rem;">Join thousands of students transforming their careers through online learning</p>
            <% if (session.getAttribute("userId") == null) { %>
                <a href="register.jsp" class="btn btn-secondary" style="background-color: white; color: var(--primary-color);">Sign Up Now</a>
            <% } %>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <h3>Learning Dashboard</h3>
            <p style="margin-top: 1rem;">Empowering learners through centralized course discovery and progress tracking</p>
            <p style="margin-top: 2rem; opacity: 0.8;">&copy; 2025 Learning Dashboard. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
