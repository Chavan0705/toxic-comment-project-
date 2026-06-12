package com.learningdashboard.models;

import java.sql.Timestamp;
import java.util.UUID;

/**
 * Certificate Model Class - Represents certificates earned by users
 */
public class Certificate {
    private int certificateId;
    private int userId;
    private int courseId;
    private String certificateNumber;
    private Timestamp issueDate;
    private String certificateUrl;
    private String courseName;
    private String instructorName;

    public Certificate() {}

    public Certificate(int userId, int courseId, String courseName, String instructorName) {
        this.userId = userId;
        this.courseId = courseId;
        this.courseName = courseName;
        this.instructorName = instructorName;
        this.certificateNumber = "CERT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    public int getCertificateId() { return certificateId; }
    public void setCertificateId(int certificateId) { this.certificateId = certificateId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public String getCertificateNumber() { return certificateNumber; }
    public void setCertificateNumber(String certificateNumber) { this.certificateNumber = certificateNumber; }

    public Timestamp getIssueDate() { return issueDate; }
    public void setIssueDate(Timestamp issueDate) { this.issueDate = issueDate; }

    public String getCertificateUrl() { return certificateUrl; }
    public void setCertificateUrl(String certificateUrl) { this.certificateUrl = certificateUrl; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public String getInstructorName() { return instructorName; }
    public void setInstructorName(String instructorName) { this.instructorName = instructorName; }
}

