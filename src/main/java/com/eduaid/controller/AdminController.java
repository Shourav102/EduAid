package com.eduaid.controller;

import com.eduaid.model.Category;
import com.eduaid.model.User;
import com.eduaid.service.CategoryService;
import com.eduaid.service.UserService;
import com.eduaid.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * AdminController - Handles all admin dashboard routes.
 *
 * URL mappings (all protected by AuthFilter — ADMIN role only):
 *   GET  /admin/dashboard              → admin home with summary stats
 *   GET  /admin/users                  → user management list
 *   POST /admin/users?action=approve   → approve a user
 *   POST /admin/users?action=disable   → disable a user
 *   GET  /admin/categories             → category list
 *   GET  /admin/categories?action=add  → show add category form
 *   POST /admin/categories?action=add  → process add category
 *   GET  /admin/categories?action=edit&id=X  → show edit form
 *   POST /admin/categories?action=edit       → process edit
 *   POST /admin/categories?action=delete     → process delete
 *
 * MVC Role: CONTROLLER
 */
@WebServlet("/admin/*")
public class AdminController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserService     userService;
    private CategoryService categoryService;

    @Override
    public void init() throws ServletException {
        userService     = new UserService();
        categoryService = new CategoryService();
    }

    // ---------------------------------------------------------------
    // GET
    // ---------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo(); // e.g. "/dashboard", "/users", "/categories"
        if (pathInfo == null) pathInfo = "/dashboard";

        try {
            switch (pathInfo) {
                case "/dashboard":
                    showDashboard(req, resp);
                    break;
                case "/users":
                    showUsers(req, resp);
                    break;
                case "/categories":
                    handleCategoriesGet(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            }
        } catch (SQLException e) {
            System.err.println("[AdminController] GET error: " + e.getMessage());
            req.setAttribute("errorMessage", "A server error occurred. Please try again.");
            req.getRequestDispatcher("/views/common/error500.jsp").forward(req, resp);
        }
    }

    // ---------------------------------------------------------------
    // POST
    // ---------------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/dashboard";

        try {
            switch (pathInfo) {
                case "/users":
                    handleUsersPost(req, resp);
                    break;
                case "/categories":
                    handleCategoriesPost(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            }
        } catch (SQLException e) {
            System.err.println("[AdminController] POST error: " + e.getMessage());
            req.getRequestDispatcher("/views/common/error500.jsp").forward(req, resp);
        }
    }

    // ---------------------------------------------------------------
    // DASHBOARD
    // ---------------------------------------------------------------
    private void showDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, SQLException {

        List<User>     allUsers    = userService.getAllUsers();
        List<User>     pending     = userService.getPendingUsers();
        List<Category> categories  = categoryService.getAllCategories();

        // Summary stats for dashboard cards
        long totalUsers    = allUsers.size();
        long pendingCount  = pending.size();
        long approvedCount = allUsers.stream().filter(User::isApproved).count();
        long catCount      = categories.size();

        req.setAttribute("totalUsers",    totalUsers);
        req.setAttribute("pendingCount",  pendingCount);
        req.setAttribute("approvedCount", approvedCount);
        req.setAttribute("catCount",      catCount);
        req.setAttribute("pendingUsers",  pending);      // show pending list on dashboard

        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }

    // ---------------------------------------------------------------
    // USER MANAGEMENT
    // ---------------------------------------------------------------
    private void showUsers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, SQLException {

        List<User> users = userService.getAllUsers();
        req.setAttribute("users", users);

        // Pass any flash messages from redirect
        HttpSession session = req.getSession(false);
        if (session != null) {
            req.setAttribute("successMessage", session.getAttribute("successMessage"));
            req.setAttribute("errorMessage",   session.getAttribute("errorMessage"));
            session.removeAttribute("successMessage");
            session.removeAttribute("errorMessage");
        }

        req.getRequestDispatcher("/views/admin/users.jsp").forward(req, resp);
    }

    private void handleUsersPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, SQLException {

        String action = req.getParameter("action");
        String userIdStr = req.getParameter("userId");

        if (ValidationUtil.isBlank(userIdStr)) {
            setSessionMessage(req, "error", "Invalid request — no user ID provided.");
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        int targetUserId;
        try {
            targetUserId = Integer.parseInt(userIdStr.trim());
        } catch (NumberFormatException e) {
            setSessionMessage(req, "error", "Invalid user ID format.");
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        // Prevent admin from acting on their own account
        HttpSession session = req.getSession(false);
        int loggedInUserId  = (int) session.getAttribute("userId");
        if (targetUserId == loggedInUserId) {
            setSessionMessage(req, "error", "You cannot change the status of your own account.");
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        boolean success = false;
        String  message = "";

        switch (action != null ? action : "") {
            case "approve":
                success = userService.approveUser(targetUserId);
                message = success ? "User account approved successfully."
                                  : "Failed to approve user. Account may not exist.";
                break;
            case "disable":
                success = userService.disableUser(targetUserId);
                message = success ? "User account has been disabled."
                                  : "Failed to disable user. Account may not exist.";
                break;
            default:
                message = "Unknown action.";
        }

        setSessionMessage(req, success ? "success" : "error", message);
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    // ---------------------------------------------------------------
    // CATEGORY MANAGEMENT
    // ---------------------------------------------------------------
    private void handleCategoriesGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, SQLException {

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            // Show add category form
            req.getRequestDispatcher("/views/admin/categoryForm.jsp").forward(req, resp);
            return;
        }

        if ("edit".equals(action)) {
            // Show edit category form pre-populated with existing data
            String idStr = req.getParameter("id");
            if (ValidationUtil.isBlank(idStr)) {
                resp.sendRedirect(req.getContextPath() + "/admin/categories");
                return;
            }
            int catId = Integer.parseInt(idStr.trim());
            Category category = categoryService.getCategoryById(catId);
            if (category == null) {
                setSessionMessage(req, "error", "Category not found.");
                resp.sendRedirect(req.getContextPath() + "/admin/categories");
                return;
            }
            req.setAttribute("category",    category);
            req.setAttribute("editMode",    true);
            req.getRequestDispatcher("/views/admin/categoryForm.jsp").forward(req, resp);
            return;
        }

        // Default: show category list
        List<Category> categories = categoryService.getAllCategories();
        req.setAttribute("categories", categories);

        HttpSession session = req.getSession(false);
        if (session != null) {
            req.setAttribute("successMessage", session.getAttribute("successMessage"));
            req.setAttribute("errorMessage",   session.getAttribute("errorMessage"));
            session.removeAttribute("successMessage");
            session.removeAttribute("errorMessage");
        }

        req.getRequestDispatcher("/views/admin/categories.jsp").forward(req, resp);
    }

    private void handleCategoriesPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, SQLException {

        String action = req.getParameter("action");

        switch (action != null ? action : "") {

            case "add": {
                String name        = req.getParameter("name");
                String description = req.getParameter("description");

                Map<String, Object> result = categoryService.createCategory(name, description);

                if (result.containsKey("success")) {
                    setSessionMessage(req, "success", "Category '" + name + "' created successfully.");
                    resp.sendRedirect(req.getContextPath() + "/admin/categories");
                } else {
                    @SuppressWarnings("unchecked")
                    Map<String, String> errors = (Map<String, String>) result.get("errors");
                    req.setAttribute("errors",      errors);
                    req.setAttribute("name",        ValidationUtil.sanitise(name));
                    req.setAttribute("description", ValidationUtil.sanitise(description));
                    req.setAttribute("editMode",    false);
                    req.getRequestDispatcher("/views/admin/categoryForm.jsp").forward(req, resp);
                }
                break;
            }

            case "edit": {
                String idStr       = req.getParameter("categoryId");
                String name        = req.getParameter("name");
                String description = req.getParameter("description");

                int catId;
                try { catId = Integer.parseInt(idStr.trim()); }
                catch (NumberFormatException e) {
                    setSessionMessage(req, "error", "Invalid category ID.");
                    resp.sendRedirect(req.getContextPath() + "/admin/categories");
                    return;
                }

                Map<String, Object> result = categoryService.updateCategory(catId, name, description);

                if (result.containsKey("success")) {
                    setSessionMessage(req, "success", "Category updated successfully.");
                    resp.sendRedirect(req.getContextPath() + "/admin/categories");
                } else {
                    @SuppressWarnings("unchecked")
                    Map<String, String> errors = (Map<String, String>) result.get("errors");
                    Category cat = new Category();
                    cat.setCategoryId(catId);
                    cat.setName(name);
                    cat.setDescription(description);
                    req.setAttribute("errors",   errors);
                    req.setAttribute("category", cat);
                    req.setAttribute("editMode", true);
                    req.getRequestDispatcher("/views/admin/categoryForm.jsp").forward(req, resp);
                }
                break;
            }

            case "delete": {
                String idStr = req.getParameter("categoryId");
                int catId;
                try { catId = Integer.parseInt(idStr.trim()); }
                catch (NumberFormatException e) {
                    setSessionMessage(req, "error", "Invalid category ID.");
                    resp.sendRedirect(req.getContextPath() + "/admin/categories");
                    return;
                }

                Map<String, Object> result = categoryService.deleteCategory(catId);
                if (result.containsKey("success")) {
                    setSessionMessage(req, "success", "Category deleted successfully.");
                } else {
                    setSessionMessage(req, "error", (String) result.get("errorMessage"));
                }
                resp.sendRedirect(req.getContextPath() + "/admin/categories");
                break;
            }

            default:
                resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }

    // ---------------------------------------------------------------
    // Helper: store flash messages in session for redirect
    // ---------------------------------------------------------------
    private void setSessionMessage(HttpServletRequest req, String type, String message) {
        HttpSession session = req.getSession(true);
        if ("success".equals(type)) session.setAttribute("successMessage", message);
        else                        session.setAttribute("errorMessage",   message);
    }
}
