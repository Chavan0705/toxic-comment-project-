package com.learningdashboard.dao;

import com.learningdashboard.models.UserProfile;
import com.learningdashboard.utils.DBConnection;
import java.sql.*;

/**
 * UserProfileDAO - Data Access Object for User Profile operations
 * Handles loading and updating user profiles in the database.
 */
public class UserProfileDAO {

    // Get a user profile by user ID. If it doesn't exist, create an empty one.
    public UserProfile getUserProfileByUserId(int userId) {
        String query = "SELECT * FROM user_profiles WHERE user_id = ?";
        UserProfile profile = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    profile = new UserProfile();
                    profile.setProfileId(rs.getInt("profile_id"));
                    profile.setUserId(rs.getInt("user_id"));
                    profile.setFirstName(rs.getString("first_name"));
                    profile.setLastName(rs.getString("last_name"));
                    profile.setBio(rs.getString("bio"));
                    profile.setProfilePicture(rs.getString("profile_picture"));
                    profile.setPhone(rs.getString("phone"));
                    profile.setCity(rs.getString("city"));
                    profile.setCountry(rs.getString("country"));
                    profile.setUpdatedAt(rs.getTimestamp("updated_at"));
                }
            }
        } catch (SQLException e) {
            System.out.println("[ERROR] Error retrieving user profile: " + e.getMessage());
        }
        
        // If profile doesn't exist, auto-create a default one to avoid null pointer issues
        if (profile == null) {
            profile = new UserProfile(userId, "", "");
            profile.setBio("");
            profile.setPhone("");
            profile.setCity("");
            profile.setCountry("");
            createUserProfile(profile);
        }
        
        return profile;
    }

    // Insert a new user profile
    public boolean createUserProfile(UserProfile profile) {
        String query = "INSERT INTO user_profiles (user_id, first_name, last_name, bio, profile_picture, phone, city, country) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, profile.getUserId());
            pstmt.setString(2, profile.getFirstName() != null ? profile.getFirstName() : "");
            pstmt.setString(3, profile.getLastName() != null ? profile.getLastName() : "");
            pstmt.setString(4, profile.getBio() != null ? profile.getBio() : "");
            pstmt.setString(5, profile.getProfilePicture() != null ? profile.getProfilePicture() : "");
            pstmt.setString(6, profile.getPhone() != null ? profile.getPhone() : "");
            pstmt.setString(7, profile.getCity() != null ? profile.getCity() : "");
            pstmt.setString(8, profile.getCountry() != null ? profile.getCountry() : "");
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error creating user profile: " + e.getMessage());
            return false;
        }
    }

    // Update an existing user profile
    public boolean updateUserProfile(UserProfile profile) {
        String query = "UPDATE user_profiles SET first_name = ?, last_name = ?, bio = ?, phone = ?, city = ?, country = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, profile.getFirstName());
            pstmt.setString(2, profile.getLastName());
            pstmt.setString(3, profile.getBio());
            pstmt.setString(4, profile.getPhone());
            pstmt.setString(5, profile.getCity());
            pstmt.setString(6, profile.getCountry());
            pstmt.setInt(7, profile.getUserId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ERROR] Error updating user profile: " + e.getMessage());
            return false;
        }
    }
}
