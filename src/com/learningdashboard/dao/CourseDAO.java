package com.learningdashboard.dao;

import com.learningdashboard.models.Course;
import com.learningdashboard.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CourseDAO - Data Access Object for Course operations
 * Handles all database operations related to courses
 */
public class CourseDAO {
    
    // CREATE - Add New Course
    public boolean addCourse(Course course) {
        String query = "INSERT INTO courses (course_title, description, platform, category, " +
                       "instructor_name, duration_hours, rating, price, course_url, thumbnail_url) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, course.getCourseTitle());
            pstmt.setString(2, course.getDescription());
            pstmt.setString(3, course.getPlatform());
            pstmt.setString(4, course.getCategory());
            pstmt.setString(5, course.getInstructorName());
            pstmt.setInt(6, course.getDurationHours());
            pstmt.setBigDecimal(7, course.getRating());
            pstmt.setBigDecimal(8, course.getPrice());
            pstmt.setString(9, course.getCourseUrl());
            pstmt.setString(10, course.getThumbnailUrl());
            
            int result = pstmt.executeUpdate();
            System.out.println("[INFO] Course added: " + course.getCourseTitle());
            return result > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error adding course: " + e.getMessage());
            return false;
        }
    }

    // READ - Get Course by ID
    public Course getCourseById(int courseId) {
        String query = "SELECT * FROM courses WHERE course_id = ?";
        Course course = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, courseId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                course = mapResultSetToCourse(rs);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving course: " + e.getMessage());
        }
        return course;
    }

    // READ - Get All Courses
    public List<Course> getAllCourses() {
        String query = "SELECT * FROM courses ORDER BY created_at DESC";
        List<Course> courses = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving courses: " + e.getMessage());
        }
        return courses;
    }

    // READ - Search Courses by Category
    public List<Course> searchCoursesByCategory(String category) {
        String query = "SELECT * FROM courses WHERE category LIKE ? ORDER BY rating DESC";
        List<Course> courses = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, "%" + category + "%");
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error searching courses: " + e.getMessage());
        }
        return courses;
    }

    // READ - Search Courses by Platform
    public List<Course> searchCoursesByPlatform(String platform) {
        String query = "SELECT * FROM courses WHERE platform = ? ORDER BY rating DESC";
        List<Course> courses = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, platform);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error searching courses: " + e.getMessage());
        }
        return courses;
    }

    // READ - Search Courses by Title
    public List<Course> searchCoursesByTitle(String title) {
        String query = "SELECT * FROM courses WHERE course_title LIKE ? ORDER BY rating DESC";
        List<Course> courses = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, "%" + title + "%");
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error searching courses: " + e.getMessage());
        }
        return courses;
    }

    // UPDATE - Update Course
    public boolean updateCourse(Course course) {
        String query = "UPDATE courses SET course_title = ?, description = ?, category = ?, " +
                       "rating = ?, price = ?, instructor_name = ? WHERE course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, course.getCourseTitle());
            pstmt.setString(2, course.getDescription());
            pstmt.setString(3, course.getCategory());
            pstmt.setBigDecimal(4, course.getRating());
            pstmt.setBigDecimal(5, course.getPrice());
            pstmt.setString(6, course.getInstructorName());
            pstmt.setInt(7, course.getCourseId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error updating course: " + e.getMessage());
            return false;
        }
    }

    // DELETE - Delete Course
    public boolean deleteCourse(int courseId) {
        String query = "DELETE FROM courses WHERE course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, courseId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error deleting course: " + e.getMessage());
            return false;
        }
    }

    // Get total course count
    public int getTotalCourseCount() {
        String query = "SELECT COUNT(*) FROM courses";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error getting course count: " + e.getMessage());
        }
        return 0;
    }

    // Get courses by category count
    public int getCourseCountByCategory(String category) {
        String query = "SELECT COUNT(*) FROM courses WHERE category = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, category);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error getting category course count: " + e.getMessage());
        }
        return 0;
    }

    // Helper method to map ResultSet to Course
    private Course mapResultSetToCourse(ResultSet rs) throws SQLException {
        Course course = new Course();
        course.setCourseId(rs.getInt("course_id"));
        course.setCourseTitle(rs.getString("course_title"));
        course.setDescription(rs.getString("description"));
        course.setPlatform(rs.getString("platform"));
        course.setCategory(rs.getString("category"));
        course.setInstructorName(rs.getString("instructor_name"));
        course.setDurationHours(rs.getInt("duration_hours"));
        course.setRating(rs.getBigDecimal("rating"));
        course.setPrice(rs.getBigDecimal("price"));
        course.setCourseUrl(rs.getString("course_url"));
        course.setThumbnailUrl(rs.getString("thumbnail_url"));
        course.setCreatedAt(rs.getTimestamp("created_at"));
        return course;
    }
}

