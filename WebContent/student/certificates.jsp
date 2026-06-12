<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.learningdashboard.dao.*, com.learningdashboard.models.*, java.util.*, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Certificates - Learning Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        /* Certificate Frame Styling for WOW Factor */
        .certificate-frame {
            border: 15px solid #d4af37; /* Gold border */
            padding: 3rem;
            background-color: #fdfcf7; /* Ivory background */
            position: relative;
            text-align: center;
            font-family: 'Georgia', serif;
            color: #333;
            max-width: 800px;
            margin: 2rem auto;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
        }
        .certificate-inner {
            border: 2px solid #d4af37;
            padding: 2rem;
        }
        .cert-title {
            font-size: 2.5rem;
            color: #1b263b;
            text-transform: uppercase;
            letter-spacing: 2px;
            margin-bottom: 1rem;
        }
        .cert-subtitle {
            font-style: italic;
            font-size: 1.2rem;
            margin-bottom: 2rem;
        }
        .cert-name {
            font-size: 2.2rem;
            font-weight: bold;
            color: #764ba2;
            border-bottom: 2px solid #ccc;
            display: inline-block;
            padding: 0 2rem 0.25rem 2rem;
            margin-bottom: 1.5rem;
        }
        .cert-course {
            font-size: 1.6rem;
            font-weight: bold;
            color: #1b263b;
            margin-bottom: 2rem;
        }
        .cert-meta {
            display: flex;
            justify-content: space-between;
            margin-top: 3rem;
            font-size: 0.95rem;
        }
        .cert-seal {
            width: 90px;
            height: 90px;
            background: radial-gradient(circle, #d4af37 0%, #aa7c11 100%);
            border-radius: 50%;
            border: 4px dashed white;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 0.8rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="container">
            <a href="../index.jsp" class="logo">Learning Dashboard</a>
            <ul id="navMenu">
                <li><a href="../index.jsp">Home</a></li>
                <li><a href="../courses.jsp">Courses</a></li>
                <li><a href="dashboard.jsp">My Dashboard</a></li>
                <li><a href="profile.jsp">Profile</a></li>
                <li><a href="../logout">Logout</a></li>
            </ul>
        </div>
    </nav>

    <%
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        CertificateDAO certificateDAO = new CertificateDAO();
        EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
        CourseDAO courseDAO = new CourseDAO();
        UserDAO userDAO = new UserDAO();
        SimpleDateFormat sdf = new SimpleDateFormat("MMMM d, yyyy");

        Certificate activeCertificate = null;
        Course certCourse = null;
        User certUser = null;

        String enrollmentIdParam = request.getParameter("enrollmentId");
        String certNumberParam = request.getParameter("certNumber");

        // 1. Fetch certificate if viewing a specific one
        if (enrollmentIdParam != null && !enrollmentIdParam.isEmpty()) {
            try {
                int enrollmentId = Integer.parseInt(enrollmentIdParam);
                Enrollment e = enrollmentDAO.getEnrollment(enrollmentId);
                if (e != null && e.getUserId() == userId && "completed".equals(e.getStatus())) {
                    List<Certificate> userCerts = certificateDAO.getUserCertificates(userId);
                    for (Certificate c : userCerts) {
                        if (c.getCourseId() == e.getCourseId()) {
                            activeCertificate = c;
                            break;
                        }
                    }
                }
            } catch (NumberFormatException e) { }
        }

        if (activeCertificate == null && certNumberParam != null && !certNumberParam.isEmpty()) {
            activeCertificate = certificateDAO.getCertificateByNumber(certNumberParam);
        }

        if (activeCertificate != null) {
            certCourse = courseDAO.getCourseById(activeCertificate.getCourseId());
            certUser = userDAO.getUserById(activeCertificate.getUserId());
        }
    %>

    <div class="container" style="padding: 2rem 20px;">
        <div style="margin-bottom: 2rem;">
            <a href="dashboard.jsp" style="text-decoration: none; color: var(--primary-color); font-weight: 500;">&larr; Back to Dashboard</a>
        </div>

        <% if (activeCertificate != null && certCourse != null && certUser != null) { %>
            <!-- VIEW CERTIFICATE -->
            <div class="certificate-frame">
                <div class="certificate-inner">
                    <div class="cert-title">Certificate of Completion</div>
                    <div class="cert-subtitle">This is proudly presented to</div>
                    
                    <div class="cert-name">
                        <%= (certUser.getUsername() != null) ? certUser.getUsername() : "Distinguished Learner" %>
                    </div>
                    
                    <div style="font-size: 1.1rem; margin-bottom: 1.5rem;">for successfully completing the online aggregated course</div>
                    <div class="cert-course"><%= certCourse.getCourseTitle() %></div>
                    
                    <div style="font-size: 1.05rem; color: #555;">
                        offered via platform <strong style="text-transform: uppercase;"><%= certCourse.getPlatform() %></strong> 
                        consisting of <%= certCourse.getDurationHours() %> study hours.
                    </div>

                    <div class="cert-meta">
                        <div style="text-align: left;">
                            <span style="color: #777; display: block; font-size: 0.85rem;">Date Issued</span>
                            <strong><%= sdf.format(activeCertificate.getIssueDate()) %></strong>
                        </div>
                        <div>
                            <div class="cert-seal">VERIFIED</div>
                        </div>
                        <div style="text-align: right;">
                            <span style="color: #777; display: block; font-size: 0.85rem;">Certificate ID</span>
                            <code style="font-weight: bold; color: var(--secondary-color);"><%= activeCertificate.getCertificateNumber() %></code>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-top: 3rem;">
            <!-- Left Side: My Certificates List -->
            <div class="card">
                <h3>My Earned Certificates</h3>
                <p style="color: #666; margin-bottom: 1.5rem;">Click view to render your digital certificate frame</p>
                <%
                    List<Certificate> myCertificates = certificateDAO.getUserCertificates(userId);
                %>
                <% if (myCertificates.isEmpty()) { %>
                    <p style="color: #777; padding: 1.5rem 0; text-align: center;">You have not earned any certificates yet. Complete courses to 100% progress to receive certificates!</p>
                <% } else { %>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Course</th>
                                <th>Issue Date</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Certificate c : myCertificates) { 
                                Course courseInfo = courseDAO.getCourseById(c.getCourseId());
                            %>
                                <tr>
                                    <td><strong><%= (courseInfo != null) ? courseInfo.getCourseTitle() : "Course #" + c.getCourseId() %></strong></td>
                                    <td><%= sdf.format(c.getIssueDate()) %></td>
                                    <td>
                                        <a href="certificates.jsp?certNumber=<%= c.getCertificateNumber() %>" class="btn btn-primary btn-sm">View Frame</a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>

            <!-- Right Side: Public Verification Check -->
            <div class="card">
                <h3>Public Verification System</h3>
                <p style="color: #666; margin-bottom: 1.5rem;">Enter a certificate verification ID below to check its validation status in our database</p>

                <%
                    String verifyId = request.getParameter("verifyId");
                    Certificate verCert = null;
                    User verUser = null;
                    Course verCourse = null;
                    
                    if (verifyId != null && !verifyId.isEmpty()) {
                        verCert = certificateDAO.getCertificateByNumber(verifyId.trim());
                        if (verCert != null) {
                            verUser = userDAO.getUserById(verCert.getUserId());
                            verCourse = courseDAO.getCourseById(verCert.getCourseId());
                        }
                    }
                %>

                <form method="GET" action="certificates.jsp" style="display: flex; gap: 0.5rem; margin-bottom: 2rem;">
                    <input type="text" name="verifyId" placeholder="e.g. CERT-1-3-171822830" 
                           value="<%= (verifyId != null) ? verifyId : "" %>" required style="flex: 1; padding: 0.75rem;">
                    <button type="submit" class="btn btn-primary" style="margin-right: 0;">Verify</button>
                </form>

                <% if (verifyId != null) { %>
                    <% if (verCert != null && verUser != null && verCourse != null) { %>
                        <div class="alert alert-success" style="border-left-width: 6px;">
                            <strong>✓ Certificate Verified Authentic!</strong>
                            <p style="margin-top: 0.5rem; font-size: 0.95rem; line-height: 1.5;">
                                This certificate is verified as a valid credential issued to 
                                <strong><%= verUser.getUsername() %></strong> on 
                                <strong><%= sdf.format(verCert.getIssueDate()) %></strong> 
                                for completing the course <strong><%= verCourse.getCourseTitle() %></strong>.
                            </p>
                            <a href="certificates.jsp?certNumber=<%= verCert.getCertificateNumber() %>" 
                               style="display: inline-block; margin-top: 0.75rem; font-weight: 600; color: #155724; text-decoration: underline;">
                               View Digital Certificate File &rarr;
                            </a>
                        </div>
                    <% } else { %>
                        <div class="alert alert-error" style="border-left-width: 6px;">
                            <strong>✗ Verification Failed</strong>
                            <p style="margin-top: 0.25rem; font-size: 0.95rem;">
                                The certificate ID "<strong><%= verifyId %></strong>" was not found in our directory. Please make sure the code matches exactly.
                            </p>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 Learning Dashboard. All rights reserved.</p>
        </div>
    </footer>
    <script src="../js/main.js"></script>
</body>
</html>
