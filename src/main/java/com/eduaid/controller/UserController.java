package com.eduaid.controller;

import com.eduaid.model.User;
import com.eduaid.service.CategoryService;
import com.eduaid.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/user/*")
public class UserController extends HttpServlet {

    private CategoryService categoryService;

    @Override
    public void init() throws ServletException {
        categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        String pathInfo = req.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
            // Route to correct dashboard based on role
            if ("DONOR".equals(user.getRole())) {
                try {
                    List<Category> categories = categoryService.getAllCategories();
                    req.setAttribute("categories", categories);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                req.getRequestDispatcher("/views/user/donor_dashboard.jsp").forward(req, resp);
            } else if ("RECIPIENT".equals(user.getRole())) {
                // ***** ADD THIS - Load categories for recipient dashboard *****
                try {
                    List<Category> categories = categoryService.getAllCategories();
                    req.setAttribute("categories", categories);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                req.getRequestDispatcher("/views/user/recipient_dashboard.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            }
            return;
        }

        switch (pathInfo) {
            case "/profile":
                req.getRequestDispatcher("/views/user/profile.jsp").forward(req, resp);
                break;
            case "/browse":
                try {
                    List<Category> categories = categoryService.getAllCategories();
                    req.setAttribute("categories", categories);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                req.getRequestDispatcher("/views/user/browse_resources.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/user/dashboard");
        }
    }
}