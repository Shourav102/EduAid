package com.eduaid.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * SessionUtils - Utility class for session management operations.
 * Provides helper methods for creating, validating, and destroying sessions.
 */
public class SessionUtils {

    /**
     * Creates a new session and stores user attributes.
     *
     * @param req HttpServletRequest object
     * @param userId User's ID
     * @param userRole User's role (ADMIN/DONOR/RECIPIENT)
     * @param userName User's full name
     * @return HttpSession object with user attributes set
     */
    public static HttpSession createSession(HttpServletRequest req, int userId, String userRole, String userName) {
        HttpSession session = req.getSession(true);
        session.setAttribute("userId", userId);
        session.setAttribute("userRole", userRole);
        session.setAttribute("userName", userName);
        session.setMaxInactiveInterval(30 * 60); // 30 minutes timeout
        return session;
    }

    /**
     * Checks if user is logged in.
     *
     * @param req HttpServletRequest object
     * @return true if session exists and contains userId attribute
     */
    public static boolean isLoggedIn(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && session.getAttribute("userId") != null;
    }

    /**
     * Gets the current user's role from session.
     *
     * @param req HttpServletRequest object
     * @return user role string (ADMIN/DONOR/RECIPIENT) or null if not logged in
     */
    public static String getUserRole(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null ? (String) session.getAttribute("userRole") : null;
    }

    /**
     * Gets the current user's ID from session.
     *
     * @param req HttpServletRequest object
     * @return user ID or -1 if not logged in
     */
    public static int getUserId(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && session.getAttribute("userId") != null
                ? (int) session.getAttribute("userId") : -1;
    }

    /**
     * Invalidates the current session (logout).
     *
     * @param req HttpServletRequest object
     */
    public static void invalidateSession(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}