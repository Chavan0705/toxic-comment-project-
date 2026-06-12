package com.learningdashboard.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Password Utility Class
 * Handles password hashing and verification (SHA-256)
 * Note: Use BCrypt in production for better security
 */
public class PasswordUtil {
    
    // SHA-256 Hashing
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] messageDigest = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            
            for (byte b : messageDigest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    // Verify Password
    public static boolean verifyPassword(String password, String hash) {
        return hash.equals(hashPassword(password));
    }

    // Validate password strength
    public static boolean isStrongPassword(String password) {
        return password != null && password.length() >= 8 &&
               password.matches(".*[A-Z].*") &&
               password.matches(".*[a-z].*") &&
               password.matches(".*[0-9].*");
    }
}

