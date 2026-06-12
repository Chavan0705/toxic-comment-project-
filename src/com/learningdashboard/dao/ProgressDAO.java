package com.learningdashboard.dao;

import com.learningdashboard.models.Progress;
import com.learningdashboard.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ProgressDAO - Data Access Object for Progress tracking operations
 * Handles all database operations related to user progress
 */
public class ProgressDAO {
    
    // CREATE - Create Progress Record for Enrollment
    public boolean createProgress(int enrollmentId) {
        String query = "INSERT INTO progress (enrollment_id, completion_percentage, hours_spent) " +
                       "VALUES (?, 0, 0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, enrollmentId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error creating progress: " + e.getMessage());
            return false;
        }
    }

    // READ - Get Progress by Enrollment ID
    public Progress getProgressByEnrollmentId(int enrollmentId) {
        String query = "SELECT * FROM progress WHERE enrollment_id = ?";
        Progress progress = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, enrollmentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                progress = mapResultSetToProgress(rs);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving progress: " + e.getMessage());
        }
        return progress;
    }

    // READ - Get Progress by ID
    public Progress getProgressById(int progressId) {
        String query = "SELECT * FROM progress WHERE progress_id = ?";
        Progress progress = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, progressId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                progress = mapResultSetToProgress(rs);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving progress: " + e.getMessage());
        }
        return progress;
    }

    // READ - Get User's Progress Records
    public List<Progress> getUserProgressRecords(int userId) {
        String query = "SELECT p.* FROM progress p " +
                       "JOIN enrollments e ON p.enrollment_id = e.enrollment_id " +
                       "WHERE e.user_id = ?";
        List<Progress> progressList = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                progressList.add(mapResultSetToProgress(rs));
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving user progress: " + e.getMessage());
        }
        return progressList;
    }

    // UPDATE - Update Progress Percentage
    public boolean updateCompletionPercentage(int enrollmentId, double percentage) {
        String query = "UPDATE progress SET completion_percentage = ?, last_accessed = NOW() " +
                       "WHERE enrollment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setDouble(1, Math.min(percentage, 100.0));
            pstmt.setInt(2, enrollmentId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error updating completion percentage: " + e.getMessage());
            return false;
        }
    }

    // UPDATE - Update Hours Spent
    public boolean updateHoursSpent(int enrollmentId, double hours) {
        String query = "UPDATE progress SET hours_spent = hours_spent + ?, last_accessed = NOW() " +
                       "WHERE enrollment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setDouble(1, hours);
            pstmt.setInt(2, enrollmentId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error updating hours spent: " + e.getMessage());
            return false;
        }
    }

    // UPDATE - Add Notes to Progress
    public boolean addNotes(int enrollmentId, String notes) {
        String query = "UPDATE progress SET notes = ? WHERE enrollment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, notes);
            pstmt.setInt(2, enrollmentId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error adding notes: " + e.getMessage());
            return false;
        }
    }

    // UPDATE - Bulk Update Progress
    public boolean updateProgress(Progress progress) {
        String query = "UPDATE progress SET completion_percentage = ?, hours_spent = ?, " +
                       "notes = ?, last_accessed = NOW() WHERE progress_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setDouble(1, progress.getCompletionPercentage());
            pstmt.setDouble(2, progress.getHoursSpent());
            pstmt.setString(3, progress.getNotes());
            pstmt.setInt(4, progress.getProgressId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error updating progress: " + e.getMessage());
            return false;
        }
    }

    // DELETE - Delete Progress Record
    public boolean deleteProgress(int progressId) {
        String query = "DELETE FROM progress WHERE progress_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, progressId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error deleting progress: " + e.getMessage());
            return false;
        }
    }

    // Get average completion percentage for user
    public double getAverageCompletionPercentage(int userId) {
        String query = "SELECT AVG(p.completion_percentage) FROM progress p " +
                       "JOIN enrollments e ON p.enrollment_id = e.enrollment_id " +
                       "WHERE e.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                double avg = rs.getDouble(1);
                return Double.isNaN(avg) ? 0 : avg;
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error getting average completion: " + e.getMessage());
        }
        return 0;
    }

    // Helper method to map ResultSet to Progress
    private Progress mapResultSetToProgress(ResultSet rs) throws SQLException {
        Progress progress = new Progress();
        progress.setProgressId(rs.getInt("progress_id"));
        progress.setEnrollmentId(rs.getInt("enrollment_id"));
        progress.setCompletionPercentage(rs.getDouble("completion_percentage"));
        progress.setLastAccessed(rs.getTimestamp("last_accessed"));
        progress.setHoursSpent(rs.getDouble("hours_spent"));
        progress.setNotes(rs.getString("notes"));
        return progress;
    }
}

