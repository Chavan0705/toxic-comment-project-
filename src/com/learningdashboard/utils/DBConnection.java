package com.learningdashboard.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Utility Class
 * Manages database connections for the application
 */
public class DBConnection {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/learning_dashboard";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root123";
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    public static Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName(DB_DRIVER);
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("[INFO] Database connected successfully!");
        } catch (ClassNotFoundException e) {
            System.out.println("[ERROR] MySQL JDBC Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("[ERROR] Connection failed: " + e.getMessage());
        }
        return connection;
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("[INFO] Connection closed successfully!");
            } catch (SQLException e) {
                System.out.println("[ERROR] Error closing connection: " + e.getMessage());
            }
        }
    }

    // Test connection
    public static void main(String[] args) {
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("[SUCCESS] Database connection test passed!");
            closeConnection(conn);
        } else {
            System.out.println("[FAILED] Database connection test failed!");
        }
    }
}

