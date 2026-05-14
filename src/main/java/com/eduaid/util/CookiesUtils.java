package com.eduaid.util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * CookiesUtils - Utility class for cookie management operations.
 * Provides helper methods for creating, reading, and deleting cookies.
 */
public class CookiesUtils {

    private static final int DEFAULT_MAX_AGE = 7 * 24 * 60 * 60; // 7 days

    /**
     * Creates a new cookie with the specified name and value.
     *
     * @param resp HttpServletResponse object
     * @param name Cookie name
     * @param value Cookie value
     * @param maxAge Cookie lifetime in seconds
     * @param httpOnly Whether cookie should be HttpOnly (security)
     */
    public static void createCookie(HttpServletResponse resp, String name, String value,
                                    int maxAge, boolean httpOnly) {
        Cookie cookie = new Cookie(name, value);
        cookie.setMaxAge(maxAge);
        cookie.setPath("/");
        cookie.setHttpOnly(httpOnly);
        resp.addCookie(cookie);
    }

    /**
     * Creates a remember-me cookie (7 days expiry, HttpOnly enabled).
     *
     * @param resp HttpServletResponse object
     * @param email User's email to store in cookie
     */
    public static void createRememberMeCookie(HttpServletResponse resp, String email) {
        createCookie(resp, "rememberMe", email, DEFAULT_MAX_AGE, true);
    }

    /**
     * Gets a cookie value by name.
     *
     * @param req HttpServletRequest object
     * @param name Cookie name to search for
     * @return Cookie value if found, null otherwise
     */
    public static String getCookieValue(HttpServletRequest req, String name) {
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (name.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    /**
     * Deletes a cookie by setting its max age to 0.
     *
     * @param resp HttpServletResponse object
     * @param name Cookie name to delete
     */
    public static void deleteCookie(HttpServletResponse resp, String name) {
        Cookie cookie = new Cookie(name, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        resp.addCookie(cookie);
    }

    /**
     * Checks if remember-me cookie exists.
     *
     * @param req HttpServletRequest object
     * @return true if remember-me cookie exists
     */
    public static boolean hasRememberMeCookie(HttpServletRequest req) {
        return getCookieValue(req, "rememberMe") != null;
    }
}