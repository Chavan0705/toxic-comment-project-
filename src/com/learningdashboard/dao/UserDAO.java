package com.learningdashboard.dao;

import com.learningdashboard.models.User;
import com.learningdashboard.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * UserDAO - Data Access Object for User operations
 * Handles all database operations related to users
 */
public class UserDAO {
    
    // CREATE - Register New User
    public boolean registerUser(User user) {
        String query = "INSERT INTO users (username, email, password_hash, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPasswordHash());
            pstmt.setString(4, user.getRole() != null ? user.getRole() : "student");
            
            int result = pstmt.executeUpdate();
            System.out.println("[INFO] User registered: " + user.getUsername());
            return result > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error registering user: " + e.getMessage());
            return false;
        }
    }

    // READ - Login User
    public User getUserByUsernameAndPassword(String username, String passwordHash) {
        String query = "SELECT * FROM users WHERE username = ? AND password_hash = ?";
        User user = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, passwordHash);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setActive(rs.getBoolean("is_active"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving user: " + e.getMessage());
        }
        return user;
    }

    // READ - Get User by ID
    public User getUserById(int userId) {
        String query = "SELECT * FROM users WHERE user_id = ?";
        User user = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setActive(rs.getBoolean("is_active"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving user: " + e.getMessage());
        }
        return user;
    }

    // UPDATE - Update User
    public boolean updateUser(User user) {
        String query = "UPDATE users SET username = ?, email = ?, role = ?, is_active = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getRole());
            pstmt.setBoolean(4, user.isActive());
            pstmt.setInt(5, user.getUserId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error updating user: " + e.getMessage());
            return false;
        }
    }

    // UPDATE - Change Password
    public boolean changePassword(int userId, String newPasswordHash) {
        String query = "UPDATE users SET password_hash = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, newPasswordHash);
            pstmt.setInt(2, userId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error changing password: " + e.getMessage());
            return false;
        }
    }

    // DELETE - Deactivate User
    public boolean deactivateUser(int userId) {
        String query = "UPDATE users SET is_active = FALSE WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error deactivating user: " + e.getMessage());
            return false;
        }
    }

    // READ - Get All Users (for Admin)
    public List<User> getAllUsers() {
        String query = "SELECT * FROM users ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setActive(rs.getBoolean("is_active"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                users.add(user);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving users: " + e.getMessage());
        }
        return users;
    }

    // Check if Email Exists
    public boolean emailExists(String email) {
        String query = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error checking email: " + e.getMessage());
        }
        return false;
    }

    // Check if Username Exists
    public boolean usernameExists(String username) {
        String query = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error checking username: " + e.getMessage());
        }
        return false;
    }

    // Get total user count
    public int getTotalUserCount() {
        String query = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error getting user count: " + e.getMessage());
        }
        return 0;
    }

    // Get student count
    public int getStudentCount() {
        String query = "SELECT COUNT(*) FROM users WHERE role = 'student'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error getting student count: " + e.getMessage());
        }
        return 0;
    }

    // DELETE - Physically Delete User
    public boolean deleteUser(int userId) {
        String query = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error deleting user: " + e.getMessage());
            return false;
        }
    }
}

