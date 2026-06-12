package com.learningdashboard.dao;

import com.learningdashboard.models.Certificate;
import com.learningdashboard.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CertificateDAO - Data Access Object for Certificate operations
 * Handles all database operations related to user certificates
 */
public class CertificateDAO {
    
    // CREATE - Issue Certificate
    public boolean issueCertificate(Certificate certificate) {
        String query = "INSERT INTO certificates (user_id, course_id, certificate_number, " +
                       "issue_date, certificate_url) VALUES (?, ?, ?, NOW(), ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, certificate.getUserId());
            pstmt.setInt(2, certificate.getCourseId());
            pstmt.setString(3, certificate.getCertificateNumber());
            pstmt.setString(4, certificate.getCertificateUrl());
            
            int result = pstmt.executeUpdate();
            System.out.println("[INFO] Certificate issued: " + certificate.getCertificateNumber());
            return result > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error issuing certificate: " + e.getMessage());
            return false;
        }
    }

    // READ - Get Certificate by ID
    public Certificate getCertificateById(int certificateId) {
        String query = "SELECT * FROM certificates WHERE certificate_id = ?";
        Certificate certificate = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, certificateId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                certificate = mapResultSetToCertificate(rs);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving certificate: " + e.getMessage());
        }
        return certificate;
    }

    // READ - Get User's Certificates
    public List<Certificate> getUserCertificates(int userId) {
        String query = "SELECT * FROM certificates WHERE user_id = ? ORDER BY issue_date DESC";
        List<Certificate> certificates = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                certificates.add(mapResultSetToCertificate(rs));
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving user certificates: " + e.getMessage());
        }
        return certificates;
    }

    // READ - Get Certificate by Number
    public Certificate getCertificateByNumber(String certificateNumber) {
        String query = "SELECT * FROM certificates WHERE certificate_number = ?";
        Certificate certificate = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, certificateNumber);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                certificate = mapResultSetToCertificate(rs);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving certificate: " + e.getMessage());
        }
        return certificate;
    }

    // READ - Get All Certificates (Admin)
    public List<Certificate> getAllCertificates() {
        String query = "SELECT * FROM certificates ORDER BY issue_date DESC";
        List<Certificate> certificates = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                certificates.add(mapResultSetToCertificate(rs));
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving certificates: " + e.getMessage());
        }
        return certificates;
    }

    // DELETE - Delete Certificate
    public boolean deleteCertificate(int certificateId) {
        String query = "DELETE FROM certificates WHERE certificate_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, certificateId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error deleting certificate: " + e.getMessage());
            return false;
        }
    }

    // Get user's certificate count
    public int getUserCertificateCount(int userId) {
        String query = "SELECT COUNT(*) FROM certificates WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error getting certificate count: " + e.getMessage());
        }
        return 0;
    }

    // Get total certificates issued
    public int getTotalCertificateCount() {
        String query = "SELECT COUNT(*) FROM certificates";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error getting total certificate count: " + e.getMessage());
        }
        return 0;
    }

    // Check if certificate exists for user-course combination
    public boolean certificateExists(int userId, int courseId) {
        String query = "SELECT COUNT(*) FROM certificates WHERE user_id = ? AND course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, courseId);
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error checking certificate existence: " + e.getMessage());
        }
        return false;
    }

    // Helper method to map ResultSet to Certificate
    private Certificate mapResultSetToCertificate(ResultSet rs) throws SQLException {
        Certificate certificate = new Certificate();
        certificate.setCertificateId(rs.getInt("certificate_id"));
        certificate.setUserId(rs.getInt("user_id"));
        certificate.setCourseId(rs.getInt("course_id"));
        certificate.setCertificateNumber(rs.getString("certificate_number"));
        certificate.setIssueDate(rs.getTimestamp("issue_date"));
        certificate.setCertificateUrl(rs.getString("certificate_url"));
        return certificate;
    }
}

