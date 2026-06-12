package com.learningdashboard.filter;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * AuthenticationFilter - Protects pages that require authentication
 * Redirects unauthenticated users to login page
 */
public class AuthenticationFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
                         FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // Allow login, register, courses browsing, and home pages without authentication
        if (requestURI.contains("/login") || requestURI.contains("/register") || 
            requestURI.contains("/courses.jsp") || requestURI.contains("/search") ||
            requestURI.contains("/index.jsp") || requestURI.contains("/css/") ||
            requestURI.contains("/js/") || requestURI.contains("/images/") ||
            requestURI.equals(contextPath + "/") || requestURI.equals(contextPath)) {
            chain.doFilter(request, response);
            return;
        }

        // Check if user is authenticated
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("[WARNING] Unauthorized access attempt to: " + requestURI);
            httpResponse.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        // Check role-based access
        String role = (String) session.getAttribute("role");
        if (requestURI.contains("/admin/")) {
            if (!"admin".equals(role)) {
                System.out.println("[WARNING] Non-admin trying to access admin pages");
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig config) throws ServletException {}

    @Override
    public void destroy() {}
}

