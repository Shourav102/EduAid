package com.eduaid.dao;

import com.eduaid.model.Resource;
import com.eduaid.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ResourceDAO {

    // Insert new resource donation
    public int insert(Resource resource) throws SQLException {
        String sql = "INSERT INTO resources (title, description, category_id, donor_id, condition_type, image_path, status) VALUES (?, ?, ?, ?, ?, ?, 'AVAILABLE')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, resource.getTitle());
            ps.setString(2, resource.getDescription());
            ps.setInt(3, resource.getCategoryId());
            ps.setInt(4, resource.getDonorId());
            ps.setString(5, resource.getConditionType());
            ps.setString(6, resource.getImagePath());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    // Get all available resources (for recipients)
    public List<Resource> findAvailable() throws SQLException {
        List<Resource> list = new ArrayList<>();
        String sql = "SELECT r.*, c.name as category_name FROM resources r " +
                "LEFT JOIN categories c ON r.category_id = c.category_id " +
                "WHERE r.status = 'AVAILABLE' ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    // Get resources by donor (for donor dashboard)
    public List<Resource> findByDonor(int donorId) throws SQLException {
        List<Resource> list = new ArrayList<>();
        String sql = "SELECT r.*, c.name as category_name FROM resources r " +
                "LEFT JOIN categories c ON r.category_id = c.category_id " +
                "WHERE r.donor_id = ? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, donorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    // Get resource by ID
    public Resource findById(int resourceId) throws SQLException {
        String sql = "SELECT r.*, c.name as category_name FROM resources r " +
                "LEFT JOIN categories c ON r.category_id = c.category_id " +
                "WHERE r.resource_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, resourceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    // Update resource status
    public boolean updateStatus(int resourceId, String status) throws SQLException {
        String sql = "UPDATE resources SET status = ? WHERE resource_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, resourceId);
            return ps.executeUpdate() > 0;
        }
    }

    // Delete resource
    public boolean delete(int resourceId) throws SQLException {
        // First delete associated wishlist entries
        String deleteWishlist = "DELETE FROM wishlist WHERE resource_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(deleteWishlist)) {
            ps.setInt(1, resourceId);
            ps.executeUpdate();
        }
        // Then delete the resource
        String sql = "DELETE FROM resources WHERE resource_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, resourceId);
            return ps.executeUpdate() > 0;
        }
    }

    private Resource mapRow(ResultSet rs) throws SQLException {
        Resource r = new Resource();
        r.setResourceId(rs.getInt("resource_id"));
        r.setTitle(rs.getString("title"));
        r.setDescription(rs.getString("description"));
        r.setCategoryId(rs.getInt("category_id"));
        r.setDonorId(rs.getInt("donor_id"));
        r.setConditionType(rs.getString("condition_type"));
        r.setImagePath(rs.getString("image_path"));
        r.setStatus(rs.getString("status"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        return r;
    }
}