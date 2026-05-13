package com.eduaid.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * AuthFilter - Servlet Filter that enforces authentication and role-based access.
 *
 * Applied to ALL URLs ("/*").
 * Logic:
 *  1. Public paths (login, register, home, about, contact, CSS, JS) are always allowed through.
 *  2. Any /admin/* path requires role = ADMIN.
 *  3. Any /user/*  path requires role = DONOR or RECIPIENT.
 *  4. Unauthenticated users trying to access protected paths → redirected to login.
 *  5. Wrong-role users → redirected to error403.jsp.
 *
 * MVC Role: FILTER (middleware - sits before any Controller)
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    // Paths that do NOT require authentication (public access)
    private static final Set<String> PUBLIC_PATHS = new HashSet<>(Arrays.asList(
            "/auth",
            "/about",
            "/contact",
            "/home",
            "/index",
            "/error"
    ));

    // Static resource prefixes that are always public
    private static final String[] PUBLIC_PREFIXES = {
            "/css/", "/js/", "/images/", "/favicon.ico"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialisation needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String contextPath  = req.getContextPath();
        String requestURI   = req.getRequestURI();
        // Strip context path to get the path relative to the app root
        String relativePath = requestURI.substring(contextPath.length());

        // ---- Always allow static resources and public pages ----
        if (isPublicResource(relativePath)) {
            chain.doFilter(request, response);
            return;
        }

        // ---- Check session ----
        HttpSession session = req.getSession(false);
        String userRole = (session != null) ? (String) session.getAttribute("userRole") : null;

        // ---- Not logged in → go to login ----
        if (userRole == null) {
            resp.sendRedirect(contextPath + "/auth?action=login");
            return;
        }

        // ---- Enforce role-based path restrictions ----
        if (relativePath.startsWith("/admin")) {
            if (!"ADMIN".equals(userRole)) {
                // Non-admin trying to access admin area
                req.getRequestDispatcher("/views/common/error403.jsp").forward(req, resp);
                return;
            }
        }

        if (relativePath.startsWith("/user")) {
            if ("ADMIN".equals(userRole)) {
                // Admin should use /admin routes, redirect to admin dashboard
                resp.sendRedirect(contextPath + "/admin/dashboard");
                return;
            }
        }

        // ---- All checks passed, continue the request ----
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }

    // ---------------------------------------------------------------
    // Helper: check if path is public
    // ---------------------------------------------------------------
    private boolean isPublicResource(String path) {
        // Check static resource prefixes
        for (String prefix : PUBLIC_PREFIXES) {
            if (path.startsWith(prefix)) return true;
        }
        // Check root path and index
        if (path.equals("/") || path.isEmpty()) return true;

        // Check registered public paths
        for (String publicPath : PUBLIC_PATHS) {
            if (path.startsWith(publicPath)) return true;
        }
        return false;
    }
}