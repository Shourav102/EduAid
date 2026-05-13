package com.eduaid.controller;

import com.eduaid.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;

@WebServlet("/api/*")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 100,
        maxRequestSize = 1024 * 1024 * 110
)
public class ResourceApiController extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/resources";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        String path = req.getPathInfo();
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            out.print("{\"error\":\"Not logged in\"}");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("userRole");

        try {
            // Donor: Get their donation stats
            if ("/donor/stats".equals(path)) {
                String json = getDonorStats(userId);
                out.print(json);
            }
            // Donor: Get their donations list
            else if ("/donor/donations".equals(path)) {
                String json = getDonorDonations(userId);
                out.print(json);
            }
            // Recipient: Get stats
            else if ("/recipient/stats".equals(path)) {
                String json = getRecipientStats(userId);
                out.print(json);
            }
            // Available resources (for recipients to browse and download)
            else if ("/resources/available".equals(path)) {
                String json = getAvailableResources();
                out.print(json);
            }
            // Get recipient's own wishlist
            else if ("/wishlist/my".equals(path)) {
                String json = getMyWishlistItems(userId);
                out.print(json);
            }
            // Get ALL wishlist items (for donors to see)
            else if ("/wishlist/all".equals(path) && "DONOR".equals(role)) {
                String json = getAllWishlistItems();
                out.print(json);
            }
            // Admin: Get all resources
            else if ("/admin/resources".equals(path) && "ADMIN".equals(role)) {
                String json = getAllResources();
                out.print(json);
            }
            // Admin: Get chart data for dashboard
            else if ("/admin/chart-data".equals(path) && "ADMIN".equals(role)) {
                String json = getChartData();
                out.print(json);
            }
            // Download a resource
            else if (path != null && path.startsWith("/resources/download/")) {
                int resourceId = Integer.parseInt(path.substring("/resources/download/".length()));
                String json = downloadResource(resourceId, userId);
                out.print(json);
            }
            else {
                out.print("{\"error\":\"Invalid endpoint\"}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.print("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        String path = req.getPathInfo();
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            out.print("{\"error\":\"Not logged in\"}");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("userRole");

        try {
            // Donor: Add new resource donation
            if ("/donor/add".equals(path)) {
                String title = req.getParameter("title");
                String description = req.getParameter("description");
                int categoryId = Integer.parseInt(req.getParameter("categoryId"));
                String condition = req.getParameter("condition");

                String imagePath = null;
                Part filePart = req.getPart("image");
                if (filePart != null && filePart.getSize() > 0) {
                    String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();

                    String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                    filePart.write(uploadPath + File.separator + fileName);
                    imagePath = UPLOAD_DIR + "/" + fileName;
                }

                String sql = "INSERT INTO resources (title, description, category_id, donor_id, condition_type, image_path, status) VALUES (?, ?, ?, ?, ?, ?, 'PENDING')";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, title);
                    ps.setString(2, description);
                    ps.setInt(3, categoryId);
                    ps.setInt(4, userId);
                    ps.setString(5, condition);
                    ps.setString(6, imagePath);
                    ps.executeUpdate();
                    out.print("{\"success\":true}");
                }
            }
            // Recipient: Create a wishlist item (no approval needed)
            else if ("/wishlist/create".equals(path)) {
                String title = req.getParameter("title");
                String description = req.getParameter("description");
                String categoryIdStr = req.getParameter("categoryId");

                Integer categoryId = null;
                if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                    categoryId = Integer.parseInt(categoryIdStr);
                }

                String sql = "INSERT INTO wishlist (recipient_id, title, description, category_id, status) VALUES (?, ?, ?, ?, 'ACTIVE')";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, userId);
                    ps.setString(2, title);
                    ps.setString(3, description);
                    if (categoryId != null) {
                        ps.setInt(4, categoryId);
                    } else {
                        ps.setNull(4, Types.INTEGER);
                    }
                    ps.executeUpdate();
                    out.print("{\"success\":true}");
                }
            }
            // Delete wishlist item
            else if ("/wishlist/delete".equals(path)) {
                int wishlistId = Integer.parseInt(req.getParameter("wishlistId"));
                String sql = "DELETE FROM wishlist WHERE wishlist_id = ?";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, wishlistId);
                    ps.executeUpdate();
                    out.print("{\"success\":true}");
                }
            }
            // Add resource to wishlist (for saving resources)
            else if ("/wishlist/add-resource".equals(path)) {
                int resourceId = Integer.parseInt(req.getParameter("resourceId"));
                String sql = "INSERT INTO wishlist (recipient_id, title, description, resource_id, status) " +
                        "SELECT ?, r.title, r.description, ?, 'ACTIVE' FROM resources r WHERE r.resource_id = ?";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, resourceId);
                    ps.setInt(3, resourceId);
                    ps.executeUpdate();
                    out.print("{\"success\":true}");
                } catch (SQLException e) {
                    out.print("{\"error\":\"Already in wishlist\"}");
                }
            }
            // Admin: Approve a donation
            else if ("/admin/resource/approve".equals(path) && "ADMIN".equals(role)) {
                int resourceId = Integer.parseInt(req.getParameter("resourceId"));
                String sql = "UPDATE resources SET status = 'AVAILABLE' WHERE resource_id = ?";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, resourceId);
                    ps.executeUpdate();
                    out.print("{\"success\":true}");
                }
            }
            // Admin: Reject a donation
            else if ("/admin/resource/reject".equals(path) && "ADMIN".equals(role)) {
                int resourceId = Integer.parseInt(req.getParameter("resourceId"));
                String sql = "UPDATE resources SET status = 'REJECTED' WHERE resource_id = ?";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, resourceId);
                    ps.executeUpdate();
                    out.print("{\"success\":true}");
                }
            }
            else {
                out.print("{\"error\":\"Invalid endpoint\"}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.print("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\":\"Server error: " + escapeJson(e.getMessage()) + "\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        String path = req.getPathInfo();
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            out.print("{\"error\":\"Not logged in\"}");
            return;
        }

        try {
            // Delete a resource
            if (path != null && path.startsWith("/donor/delete/")) {
                int resourceId = Integer.parseInt(path.substring("/donor/delete/".length()));

                String deleteWishlist = "DELETE FROM wishlist WHERE resource_id = ?";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(deleteWishlist)) {
                    ps.setInt(1, resourceId);
                    ps.executeUpdate();
                }
                String sql = "DELETE FROM resources WHERE resource_id = ?";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, resourceId);
                    ps.executeUpdate();
                    out.print("{\"success\":true}");
                }
            }
            // Remove from wishlist
            else if (path != null && path.startsWith("/wishlist/remove/")) {
                int wishlistId = Integer.parseInt(path.substring("/wishlist/remove/".length()));
                String sql = "DELETE FROM wishlist WHERE wishlist_id = ?";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, wishlistId);
                    ps.executeUpdate();
                    out.print("{\"success\":true}");
                }
            }
            else {
                out.print("{\"error\":\"Invalid endpoint\"}");
            }
        } catch (SQLException e) {
            out.print("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    // ==================== Helper Methods ====================

    private String getDonorStats(int userId) throws SQLException {
        StringBuilder json = new StringBuilder();
        json.append("{");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT status, COUNT(*) as count FROM resources WHERE donor_id = ? GROUP BY status")) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            int total = 0, pending = 0, available = 0, rejected = 0, claimed = 0;
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("count");
                total += count;
                if ("PENDING".equals(status)) pending = count;
                else if ("AVAILABLE".equals(status)) available = count;
                else if ("REJECTED".equals(status)) rejected = count;
                else if ("CLAIMED".equals(status)) claimed = count;
            }
            json.append("\"total\":").append(total).append(",");
            json.append("\"pending\":").append(pending).append(",");
            json.append("\"available\":").append(available).append(",");
            json.append("\"rejected\":").append(rejected).append(",");
            json.append("\"claimed\":").append(claimed);
        }
        json.append("}");
        return json.toString();
    }

    private String getDonorDonations(int userId) throws SQLException {
        StringBuilder json = new StringBuilder();
        json.append("[");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT r.*, c.name as categoryName FROM resources r " +
                             "LEFT JOIN categories c ON r.category_id = c.category_id " +
                             "WHERE r.donor_id = ? ORDER BY r.created_at DESC")) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                json.append("{");
                json.append("\"resourceId\":").append(rs.getInt("resource_id")).append(",");
                json.append("\"title\":\"").append(escapeJson(rs.getString("title"))).append("\",");
                json.append("\"description\":\"").append(escapeJson(rs.getString("description"))).append("\",");
                json.append("\"categoryName\":\"").append(escapeJson(rs.getString("categoryName"))).append("\",");
                json.append("\"conditionType\":\"").append(rs.getString("condition_type")).append("\",");
                json.append("\"imagePath\":\"").append(escapeJson(rs.getString("image_path"))).append("\",");
                json.append("\"status\":\"").append(rs.getString("status")).append("\",");
                json.append("\"createdAt\":\"").append(rs.getTimestamp("created_at")).append("\"");
                json.append("}");
            }
        }
        json.append("]");
        return json.toString();
    }

    private String getRecipientStats(int userId) throws SQLException {
        StringBuilder json = new StringBuilder();
        json.append("{");
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM wishlist WHERE recipient_id = ?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            json.append("\"wishlistCount\":").append(rs.next() ? rs.getInt(1) : 0);
        }
        json.append("}");
        return json.toString();
    }

    private String getAvailableResources() throws SQLException {
        StringBuilder json = new StringBuilder();
        json.append("[");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT r.*, c.name as categoryName, u.full_name as donorName " +
                             "FROM resources r " +
                             "LEFT JOIN categories c ON r.category_id = c.category_id " +
                             "LEFT JOIN users u ON r.donor_id = u.user_id " +
                             "WHERE r.status = 'AVAILABLE' ORDER BY r.created_at DESC")) {
            ResultSet rs = ps.executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                json.append("{");
                json.append("\"resourceId\":").append(rs.getInt("resource_id")).append(",");
                json.append("\"title\":\"").append(escapeJson(rs.getString("title"))).append("\",");
                json.append("\"description\":\"").append(escapeJson(rs.getString("description"))).append("\",");
                json.append("\"categoryName\":\"").append(escapeJson(rs.getString("categoryName"))).append("\",");
                json.append("\"conditionType\":\"").append(rs.getString("condition_type")).append("\",");
                json.append("\"donorName\":\"").append(escapeJson(rs.getString("donorName"))).append("\",");
                json.append("\"imagePath\":\"").append(escapeJson(rs.getString("image_path"))).append("\"");
                json.append("}");
            }
        }
        json.append("]");
        return json.toString();
    }

    private String downloadResource(int resourceId, int userId) throws SQLException {
        String sql = "SELECT image_path, title FROM resources WHERE resource_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, resourceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String imagePath = rs.getString("image_path");
                if (imagePath != null && !imagePath.isEmpty()) {
                    return "{\"success\":true, \"filePath\":\"" + escapeJson(imagePath) + "\", \"title\":\"" + escapeJson(rs.getString("title")) + "\"}";
                } else {
                    return "{\"success\":false, \"error\":\"No file attached to this resource\"}";
                }
            }
        }
        return "{\"success\":false, \"error\":\"Resource not found\"}";
    }

    private String getMyWishlistItems(int userId) throws SQLException {
        StringBuilder json = new StringBuilder();
        json.append("[");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT w.*, c.name as categoryName " +
                             "FROM wishlist w " +
                             "LEFT JOIN categories c ON w.category_id = c.category_id " +
                             "WHERE w.recipient_id = ? AND w.status = 'ACTIVE' ORDER BY w.created_at DESC")) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                json.append("{");
                json.append("\"wishlistId\":").append(rs.getInt("wishlist_id")).append(",");
                json.append("\"title\":\"").append(escapeJson(rs.getString("title"))).append("\",");
                json.append("\"description\":\"").append(escapeJson(rs.getString("description"))).append("\",");
                json.append("\"categoryName\":\"").append(escapeJson(rs.getString("categoryName"))).append("\",");
                json.append("\"createdAt\":\"").append(rs.getTimestamp("created_at")).append("\"");
                json.append("}");
            }
        }
        json.append("]");
        return json.toString();
    }

    private String getAllWishlistItems() throws SQLException {
        StringBuilder json = new StringBuilder();
        json.append("[");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT w.*, u.full_name as recipientName, c.name as categoryName " +
                             "FROM wishlist w " +
                             "JOIN users u ON w.recipient_id = u.user_id " +
                             "LEFT JOIN categories c ON w.category_id = c.category_id " +
                             "WHERE w.status = 'ACTIVE' ORDER BY w.created_at DESC")) {
            ResultSet rs = ps.executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                json.append("{");
                json.append("\"wishlistId\":").append(rs.getInt("wishlist_id")).append(",");
                json.append("\"recipientName\":\"").append(escapeJson(rs.getString("recipientName"))).append("\",");
                json.append("\"title\":\"").append(escapeJson(rs.getString("title"))).append("\",");
                json.append("\"description\":\"").append(escapeJson(rs.getString("description"))).append("\",");
                json.append("\"categoryName\":\"").append(escapeJson(rs.getString("categoryName"))).append("\",");
                json.append("\"createdAt\":\"").append(rs.getTimestamp("created_at")).append("\"");
                json.append("}");
            }
        }
        json.append("]");
        return json.toString();
    }

    private String getAllResources() throws SQLException {
        StringBuilder json = new StringBuilder();
        json.append("[");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT r.*, c.name as categoryName, u.full_name as donorName " +
                             "FROM resources r " +
                             "LEFT JOIN categories c ON r.category_id = c.category_id " +
                             "LEFT JOIN users u ON r.donor_id = u.user_id " +
                             "ORDER BY r.created_at DESC")) {
            ResultSet rs = ps.executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                json.append("{");
                json.append("\"resourceId\":").append(rs.getInt("resource_id")).append(",");
                json.append("\"title\":\"").append(escapeJson(rs.getString("title"))).append("\",");
                json.append("\"description\":\"").append(escapeJson(rs.getString("description"))).append("\",");
                json.append("\"categoryName\":\"").append(escapeJson(rs.getString("categoryName"))).append("\",");
                json.append("\"donorName\":\"").append(escapeJson(rs.getString("donorName"))).append("\",");
                json.append("\"conditionType\":\"").append(rs.getString("condition_type")).append("\",");
                json.append("\"status\":\"").append(rs.getString("status")).append("\",");
                json.append("\"createdAt\":\"").append(rs.getTimestamp("created_at")).append("\"");
                json.append("}");
            }
        }
        json.append("]");
        return json.toString();
    }

    private String getChartData() throws SQLException {
        StringBuilder json = new StringBuilder();
        json.append("{");

        try (Connection conn = DBConnection.getConnection()) {
            // Get user distribution by role
            String userSql = "SELECT role, COUNT(*) as count FROM users GROUP BY role";
            try (PreparedStatement ps = conn.prepareStatement(userSql);
                 ResultSet rs = ps.executeQuery()) {

                int adminCount = 0, donorCount = 0, recipientCount = 0;
                while (rs.next()) {
                    String role = rs.getString("role");
                    int count = rs.getInt("count");
                    if ("ADMIN".equals(role)) adminCount = count;
                    else if ("DONOR".equals(role)) donorCount = count;
                    else if ("RECIPIENT".equals(role)) recipientCount = count;
                }
                json.append("\"adminCount\":").append(adminCount).append(",");
                json.append("\"donorCount\":").append(donorCount).append(",");
                json.append("\"recipientCount\":").append(recipientCount).append(",");
            }

            // Get donations by category
            String catSql = "SELECT c.name, COUNT(r.resource_id) as count " +
                    "FROM categories c " +
                    "LEFT JOIN resources r ON c.category_id = r.category_id " +
                    "GROUP BY c.category_id ORDER BY c.name";
            try (PreparedStatement ps = conn.prepareStatement(catSql);
                 ResultSet rs = ps.executeQuery()) {

                StringBuilder labels = new StringBuilder();
                StringBuilder counts = new StringBuilder();
                boolean first = true;
                while (rs.next()) {
                    if (!first) {
                        labels.append(",");
                        counts.append(",");
                    }
                    first = false;
                    labels.append("\"").append(escapeJson(rs.getString("name"))).append("\"");
                    counts.append(rs.getInt("count"));
                }
                json.append("\"categoryLabels\":[").append(labels).append("],");
                json.append("\"categoryCounts\":[").append(counts).append("]");
            }
        }

        json.append("}");
        return json.toString();
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}