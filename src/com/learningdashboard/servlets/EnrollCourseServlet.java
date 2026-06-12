package com.learningdashboard.servlets;

import com.learningdashboard.dao.EnrollmentDAO;
import com.learningdashboard.dao.ProgressDAO;
import com.learningdashboard.models.Enrollment;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * EnrollCourseServlet - Handles course enrollment logic
 * Enrolls user in selected course
 */
public class EnrollCourseServlet extends HttpServlet {
    private EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    private ProgressDAO progressDAO = new ProgressDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("userId");
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            // Check if already enrolled
            if (enrollmentDAO.isAlreadyEnrolled(userId, courseId)) {
                response.sendRedirect("courses.jsp?error=already_enrolled");
                return;
            }

            // Enroll user
            if (enrollmentDAO.enrollCourse(userId, courseId)) {
                System.out.println("[INFO] User " + userId + " enrolled in course " + courseId);
                Enrollment newEnrollment = enrollmentDAO.getEnrollmentByUserAndCourse(userId, courseId);
                if (newEnrollment != null) {
                    progressDAO.createProgress(newEnrollment.getEnrollmentId());
                }
                response.sendRedirect("student/dashboard.jsp?message=enrolled");
            } else {
                response.sendRedirect("courses.jsp?error=enrollment_failed");
            }
        } catch (NumberFormatException e) {
            System.out.println("[ERROR] Invalid course ID: " + e.getMessage());
            response.sendRedirect("courses.jsp?error=invalid_course");
        }
    }
}

