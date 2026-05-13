package com.eduaid.controller;

import com.eduaid.dao.UserDAO;
import com.eduaid.model.User;
import com.eduaid.service.UserService;
import com.eduaid.util.DBConnection;
import com.eduaid.util.PasswordUtil;
import com.eduaid.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

@WebServlet("/auth")
public class AuthController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserService userService;

    private static final String COOKIE_NAME = "eduaid_remember";
    private static final int COOKIE_MAX_AGE = 60 * 60 * 24 * 7;
    private static final long RESET_TOKEN_EXPIRY_MS = 3600000; // 1 hour

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

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
            case "forgot-password":
                req.getRequestDispatcher("/views/common/forgot-password.jsp").forward(req, resp);
                break;
            case "reset-password":
                req.getRequestDispatcher("/views/common/reset-password.jsp").forward(req, resp);
                break;
            case "login":
            default:
                prefillLoginFromCookie(req);
                req.getRequestDispatcher("/views/common/login.jsp").forward(req, resp);
                break;
        }
    }

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
            case "forgot-password":
                handleForgotPassword(req, resp);
                break;
            case "reset-password":
                handleResetPassword(req, resp);
                break;
            case "login":
            default:
                handleLogin(req, resp);
                break;
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String remember = req.getParameter("rememberMe");

        Map<String, Object> result = userService.loginUser(email, password);

        if (result.containsKey("user")) {
            User user = (User) result.get("user");

            HttpSession session = req.getSession(true);
            session.setAttribute("loggedInUser", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userName", user.getFullName());
            session.setMaxInactiveInterval(60 * 30);

            if ("on".equals(remember) || "true".equals(remember)) {
                Cookie cookie = new Cookie(COOKIE_NAME, ValidationUtil.sanitise(email));
                cookie.setMaxAge(COOKIE_MAX_AGE);
                cookie.setHttpOnly(true);
                cookie.setPath("/");
                resp.addCookie(cookie);
            } else {
                clearRememberCookie(resp);
            }

            resp.sendRedirect(req.getContextPath() + "/home");

        } else {
            String errorMessage = (String) result.get("errorMessage");
            req.setAttribute("errorMessage", errorMessage);
            req.setAttribute("email", ValidationUtil.sanitise(email));
            req.getRequestDispatcher("/views/common/login.jsp").forward(req, resp);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirmPass = req.getParameter("confirmPassword");
        String role = req.getParameter("role");
        String dob = req.getParameter("dob");
        String address = req.getParameter("address");
        String institution = req.getParameter("institution");

        Map<String, Object> result = userService.registerUser(
                fullName, email, phone, password, confirmPass,
                role, dob, address, institution);

        if (result.containsKey("success")) {
            req.getSession().setAttribute("registrationSuccess",
                    "Registration successful! Your account is pending admin approval. "
                            + "You will be able to log in once approved.");
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");

        } else {
            @SuppressWarnings("unchecked")
            Map<String, String> errors = (Map<String, String>) result.get("errors");
            req.setAttribute("errors", errors);
            req.setAttribute("fullName", ValidationUtil.sanitise(fullName));
            req.setAttribute("email", ValidationUtil.sanitise(email));
            req.setAttribute("phone", ValidationUtil.sanitise(phone));
            req.setAttribute("role", ValidationUtil.sanitise(role));
            req.setAttribute("dob", ValidationUtil.sanitise(dob));
            req.setAttribute("address", ValidationUtil.sanitise(address));
            req.setAttribute("institution", ValidationUtil.sanitise(institution));

            req.getRequestDispatcher("/views/common/register.jsp").forward(req, resp);
        }
    }

    private void handleForgotPassword(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Please enter your email address.");
            req.getRequestDispatcher("/views/common/forgot-password.jsp").forward(req, resp);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByEmail(email);

            if (user == null) {
                req.setAttribute("errorMessage", "No account found with this email address.");
                req.getRequestDispatcher("/views/common/forgot-password.jsp").forward(req, resp);
                return;
            }

            // Generate reset token
            String token = UUID.randomUUID().toString();
            long expiryTime = System.currentTimeMillis() + RESET_TOKEN_EXPIRY_MS;

            String sql = "UPDATE users SET reset_token = ?, reset_token_expiry = ? WHERE email = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, token);
                ps.setLong(2, expiryTime);
                ps.setString(3, email);
                ps.executeUpdate();
            }

            // Send email
            boolean emailSent = sendResetEmail(email, token, req);

            if (emailSent) {
                req.setAttribute("successMessage", "Password reset link has been sent to your email address.");
            } else {
                // Fallback: display the link (for testing without email)
                String resetLink = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort()
                        + req.getContextPath() + "/auth?action=reset-password&token=" + token + "&email=" + email;
                req.setAttribute("successMessage", "Reset link (email not configured): <a href='" + resetLink + "'>" + resetLink + "</a>");
            }
            req.getRequestDispatcher("/views/common/forgot-password.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "A server error occurred. Please try again later.");
            req.getRequestDispatcher("/views/common/forgot-password.jsp").forward(req, resp);
        }
    }

    private void handleResetPassword(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String token = req.getParameter("token");
        String email = req.getParameter("email");
        String newPassword = req.getParameter("password");

        if (token == null || email == null || newPassword == null) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        try {
            String sql = "SELECT reset_token, reset_token_expiry FROM users WHERE email = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String storedToken = rs.getString("reset_token");
                    long expiry = rs.getLong("reset_token_expiry");

                    if (storedToken == null || !storedToken.equals(token) || System.currentTimeMillis() > expiry) {
                        req.setAttribute("errorMessage", "Invalid or expired reset link. Please request a new one.");
                        req.getRequestDispatcher("/views/common/reset-password.jsp").forward(req, resp);
                        return;
                    }

                    // Validate password strength
                    String passwordValidation = ValidationUtil.validatePassword(newPassword);
                    if (passwordValidation != null) {
                        req.setAttribute("errorMessage", passwordValidation);
                        req.getRequestDispatcher("/views/common/reset-password.jsp").forward(req, resp);
                        return;
                    }

                    // Update password
                    String hashedPassword = PasswordUtil.hashPassword(newPassword);
                    String updateSql = "UPDATE users SET password_hash = ?, reset_token = NULL, reset_token_expiry = NULL WHERE email = ?";
                    try (PreparedStatement ps2 = conn.prepareStatement(updateSql)) {
                        ps2.setString(1, hashedPassword);
                        ps2.setString(2, email);
                        ps2.executeUpdate();
                    }

                    req.getSession().setAttribute("successMessage", "Password reset successfully! Please login with your new password.");
                    resp.sendRedirect(req.getContextPath() + "/auth?action=login");

                } else {
                    req.setAttribute("errorMessage", "Invalid reset request.");
                    req.getRequestDispatcher("/views/common/reset-password.jsp").forward(req, resp);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "A server error occurred. Please try again later.");
            req.getRequestDispatcher("/views/common/reset-password.jsp").forward(req, resp);
        }
    }

    private boolean sendResetEmail(String toEmail, String token, HttpServletRequest req) {
        // Email configuration
        final String fromEmail = "shourav219@gmail.com";
        final String emailPassword = "g5875442r";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        String resetLink = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort()
                + req.getContextPath() + "/auth?action=reset-password&token=" + token + "&email=" + toEmail;

        String subject = "EduAid - Password Reset Request";
        String body = "<html>"
                + "<body style='font-family: Arial, sans-serif;'>"
                + "<div style='max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e2e8e6; border-radius: 10px;'>"
                + "<h2 style='color: #1a6b4a;'>EduAid Password Reset</h2>"
                + "<p>Hello,</p>"
                + "<p>We received a request to reset your password for your EduAid account.</p>"
                + "<p>Click the link below to reset your password. This link will expire in 1 hour.</p>"
                + "<p><a href='" + resetLink + "' style='background-color: #1a6b4a; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block;'>Reset Password</a></p>"
                + "<p>If you did not request this, please ignore this email.</p>"
                + "<hr>"
                + "<p style='color: #666; font-size: 12px;'>EduAid - Reducing educational inequality</p>"
                + "</div>"
                + "</body>"
                + "</html>";

        try {
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromEmail, emailPassword);
                }
            });

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject(subject);
            message.setContent(body, "text/html");

            Transport.send(message);
            return true;

        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        clearRememberCookie(resp);
        resp.sendRedirect(req.getContextPath() + "/auth?action=login");
    }

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

    private void clearRememberCookie(HttpServletResponse resp) {
        Cookie cookie = new Cookie(COOKIE_NAME, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        resp.addCookie(cookie);
    }
}