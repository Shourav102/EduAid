package com.eduaid.controller;

import com.eduaid.model.User;
import com.eduaid.service.UserService;
import com.eduaid.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

/**
 * AuthController - Single servlet handling all authentication actions:
 *   GET  /auth?action=login     → show login page
 *   POST /auth?action=login     → process login
 *   GET  /auth?action=register  → show register page
 *   POST /auth?action=register  → process registration
 *   GET  /auth?action=logout    → destroy session & redirect
 *
 * MVC Role: CONTROLLER
 * Delegates business logic to UserService.
 * Forwards to JSP views for rendering.
 */
@WebServlet("/auth")
public class AuthController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserService userService;

    // Cookie configuration
    private static final String  COOKIE_NAME    = "eduaid_remember";
    private static final int     COOKIE_MAX_AGE = 60 * 60 * 24 * 7; // 7 days in seconds

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    // ---------------------------------------------------------------
    // GET - show forms
    // ---------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "login";

        switch (action) {
            case "register":
                req.getRequestDispatcher("/views/common/register.jsp").forward(req, resp);
                break;
            case "logout":
                handleLogout(req, resp);
                break;
            case "login":
            default:
                // Pre-fill email from remember-me cookie if present
                prefillLoginFromCookie(req);
                req.getRequestDispatcher("/views/common/login.jsp").forward(req, resp);
                break;
        }
    }

    // ---------------------------------------------------------------
    // POST - process forms
    // ---------------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "login";

        switch (action) {
            case "register":
                handleRegister(req, resp);
                break;
            case "login":
            default:
                handleLogin(req, resp);
                break;
        }
    }

    // ---------------------------------------------------------------
    // LOGIN handler
    // ---------------------------------------------------------------
    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String remember = req.getParameter("rememberMe"); // checkbox value

        Map<String, Object> result = userService.loginUser(email, password);

        if (result.containsKey("user")) {
            // ---- Login successful ----
            User user = (User) result.get("user");

            // Create HTTP session and store user
            HttpSession session = req.getSession(true);
            session.setAttribute("loggedInUser", user);
            session.setAttribute("userId",       user.getUserId());
            session.setAttribute("userRole",     user.getRole());
            session.setAttribute("userName",     user.getFullName());
            session.setMaxInactiveInterval(60 * 30); // 30 minutes session timeout

            // Remember-me cookie
            if ("on".equals(remember) || "true".equals(remember)) {
                Cookie cookie = new Cookie(COOKIE_NAME, ValidationUtil.sanitise(email));
                cookie.setMaxAge(COOKIE_MAX_AGE);
                cookie.setHttpOnly(true);   // not accessible via JavaScript (security)
                cookie.setPath("/");
                resp.addCookie(cookie);
            } else {
                // Clear any existing remember-me cookie on explicit login without checkbox
                clearRememberCookie(resp);
            }

            // Role-based redirect after login
            switch (user.getRole()) {
                case "ADMIN":
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                    break;
                case "DONOR":
                case "RECIPIENT":
                default:
                    resp.sendRedirect(req.getContextPath() + "/user/dashboard");
                    break;
            }

        } else {
            // ---- Login failed ----
            String errorMessage = (String) result.get("errorMessage");
            req.setAttribute("errorMessage", errorMessage);
            req.setAttribute("email", ValidationUtil.sanitise(email)); // repopulate field
            req.getRequestDispatcher("/views/common/login.jsp").forward(req, resp);
        }
    }

    // ---------------------------------------------------------------
    // REGISTER handler
    // ---------------------------------------------------------------
    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Collect all form fields
        String fullName    = req.getParameter("fullName");
        String email       = req.getParameter("email");
        String phone       = req.getParameter("phone");
        String password    = req.getParameter("password");
        String confirmPass = req.getParameter("confirmPassword");
        String role        = req.getParameter("role");
        String dob         = req.getParameter("dob");
        String address     = req.getParameter("address");
        String institution = req.getParameter("institution");

        Map<String, Object> result = userService.registerUser(
                fullName, email, phone, password, confirmPass,
                role, dob, address, institution);

        if (result.containsKey("success")) {
            // Registration succeeded - redirect to login with success message
            req.getSession().setAttribute("registrationSuccess",
                    "Registration successful! Your account is pending admin approval. "
                  + "You will be able to log in once approved.");
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");

        } else {
            // Validation errors - return to form with errors and repopulate fields
            @SuppressWarnings("unchecked")
            Map<String, String> errors = (Map<String, String>) result.get("errors");
            req.setAttribute("errors",      errors);
            req.setAttribute("fullName",    ValidationUtil.sanitise(fullName));
            req.setAttribute("email",       ValidationUtil.sanitise(email));
            req.setAttribute("phone",       ValidationUtil.sanitise(phone));
            req.setAttribute("role",        ValidationUtil.sanitise(role));
            req.setAttribute("dob",         ValidationUtil.sanitise(dob));
            req.setAttribute("address",     ValidationUtil.sanitise(address));
            req.setAttribute("institution", ValidationUtil.sanitise(institution));

            req.getRequestDispatcher("/views/common/register.jsp").forward(req, resp);
        }
    }

    // ---------------------------------------------------------------
    // LOGOUT handler
    // ---------------------------------------------------------------
    private void handleLogout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate(); // destroy all session attributes
        }
        clearRememberCookie(resp); // remove remember-me cookie
        resp.sendRedirect(req.getContextPath() + "/auth?action=login");
    }

    // ---------------------------------------------------------------
    // Helpers
    // ---------------------------------------------------------------

    /** Pre-fills the email field from the remember-me cookie if present. */
    private void prefillLoginFromCookie(HttpServletRequest req) {
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (COOKIE_NAME.equals(cookie.getName())) {
                    req.setAttribute("rememberedEmail", cookie.getValue());
                    break;
                }
            }
        }
    }

    /** Deletes the remember-me cookie from the browser. */
    private void clearRememberCookie(HttpServletResponse resp) {
        Cookie cookie = new Cookie(COOKIE_NAME, "");
        cookie.setMaxAge(0); // age 0 = delete immediately
        cookie.setPath("/");
        resp.addCookie(cookie);
    }
}
