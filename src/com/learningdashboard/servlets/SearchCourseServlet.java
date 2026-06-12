package com.learningdashboard.servlets;

import com.learningdashboard.models.Course;
import com.learningdashboard.dao.CourseDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * SearchCourseServlet - Handles course search and filtering
 * Searches courses by category, platform, or title
 */
public class SearchCourseServlet extends HttpServlet {
    private CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String searchType = request.getParameter("searchType");
        String searchQuery = request.getParameter("query");

        List<Course> courses = null;

        if (searchType != null && searchQuery != null && !searchQuery.isEmpty()) {
            if ("category".equals(searchType)) {
                courses = courseDAO.searchCoursesByCategory(searchQuery);
            } else if ("platform".equals(searchType)) {
                courses = courseDAO.searchCoursesByPlatform(searchQuery);
            } else if ("title".equals(searchType)) {
                courses = courseDAO.searchCoursesByTitle(searchQuery);
            } else {
                courses = courseDAO.getAllCourses();
            }
        } else {
            courses = courseDAO.getAllCourses();
        }

        request.setAttribute("courses", courses);
        request.setAttribute("searchType", searchType);
        request.setAttribute("searchQuery", searchQuery);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("courses.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

