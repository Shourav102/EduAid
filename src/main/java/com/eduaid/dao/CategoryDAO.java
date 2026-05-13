package com.eduaid.dao;

import com.eduaid.model.Category;
import com.eduaid.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CategoryDAO - Data Access Object for the `categories` table.
 *
 * Handles all CRUD operations for resource categories.
 * All queries use PreparedStatements to prevent SQL Injection.
 */
public class CategoryDAO {

    // ---------------------------------------------------------------
    // SQL Queries
    // ---------------------------------------------------------------
    private static final String INSERT_CATEGORY =
        "INSERT INTO categories (name, description) VALUES (?, ?)";

    private static final String SELECT_ALL =
        "SELECT * FROM categories ORDER BY name ASC";

    private static final String SELECT_BY_ID =
        "SELECT * FROM categories WHERE category_id = ?";

    private static final String UPDATE_CATEGORY =
        "UPDATE categories SET name = ?, description = ? WHERE category_id = ?";

    private static final String DELETE_CATEGORY =
        "DELETE FROM categories WHERE category_id = ?";

    private static final String NAME_EXISTS =
        "SELECT COUNT(*) FROM categories WHERE name = ?";

    private static final String NAME_EXISTS_EXCLUDING =
        "SELECT COUNT(*) FROM categories WHERE name = ? AND category_id != ?";

    private static final String COUNT_RESOURCES_IN_CATEGORY =
        "SELECT COUNT(*) FROM resources WHERE category_id = ?";

    // ---------------------------------------------------------------
    // CREATE
    // ---------------------------------------------------------------

    /**
     * Inserts a new category into the database.
     *
     * @param category Category object with name and description
     * @return generated category_id, or -1 on failure
     * @throws SQLException on database error
     */
    public int insertCategory(Category category) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int generatedId = -1;

        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(INSERT_CATEGORY, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) generatedId = rs.getInt(1);
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        return generatedId;
    }

    // ---------------------------------------------------------------
    // READ
    // ---------------------------------------------------------------

    /**
     * Returns all categories ordered alphabetically by name.
     *
     * @return List of Category objects
     * @throws SQLException on database error
     */
    public List<Category> findAll() throws SQLException {
        List<Category> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(SELECT_ALL);
            rs   = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } finally {
            closeResources(rs, ps, conn);
        }
        return list;
    }

    /**
     * Finds a single category by its primary key.
     *
     * @param categoryId the category's ID
     * @return Category object, or null if not found
     * @throws SQLException on database error
     */
    public Category findById(int categoryId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(SELECT_BY_ID);
            ps.setInt(1, categoryId);
            rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } finally {
            closeResources(rs, ps, conn);
        }
        return null;
    }

    // ---------------------------------------------------------------
    // UPDATE
    // ---------------------------------------------------------------

    /**
     * Updates an existing category's name and description.
     *
     * @param category Category object with updated fields and valid categoryId
     * @return true if update succeeded
     * @throws SQLException on database error
     */
    public boolean updateCategory(Category category) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(UPDATE_CATEGORY);
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            ps.setInt(   3, category.getCategoryId());
            return ps.executeUpdate() > 0;
        } finally {
            closeResources(null, ps, conn);
        }
    }

    // ---------------------------------------------------------------
    // DELETE
    // ---------------------------------------------------------------

    /**
     * Deletes a category by its ID.
     * Should only be called after verifying no resources use this category.
     *
     * @param categoryId the category to delete
     * @return true if deletion succeeded
     * @throws SQLException on database error
     */
    public boolean deleteCategory(int categoryId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(DELETE_CATEGORY);
            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        } finally {
            closeResources(null, ps, conn);
        }
    }

    // ---------------------------------------------------------------
    // EXISTENCE / SAFETY CHECKS
    // ---------------------------------------------------------------

    /**
     * Returns true if a category with the given name already exists.
     * Used during creation to enforce unique category names.
     */
    public boolean nameExists(String name) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(NAME_EXISTS);
            ps.setString(1, name);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } finally {
            closeResources(rs, ps, conn);
        }
        return false;
    }

    /**
     * Returns true if a category name is taken by another category (used during edit).
     * Excludes the category being edited so it can keep its own name.
     */
    public boolean nameExistsExcluding(String name, int excludeId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(NAME_EXISTS_EXCLUDING);
            ps.setString(1, name);
            ps.setInt(   2, excludeId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } finally {
            closeResources(rs, ps, conn);
        }
        return false;
    }

    /**
     * Returns the number of resources linked to a category.
     * Used before deletion to prevent orphaned resource records.
     */
    public int countResourcesInCategory(int categoryId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(COUNT_RESOURCES_IN_CATEGORY);
            ps.setInt(1, categoryId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } finally {
            closeResources(rs, ps, conn);
        }
        return 0;
    }

    // ---------------------------------------------------------------
    // Private helpers
    // ---------------------------------------------------------------
    private Category mapRow(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setCategoryId(  rs.getInt("category_id"));
        c.setName(        rs.getString("name"));
        c.setDescription( rs.getString("description"));
        c.setCreatedAt(   rs.getTimestamp("created_at"));
        return c;
    }

    private void closeResources(ResultSet rs, PreparedStatement ps, Connection conn) {
        try { if (rs != null) rs.close();   } catch (SQLException ignored) {}
        try { if (ps != null) ps.close();   } catch (SQLException ignored) {}
        DBConnection.closeConnection(conn);
    }
}
