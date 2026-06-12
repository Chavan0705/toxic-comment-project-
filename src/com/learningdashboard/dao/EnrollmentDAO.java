package com.learningdashboard.dao;

import com.learningdashboard.models.Enrollment;
import com.learningdashboard.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * EnrollmentDAO - Data Access Object for Enrollment operations
 * Handles all database operations related to user enrollments
 */
public class EnrollmentDAO {
    
    // CREATE - Enroll User in Course
    public boolean enrollCourse(int userId, int courseId) {
        String query = "INSERT INTO enrollments (user_id, course_id, status) VALUES (?, ?, 'enrolled')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, courseId);
            
            int result = pstmt.executeUpdate();
            System.out.println("[INFO] User enrolled in course. User: " + userId + ", Course: " + courseId);
            return result > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error enrolling course: " + e.getMessage());
            return false;
        }
    }

    // READ - Get User's Enrollments
    public List<Enrollment> getUserEnrollments(int userId) {
        String query = "SELECT * FROM enrollments WHERE user_id = ? ORDER BY enrollment_date DESC";
        List<Enrollment> enrollments = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Enrollment enrollment = mapResultSetToEnrollment(rs);
                enrollments.add(enrollment);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving enrollments: " + e.getMessage());
        }
        return enrollments;
    }

    // READ - Get Course's Enrollments
    public List<Enrollment> getCourseEnrollments(int courseId) {
        String query = "SELECT * FROM enrollments WHERE course_id = ? ORDER BY enrollment_date DESC";
        List<Enrollment> enrollments = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, courseId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                enrollments.add(mapResultSetToEnrollment(rs));
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving course enrollments: " + e.getMessage());
        }
        return enrollments;
    }

    // READ - Get Single Enrollment
    public Enrollment getEnrollment(int enrollmentId) {
        String query = "SELECT * FROM enrollments WHERE enrollment_id = ?";
        Enrollment enrollment = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, enrollmentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                enrollment = mapResultSetToEnrollment(rs);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving enrollment: " + e.getMessage());
        }
        return enrollment;
    }

    // UPDATE - Update Enrollment Status
    public boolean updateEnrollmentStatus(int enrollmentId, String status) {
        String query = "UPDATE enrollments SET status = ? WHERE enrollment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, enrollmentId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error updating enrollment: " + e.getMessage());
            return false;
        }
    }

    // UPDATE - Update Progress
    public boolean updateProgress(int enrollmentId, double completionPercentage, double hoursSpent) {
        String query = "UPDATE enrollments SET completion_percentage = ?, " +
                       "hours_spent = ?, last_accessed = NOW() WHERE enrollment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setDouble(1, completionPercentage);
            pstmt.setDouble(2, hoursSpent);
            pstmt.setInt(3, enrollmentId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error updating progress: " + e.getMessage());
            return false;
        }
    }

    // DELETE - Remove Enrollment
    public boolean removeEnrollment(int enrollmentId) {
        String query = "DELETE FROM enrollments WHERE enrollment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, enrollmentId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error removing enrollment: " + e.getMessage());
            return false;
        }
    }

    // Get enrollment count for user
    public int getUserEnrollmentCount(int userId) {
        String query = "SELECT COUNT(*) FROM enrollments WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error getting user enrollment count: " + e.getMessage());
        }
        return 0;
    }

    // Get completed courses for user
    public int getCompletedCoursesCount(int userId) {
        String query = "SELECT COUNT(*) FROM enrollments WHERE user_id = ? AND status = 'completed'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error getting completed courses: " + e.getMessage());
        }
        return 0;
    }

    // Get in-progress courses for user
    public int getInProgressCoursesCount(int userId) {
        String query = "SELECT COUNT(*) FROM enrollments WHERE user_id = ? AND status = 'enrolled'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error getting in-progress courses: " + e.getMessage());
        }
        return 0;
    }

    // Get total hours spent by user
    public double getTotalHoursSpent(int userId) {
        String query = "SELECT SUM(hours_spent) FROM enrollments WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error getting total hours: " + e.getMessage());
        }
        return 0;
    }

    // Check if user is already enrolled
    public boolean isAlreadyEnrolled(int userId, int courseId) {
        String query = "SELECT COUNT(*) FROM enrollments WHERE user_id = ? AND course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, courseId);
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error checking enrollment: " + e.getMessage());
        }
        return false;
    }

    // Get enrollment by user and course
    public Enrollment getEnrollmentByUserAndCourse(int userId, int courseId) {
        String query = "SELECT * FROM enrollments WHERE user_id = ? AND course_id = ?";
        Enrollment enrollment = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, courseId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    enrollment = mapResultSetToEnrollment(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving enrollment by user and course: " + e.getMessage());
        }
        return enrollment;
    }

    // Get system-wide enrollment count
    public int getSystemEnrollmentCount() {
        String query = "SELECT COUNT(*) FROM enrollments";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error getting system enrollment count: " + e.getMessage());
        }
        return 0;
    }

    // Get system-wide completed enrollment count
    public int getSystemCompletedCount() {
        String query = "SELECT COUNT(*) FROM enrollments WHERE status = 'completed'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error getting system completed count: " + e.getMessage());
        }
        return 0;
    }

    // Get system-wide average completion percentage
    public double getSystemAverageCompletionPercentage() {
        String query = "SELECT AVG(completion_percentage) FROM enrollments";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) {
                double avg = rs.getDouble(1);
                return Double.isNaN(avg) ? 0.0 : avg;
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error getting system average completion: " + e.getMessage());
        }
        return 0.0;
    }

    // Helper method to map ResultSet to Enrollment
    private Enrollment mapResultSetToEnrollment(ResultSet rs) throws SQLException {
        Enrollment enrollment = new Enrollment();
        enrollment.setEnrollmentId(rs.getInt("enrollment_id"));
        enrollment.setUserId(rs.getInt("user_id"));
        enrollment.setCourseId(rs.getInt("course_id"));
        enrollment.setEnrollmentDate(rs.getTimestamp("enrollment_date"));
        enrollment.setStatus(rs.getString("status"));
        enrollment.setCompletionPercentage(rs.getDouble("completion_percentage"));
        enrollment.setHoursSpent(rs.getDouble("hours_spent"));
        enrollment.setLastAccessed(rs.getTimestamp("last_accessed"));
        return enrollment;
    }
}

