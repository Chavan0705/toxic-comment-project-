<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Learning Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="register-container">
        <div class="register-box">
            <h2>Create Account</h2>
            
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

            <form method="POST" action="register">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required autofocus 
                           minlength="3" maxlength="50" placeholder="Choose a username (3-50 chars)">
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required placeholder="your@email.com">
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required 
                           minlength="8" placeholder="At least 8 characters">
                    <small style="color: #666; display: block; margin-top: 0.3rem;">
                        Must contain: uppercase, lowercase, and numbers
                    </small>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Re-enter password">
                </div>

                <button type="submit" class="btn btn-primary btn-block">Create Account</button>
            </form>

            <div style="text-align: center; margin-top: 2rem;">
                <p>Already have an account? <a href="login.jsp">Login here</a></p>
                <p><a href="index.jsp">Back to Home</a></p>
            </div>
        </div>
    </div>
</body>
</html>
