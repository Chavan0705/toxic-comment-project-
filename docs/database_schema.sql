-- Learning Dashboard Database Schema
-- MySQL Database Script

-- Create Database
CREATE DATABASE IF NOT EXISTS learning_dashboard;
USE learning_dashboard;

-- Drop existing tables (for fresh setup)
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS progress;
DROP TABLE IF EXISTS certificates;
DROP TABLE IF EXISTS chatbot_logs;
DROP TABLE IF EXISTS admin_logs;
DROP TABLE IF EXISTS user_interests;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS skills;
DROP TABLE IF EXISTS user_profiles;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS=1;

-- Users Table (Authentication)
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('student', 'admin') DEFAULT 'student',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- User Profiles Table
CREATE TABLE user_profiles (
    profile_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    bio TEXT,
    profile_picture VARCHAR(255),
    phone VARCHAR(20),
    city VARCHAR(50),
    country VARCHAR(50),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Skills Table
CREATE TABLE skills (
    skill_id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(100) UNIQUE NOT NULL,
    category VARCHAR(50),
    INDEX idx_skill_name (skill_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- User Interests/Skills Table
CREATE TABLE user_interests (
    interest_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    skill_id INT NOT NULL,
    proficiency_level ENUM('beginner', 'intermediate', 'advanced') DEFAULT 'beginner',
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_skill (user_id, skill_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Courses Table
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_title VARCHAR(255) NOT NULL,
    description LONGTEXT,
    platform ENUM('coursera', 'udemy', 'edx', 'youtube', 'linkedin', 'other') NOT NULL,
    category VARCHAR(100),
    sub_category VARCHAR(100),
    instructor_name VARCHAR(100),
    duration_hours INT DEFAULT 0,
    rating DECIMAL(3,2) DEFAULT 0,
    enrollment_count INT DEFAULT 0,
    price DECIMAL(10,2) DEFAULT 0,
    course_url VARCHAR(500),
    thumbnail_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_platform (platform),
    INDEX idx_category (category),
    INDEX idx_title (course_title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Enrollments Table
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('enrolled', 'completed', 'dropped') DEFAULT 'enrolled',
    completion_percentage DECIMAL(5,2) DEFAULT 0,
    hours_spent DECIMAL(10,2) DEFAULT 0,
    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (user_id, course_id),
    INDEX idx_user_id (user_id),
    INDEX idx_course_id (course_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Progress Table (Detailed tracking)
CREATE TABLE progress (
    progress_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL UNIQUE,
    completion_percentage DECIMAL(5,2) DEFAULT 0,
    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    hours_spent DECIMAL(10,2) DEFAULT 0,
    notes LONGTEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE,
    INDEX idx_enrollment_id (enrollment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Certificates Table
CREATE TABLE certificates (
    certificate_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    certificate_number VARCHAR(100) UNIQUE NOT NULL,
    issue_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    certificate_url VARCHAR(500),
    verified BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_certificate_number (certificate_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Chatbot Interactions Log
CREATE TABLE chatbot_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    query TEXT NOT NULL,
    response TEXT,
    interaction_type VARCHAR(50),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_timestamp (timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Admin Actions Log
CREATE TABLE admin_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id INT NOT NULL,
    action VARCHAR(255),
    description TEXT,
    affected_user_id INT,
    affected_course_id INT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_admin_id (admin_id),
    INDEX idx_timestamp (timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert Sample Skills
INSERT INTO skills (skill_name, category) VALUES
('Python', 'Programming'),
('JavaScript', 'Programming'),
('Java', 'Programming'),
('Web Development', 'Development'),
('Machine Learning', 'AI/ML'),
('Data Science', 'Data'),
('Cloud Computing', 'Cloud'),
('DevOps', 'Operations'),
('Mobile Development', 'Development'),
('Database Design', 'Database');

-- Insert Sample Courses
INSERT INTO courses (course_title, description, platform, category, instructor_name, duration_hours, rating, price, course_url) VALUES
('Python for Beginners', 'Learn Python basics from scratch', 'udemy', 'Programming', 'John Doe', 20, 4.5, 49.99, 'https://udemy.com/python'),
('Advanced JavaScript', 'Master JavaScript for web development', 'coursera', 'Programming', 'Jane Smith', 40, 4.8, 0, 'https://coursera.org/javascript'),
('Web Development Bootcamp', 'Complete web development course', 'udemy', 'Web Development', 'Max Johnson', 60, 4.7, 99.99, 'https://udemy.com/webdev'),
('Machine Learning Basics', 'Introduction to ML concepts', 'edx', 'AI/ML', 'Dr. Sarah Lee', 45, 4.6, 0, 'https://edx.org/ml'),
('React.js Masterclass', 'Build modern web apps with React', 'coursera', 'Web Development', 'Tom Brown', 35, 4.9, 0, 'https://coursera.org/react');

-- Create Indexes for Performance
CREATE INDEX idx_enrollment_user_status ON enrollments(user_id, status);
CREATE INDEX idx_enrollment_course_status ON enrollments(course_id, status);
CREATE INDEX idx_progress_enrollment ON progress(enrollment_id);
CREATE INDEX idx_certificate_user ON certificates(user_id);

-- Display Success Message
SELECT 'Database setup complete!' as Status;
