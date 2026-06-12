package com.learningdashboard.servlets;

import com.learningdashboard.dao.CourseDAO;
import com.learningdashboard.models.Course;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * AdminCourseServlet - Handles admin actions on course catalog
 */
public class AdminCourseServlet extends HttpServlet {
    private CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        if (session == null || !"admin".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            String title = request.getParameter("course_title");
            String description = request.getParameter("description");
            String platform = request.getParameter("platform");
            String category = request.getParameter("category");
            String instructor = request.getParameter("instructor_name");
            int duration = Integer.parseInt(request.getParameter("duration_hours"));
            BigDecimal rating = new BigDecimal(request.getParameter("rating"));
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            String courseUrl = request.getParameter("course_url");
            String thumbnailUrl = request.getParameter("thumbnail_url");

            if ("add".equals(action)) {
                Course course = new Course(title, description, platform, category, instructor, duration);
                course.setRating(rating);
                course.setPrice(price);
                course.setCourseUrl(courseUrl);
                course.setThumbnailUrl(thumbnailUrl);

                if (courseDAO.addCourse(course)) {
                    request.setAttribute("successMessage", "Course added successfully!");
                } else {
                    request.setAttribute("errorMessage", "Failed to add course.");
                }
            } else if ("update".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                Course course = new Course();
                course.setCourseId(courseId);
                course.setCourseTitle(title);
                course.setDescription(description);
                course.setPlatform(platform);
                course.setCategory(category);
                course.setInstructorName(instructor);
                course.setDurationHours(duration);
                course.setRating(rating);
                course.setPrice(price);
                course.setCourseUrl(courseUrl);
                course.setThumbnailUrl(thumbnailUrl);

                if (courseDAO.updateCourse(course)) {
                    request.setAttribute("successMessage", "Course updated successfully!");
                } else {
                    request.setAttribute("errorMessage", "Failed to update course.");
                }
            }
        } catch (Exception e) {
            System.out.println("[ERROR] Exception in AdminCourseServlet (doPost): " + e.getMessage());
            request.setAttribute("errorMessage", "Error processing form inputs. Please verify all fields.");
        }

        request.getRequestDispatcher("/admin/courses.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        if (session == null || !"admin".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            try {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                if (courseDAO.deleteCourse(courseId)) {
                    request.setAttribute("successMessage", "Course deleted successfully!");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete course.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Course ID.");
            }
        }

        request.getRequestDispatcher("/admin/courses.jsp").forward(request, response);
    }
}
