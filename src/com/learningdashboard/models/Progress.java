package com.learningdashboard.models;

import java.sql.Timestamp;

/**
 * Progress Model Class - Detailed progress tracking for each enrollment
 */
public class Progress {
    private int progressId;
    private int enrollmentId;
    private double completionPercentage;
    private Timestamp lastAccessed;
    private double hoursSpent;
    private String notes;

    public Progress() {}

    public Progress(int enrollmentId) {
        this.enrollmentId = enrollmentId;
        this.completionPercentage = 0;
        this.hoursSpent = 0;
    }

    public int getProgressId() { return progressId; }
    public void setProgressId(int progressId) { this.progressId = progressId; }

    public int getEnrollmentId() { return enrollmentId; }
    public void setEnrollmentId(int enrollmentId) { this.enrollmentId = enrollmentId; }

    public double getCompletionPercentage() { return completionPercentage; }
    public void setCompletionPercentage(double completionPercentage) { 
        this.completionPercentage = Math.min(completionPercentage, 100.0); 
    }

    public Timestamp getLastAccessed() { return lastAccessed; }
    public void setLastAccessed(Timestamp lastAccessed) { this.lastAccessed = lastAccessed; }

    public double getHoursSpent() { return hoursSpent; }
    public void setHoursSpent(double hoursSpent) { this.hoursSpent = hoursSpent; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public void addHoursSpent(double hours) {
        this.hoursSpent += hours;
    }

    public void incrementCompletion(double percentage) {
        this.completionPercentage = Math.min(this.completionPercentage + percentage, 100.0);
    }
}

