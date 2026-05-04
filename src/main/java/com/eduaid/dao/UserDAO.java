package com.eduaid.dao;

import com.eduaid.model.User;
import com.eduaid.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * UserDAO - Data Access Object for the `users` table.
 *
 * Responsible for all CRUD database operations on User objects.
 * Throws DAOException (a checked exception) so the Service layer
 * can translate them into user-friendly messages.
 *
 * All SQL uses PreparedStatements to prevent SQL Injection.
 */
public class UserDAO {

    // ---------------------------------------------------------------
    // SQL Queries (constants for maintainability)
    // ---------------------------------------------------------------
    private static final String INSERT_USER =
        "INSERT INTO users (full_name, email, phone, password_hash, role, status, dob, address, institution) "
      + "VALUES (?, ?, ?, ?, ?, 'PENDING', ?, ?, ?)";

    private static final String SELECT_BY_EMAIL =
        "SELECT * FROM users WHERE email = ?";

    private static final String SELECT_BY_ID =
        "SELECT * FROM users WHERE user_id = ?";

    private static final String EMAIL_EXISTS =
        "SELECT COUNT(*) FROM users WHERE email = ?";

    private static final String PHONE_EXISTS =
        "SELECT COUNT(*) FROM users WHERE phone = ?";

    private static final String UPDATE_STATUS =
        "UPDATE users SET status = ? WHERE user_id = ?";

    private static final String UPDATE_PROFILE =
        "UPDATE users SET full_name = ?, phone = ?, address = ?, institution = ? WHERE user_id = ?";

    private static final String UPDATE_PASSWORD =
        "UPDATE users SET password_hash = ? WHERE user_id = ?";

    private static final String SELECT_ALL =
        "SELECT * FROM users ORDER BY created_at DESC";

    private static final String SELECT_PENDING =
        "SELECT * FROM users WHERE status = 'PENDING' ORDER BY created_at ASC";

    // ---------------------------------------------------------------
    // CREATE
    // ---------------------------------------------------------------

    /**
     * Inserts a new user into the database.
     * Returns the auto-generated user_id on success, or -1 on failure.
     *
     * @param user User object populated with registration data
     * @return generated user_id
     * @throws SQLException on database error
     */
    public int insertUser(User user) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int generatedId = -1;

        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(INSERT_USER, Statement.RETURN_GENERATED_KEYS);

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPasswordHash());
            ps.setString(5, user.getRole());
            ps.setDate(  6, user.getDob());
            ps.setString(7, user.getAddress());
            ps.setString(8, user.getInstitution());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }
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
     * Finds a user by their email address.
     *
     * @param email the email to look up
     * @return User object if found, null otherwise
     * @throws SQLException on database error
     */
    public User findByEmail(String email) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(SELECT_BY_EMAIL);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        return null;
    }

    /**
     * Finds a user by their primary key (user_id).
     *
     * @param userId the user's ID
     * @return User object if found, null otherwise
     * @throws SQLException on database error
     */
    public User findById(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(SELECT_BY_ID);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        return null;
    }

    /**
     * Returns all users (used by admin dashboard).
     *
     * @return List of all User objects
     * @throws SQLException on database error
     */
    public List<User> findAll() throws SQLException {
        List<User> users = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(SELECT_ALL);
            rs   = ps.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        return users;
    }

    /**
     * Returns only PENDING users awaiting admin approval.
     *
     * @return List of pending User objects
     * @throws SQLException on database error
     */
    public List<User> findPendingUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(SELECT_PENDING);
            rs   = ps.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        return users;
    }

    // ---------------------------------------------------------------
    // EXISTENCE CHECKS (for uniqueness validation)
    // ---------------------------------------------------------------

    /**
     * Returns true if an account with the given email already exists.
     */
    public boolean emailExists(String email) throws SQLException {
        return countExists(EMAIL_EXISTS, email);
    }

    /**
     * Returns true if an account with the given phone number already exists.
     */
    public boolean phoneExists(String phone) throws SQLException {
        return countExists(PHONE_EXISTS, phone);
    }

    private boolean countExists(String sql, String value) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setString(1, value);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        return false;
    }

    // ---------------------------------------------------------------
    // UPDATE
    // ---------------------------------------------------------------

    /**
     * Updates the status (APPROVED / DISABLED) of a user account.
     * Used by admin to approve or disable users.
     *
     * @param userId target user's ID
     * @param status new status string
     * @return true if update was successful
     * @throws SQLException on database error
     */
    public boolean updateStatus(int userId, String status) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(UPDATE_STATUS);
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } finally {
            closeResources(null, ps, conn);
        }
    }

    /**
     * Updates a user's editable profile fields.
     *
     * @param user User object with updated fields
     * @return true if update was successful
     * @throws SQLException on database error
     */
    public boolean updateProfile(User user) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(UPDATE_PROFILE);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getAddress());
            ps.setString(4, user.getInstitution());
            ps.setInt(   5, user.getUserId());
            return ps.executeUpdate() > 0;
        } finally {
            closeResources(null, ps, conn);
        }
    }

    /**
     * Updates a user's password hash (used during password change).
     *
     * @param userId      user's ID
     * @param newHash     new SHA-256 hashed password
     * @return true if update was successful
     * @throws SQLException on database error
     */
    public boolean updatePassword(int userId, String newHash) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(UPDATE_PASSWORD);
            ps.setString(1, newHash);
            ps.setInt(   2, userId);
            return ps.executeUpdate() > 0;
        } finally {
            closeResources(null, ps, conn);
        }
    }

    // ---------------------------------------------------------------
    // Private helper: map ResultSet row to User object
    // ---------------------------------------------------------------
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(      rs.getInt("user_id"));
        user.setFullName(    rs.getString("full_name"));
        user.setEmail(       rs.getString("email"));
        user.setPhone(       rs.getString("phone"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setRole(        rs.getString("role"));
        user.setStatus(      rs.getString("status"));
        user.setDob(         rs.getDate("dob"));
        user.setAddress(     rs.getString("address"));
        user.setInstitution( rs.getString("institution"));
        user.setCreatedAt(   rs.getTimestamp("created_at"));
        user.setUpdatedAt(   rs.getTimestamp("updated_at"));
        return user;
    }

    // ---------------------------------------------------------------
    // Private helper: safely close JDBC resources
    // ---------------------------------------------------------------
    private void closeResources(ResultSet rs, PreparedStatement ps, Connection conn) {
        try { if (rs   != null) rs.close();   } catch (SQLException ignored) {}
        try { if (ps   != null) ps.close();   } catch (SQLException ignored) {}
        DBConnection.closeConnection(conn);
    }
}
