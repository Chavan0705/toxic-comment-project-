<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Learning Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <h2>Welcome Back</h2>
            
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

            <form method="POST" action="login">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required autofocus>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block">Login</button>
            </form>

            <div style="text-align: center; margin-top: 2rem;">
                <p>Don't have an account? <a href="register.jsp">Register here</a></p>
                <p><a href="index.jsp">Back to Home</a></p>
            </div>

            <div style="background-color: #f9f9f9; padding: 1rem; border-radius: 8px; margin-top: 2rem; font-size: 0.9rem;">
                <strong>Demo Credentials:</strong>
                <p>Username: <code>student1</code></p>
                <p>Password: <code>Demo@1234</code></p>
                <p><strong>Or</strong> Username: <code>admin</code> Password: <code>Admin@1234</code></p>
            </div>
        </div>
    </div>
</body>
</html>
