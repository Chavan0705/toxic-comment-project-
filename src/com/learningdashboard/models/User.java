package com.learningdashboard.models;

import java.sql.Timestamp;

/**
 * User Model Class - Represents a user in the Learning Dashboard system
 */
public class User {
    private int userId;
    private String username;
    private String email;
    private String passwordHash;
    private String role; // 'student' or 'admin'
    private Timestamp createdAt;
    private boolean isActive;

    public User() {}

    public User(String username, String email, String passwordHash, String role) {
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.isActive = true;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    @Override
    public String toString() {
        return "User{userId=" + userId + ", username='" + username + "', role='" + role + "'}";
    }
}

