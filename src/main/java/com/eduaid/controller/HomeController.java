package com.eduaid.controller;

import com.eduaid.service.CategoryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet({"/home", "/index"})
public class HomeController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private CategoryService categoryService;

    @Override
    public void init() throws ServletException {
        categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Get categories for any page that might need them
        try {
            req.setAttribute("categories", categoryService.getAllCategories());
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Not logged in - show public marketing home page
        if (session == null || session.getAttribute("loggedInUser") == null) {
            req.getRequestDispatcher("/home.jsp").forward(req, resp);
            return;
        }

        String role = (String) session.getAttribute("userRole");

        // Redirect to role-specific home page
        switch (role) {
            case "ADMIN":
                req.getRequestDispatcher("/home_admin.jsp").forward(req, resp);
                break;
            case "DONOR":
                req.getRequestDispatcher("/home_donor.jsp").forward(req, resp);
                break;
            case "RECIPIENT":
                req.getRequestDispatcher("/home_recipient.jsp").forward(req, resp);
                break;
            default:
                req.getRequestDispatcher("/home.jsp").forward(req, resp);
        }
    }
}