package com.eduaid.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/user/*")
public class UserController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/dashboard";

        switch (pathInfo) {
            case "/dashboard":
                req.getRequestDispatcher("/views/user/dashboard.jsp").forward(req, resp);
                break;
            case "/profile":
                req.getRequestDispatcher("/views/user/profile.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/user/dashboard");
        }
    }
}