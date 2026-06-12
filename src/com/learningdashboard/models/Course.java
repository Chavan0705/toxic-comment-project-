package com.learningdashboard.models;

import java.sql.Timestamp;
import java.math.BigDecimal;

/**
 * Course Model Class - Represents a course available in the platform
 */
public class Course {
    private int courseId;
    private String courseTitle;
    private String description;
    private String platform;
    private String category;
    private String instructorName;
    private int durationHours;
    private BigDecimal rating;
    private BigDecimal price;
    private String courseUrl;
    private String thumbnailUrl;
    private Timestamp createdAt;

    public Course() {}

    public Course(String courseTitle, String description, String platform, 
                  String category, String instructorName, int durationHours) {
        this.courseTitle = courseTitle;
        this.description = description;
        this.platform = platform;
        this.category = category;
        this.instructorName = instructorName;
        this.durationHours = durationHours;
    }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public String getCourseTitle() { return courseTitle; }
    public void setCourseTitle(String courseTitle) { this.courseTitle = courseTitle; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getPlatform() { return platform; }
    public void setPlatform(String platform) { this.platform = platform; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getInstructorName() { return instructorName; }
    public void setInstructorName(String instructorName) { this.instructorName = instructorName; }

    public int getDurationHours() { return durationHours; }
    public void setDurationHours(int durationHours) { this.durationHours = durationHours; }

    public BigDecimal getRating() { return rating; }
    public void setRating(BigDecimal rating) { this.rating = rating; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getCourseUrl() { return courseUrl; }
    public void setCourseUrl(String courseUrl) { this.courseUrl = courseUrl; }

    public String getThumbnailUrl() { return thumbnailUrl; }
    public void setThumbnailUrl(String thumbnailUrl) { this.thumbnailUrl = thumbnailUrl; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}

