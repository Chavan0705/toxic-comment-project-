package com.learningdashboard.models;

import java.sql.Timestamp;

/**
 * Enrollment Model Class - Represents a user's enrollment in a course with progress tracking
 */
public class Enrollment {
    private int enrollmentId;
    private int userId;
    private int courseId;
    private Timestamp enrollmentDate;
    private String status;
    private double completionPercentage;
    private double hoursSpent;
    private Timestamp lastAccessed;

    public Enrollment() {}

    public Enrollment(int userId, int courseId) {
        this.userId = userId;
        this.courseId = courseId;
        this.status = "enrolled";
        this.completionPercentage = 0;
        this.hoursSpent = 0;
    }

    public int getEnrollmentId() { return enrollmentId; }
    public void setEnrollmentId(int enrollmentId) { this.enrollmentId = enrollmentId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public Timestamp getEnrollmentDate() { return enrollmentDate; }
    public void setEnrollmentDate(Timestamp enrollmentDate) { this.enrollmentDate = enrollmentDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public double getCompletionPercentage() { return completionPercentage; }
    public void setCompletionPercentage(double completionPercentage) { 
        this.completionPercentage = completionPercentage; 
    }

    public double getHoursSpent() { return hoursSpent; }
    public void setHoursSpent(double hoursSpent) { this.hoursSpent = hoursSpent; }

    public Timestamp getLastAccessed() { return lastAccessed; }
    public void setLastAccessed(Timestamp lastAccessed) { this.lastAccessed = lastAccessed; }

    public boolean isCompleted() { return "completed".equals(status); }
    public boolean isEnrolled() { return "enrolled".equals(status); }
}

