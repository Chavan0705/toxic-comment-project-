package com.learningdashboard.servlets;

import com.learningdashboard.dao.EnrollmentDAO;
import com.learningdashboard.dao.ProgressDAO;
import com.learningdashboard.dao.CertificateDAO;
import com.learningdashboard.models.Enrollment;
import com.learningdashboard.models.Certificate;
import com.learningdashboard.models.Progress;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * UpdateProgressServlet - Handles progress tracking updates
 * Updates completion percentage, hours spent, and progress notes.
 * Triggers automatic certificate generation upon 100% completion.
 */
public class UpdateProgressServlet extends HttpServlet {
    private EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    private ProgressDAO progressDAO = new ProgressDAO();
    private CertificateDAO certificateDAO = new CertificateDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Unauthorized");
            return;
        }

        try {
            int enrollmentId = Integer.parseInt(request.getParameter("enrollmentId"));
            double completionPercentage = Double.parseDouble(request.getParameter("completion"));
            double hoursSpent = Double.parseDouble(request.getParameter("hours"));
            String notes = request.getParameter("notes");

            // Validate values
            if (completionPercentage < 0 || completionPercentage > 100) {
                completionPercentage = Math.min(Math.max(completionPercentage, 0), 100);
            }

            if (hoursSpent < 0) {
                hoursSpent = 0;
            }

            // Get enrollment record
            Enrollment enrollment = enrollmentDAO.getEnrollment(enrollmentId);
            if (enrollment == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("Enrollment not found");
                return;
            }

            int userId = (Integer) session.getAttribute("userId");
            if (enrollment.getUserId() != userId) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("Access denied");
                return;
            }

            // Get existing progress to see original hours
            Progress progressRecord = progressDAO.getProgressByEnrollmentId(enrollmentId);
            double previousHours = (progressRecord != null) ? progressRecord.getHoursSpent() : 0.0;
            double newTotalHours = previousHours + hoursSpent;

            // Ensure progress record exists
            boolean success = false;
            if (progressRecord == null) {
                success = progressDAO.createProgress(enrollmentId);
            } else {
                success = true;
            }

            if (success) {
                // Update completion, hours, and notes in progress table
                progressDAO.updateCompletionPercentage(enrollmentId, completionPercentage);
                progressDAO.updateHoursSpent(enrollmentId, hoursSpent); // Note: updateHoursSpent adds hours in DB
                if (notes != null) {
                    progressDAO.addNotes(enrollmentId, notes);
                }

                // Synchronize with enrollments table
                enrollmentDAO.updateProgress(enrollmentId, completionPercentage, newTotalHours);
                
                // If 100%, mark status as completed in enrollments
                if (completionPercentage >= 100.0) {
                    enrollmentDAO.updateEnrollmentStatus(enrollmentId, "completed");

                    // Auto-issue certificate if it doesn't exist yet
                    if (!certificateDAO.certificateExists(userId, enrollment.getCourseId())) {
                        String certNumber = "CERT-" + userId + "-" + enrollment.getCourseId() + "-" + (System.currentTimeMillis() / 1000);
                        String certUrl = "certificates/cert_" + certNumber + ".pdf";
                        Certificate cert = new Certificate();
                        cert.setUserId(userId);
                        cert.setCourseId(enrollment.getCourseId());
                        cert.setCertificateNumber(certNumber);
                        cert.setCertificateUrl(certUrl);
                        certificateDAO.issueCertificate(cert);
                    }
                } else {
                    // In case progress was decreased from 100%, change status back to enrolled
                    if ("completed".equals(enrollment.getStatus())) {
                        enrollmentDAO.updateEnrollmentStatus(enrollmentId, "enrolled");
                    }
                }

                System.out.println("[INFO] Progress and enrollment synchronized for enrollment " + enrollmentId);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Progress updated successfully");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Error updating progress");
            }
        } catch (NumberFormatException e) {
            System.out.println("[ERROR] Invalid parameter: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid parameters");
        }
    }
}
