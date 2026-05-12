package com.eduaid.dao;

import com.eduaid.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class WishlistDAO {

    // Add to wishlist
    public boolean addToWishlist(int recipientId, int resourceId) throws SQLException {
        String sql = "INSERT INTO wishlist (recipient_id, resource_id) VALUES (?, ?) " +
                "ON DUPLICATE KEY UPDATE created_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recipientId);
            ps.setInt(2, resourceId);
            return ps.executeUpdate() > 0;
        }
    }

    // Remove from wishlist
    public boolean removeFromWishlist(int wishlistId) throws SQLException {
        String sql = "DELETE FROM wishlist WHERE wishlist_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, wishlistId);
            return ps.executeUpdate() > 0;
        }
    }

    // Get wishlist by recipient
    public List<Map<String, Object>> getWishlist(int recipientId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT w.wishlist_id, w.resource_id, w.created_at, " +
                "r.title, r.description, r.condition_type, r.status, c.name as category_name " +
                "FROM wishlist w " +
                "JOIN resources r ON w.resource_id = r.resource_id " +
                "LEFT JOIN categories c ON r.category_id = c.category_id " +
                "WHERE w.recipient_id = ? ORDER BY w.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recipientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("wishlistId", rs.getInt("wishlist_id"));
                    item.put("resourceId", rs.getInt("resource_id"));
                    item.put("title", rs.getString("title"));
                    item.put("description", rs.getString("description"));
                    item.put("conditionType", rs.getString("condition_type"));
                    item.put("status", rs.getString("status"));
                    item.put("categoryName", rs.getString("category_name"));
                    item.put("createdAt", rs.getTimestamp("created_at").toString());
                    list.add(item);
                }
            }
        }
        return list;
    }

    // Check if resource is in wishlist
    public boolean isInWishlist(int recipientId, int resourceId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE recipient_id = ? AND resource_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recipientId);
            ps.setInt(2, resourceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
}