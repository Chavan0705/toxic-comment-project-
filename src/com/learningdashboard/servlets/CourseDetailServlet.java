package com.learningdashboard.servlets;

import com.learningdashboard.dao.CourseDAO;
import com.learningdashboard.dao.EnrollmentDAO;
import com.learningdashboard.dao.ProgressDAO;
import com.learningdashboard.models.Course;
import com.learningdashboard.models.Enrollment;
import com.learningdashboard.models.Progress;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * CourseDetailServlet - Handles loading details for a specific course
 * accessible to both public visitors and registered students.
 */
public class CourseDetailServlet extends HttpServlet {
    private CourseDAO courseDAO = new CourseDAO();
    private EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    private ProgressDAO progressDAO = new ProgressDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            Course course = courseDAO.getCourseById(courseId);

            if (course == null) {
                response.sendRedirect("courses.jsp?error=not_found");
                return;
            }

            request.setAttribute("course", course);

            if (userId != null) {
                Enrollment enrollment = enrollmentDAO.getEnrollmentByUserAndCourse(userId, courseId);
                if (enrollment != null) {
                    request.setAttribute("enrollment", enrollment);
                    Progress progress = progressDAO.getProgressByEnrollmentId(enrollment.getEnrollmentId());
                    request.setAttribute("progress", progress);
                }
            }

            // Forward to the JSP view (internal forward bypasses the filter redirection)
            request.getRequestDispatcher("student/course-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.out.println("[ERROR] Invalid course ID in CourseDetailServlet: " + e.getMessage());
            response.sendRedirect("courses.jsp?error=invalid_id");
        }
    }
}
