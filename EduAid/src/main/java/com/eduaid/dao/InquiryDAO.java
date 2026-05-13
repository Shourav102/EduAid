package com.eduaid.dao;

import com.eduaid.model.Inquiry;
import com.eduaid.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * InquiryDAO - Data Access Object for the `inquiries` table.
 *
 * Handles all CRUD operations for contact form submissions.
 * Fixed: Added status column support (UNREAD / READ).
 */
public class InquiryDAO {

    // SQL Queries
    private static final String INSERT =
            "INSERT INTO inquiries (full_name, email, subject, message, status) VALUES (?, ?, ?, ?, 'UNREAD')";

    private static final String SELECT_ALL =
            "SELECT * FROM inquiries ORDER BY submitted_at DESC";

    private static final String SELECT_BY_ID =
            "SELECT * FROM inquiries WHERE inquiry_id = ?";

    private static final String UPDATE_STATUS =
            "UPDATE inquiries SET status = ? WHERE inquiry_id = ?";

    private static final String COUNT_UNREAD =
            "SELECT COUNT(*) FROM inquiries WHERE status = 'UNREAD'";

    /**
     * Inserts a new inquiry into the database.
     *
     * @param inquiry Inquiry object with form data
     * @return generated inquiry_id, or -1 on failure
     * @throws SQLException on database error
     */
    public int insertInquiry(Inquiry inquiry) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int generatedId = -1;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS);

            ps.setString(1, inquiry.getFullName());
            ps.setString(2, inquiry.getEmail());
            ps.setString(3, inquiry.getSubject());
            ps.setString(4, inquiry.getMessage());

            int rows = ps.executeUpdate();
            if (rows > 0) {
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

    /**
     * Retrieves all inquiries, ordered by most recent first.
     *
     * @return List of all Inquiry objects
     * @throws SQLException on database error
     */
    public List<Inquiry> findAll() throws SQLException {
        List<Inquiry> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(SELECT_ALL);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        return list;
    }

    /**
     * Finds a single inquiry by its ID.
     *
     * @param id inquiry_id
     * @return Inquiry object or null if not found
     * @throws SQLException on database error
     */
    public Inquiry findById(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(SELECT_BY_ID);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        return null;
    }

    /**
     * Counts the number of unread inquiries.
     *
     * @return number of inquiries with status = 'UNREAD'
     * @throws SQLException on database error
     */
    public int countUnread() throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(COUNT_UNREAD);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } finally {
            closeResources(rs, ps, conn);
        }
        return 0;
    }

    /**
     * Marks an inquiry as read (status = 'READ').
     *
     * @param inquiryId the inquiry to update
     * @return true if update was successful
     * @throws SQLException on database error
     */
    public boolean markAsRead(int inquiryId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(UPDATE_STATUS);
            ps.setString(1, "READ");
            ps.setInt(2, inquiryId);
            return ps.executeUpdate() > 0;
        } finally {
            closeResources(null, ps, conn);
        }
    }

    /**
     * Maps a ResultSet row to an Inquiry object.
     *
     * @param rs ResultSet positioned at a valid row
     * @return populated Inquiry object
     * @throws SQLException on database error
     */
    private Inquiry mapRow(ResultSet rs) throws SQLException {
        Inquiry inquiry = new Inquiry();
        inquiry.setInquiryId(rs.getInt("inquiry_id"));
        inquiry.setFullName(rs.getString("full_name"));
        inquiry.setEmail(rs.getString("email"));
        inquiry.setSubject(rs.getString("subject"));
        inquiry.setMessage(rs.getString("message"));
        inquiry.setSubmittedAt(rs.getTimestamp("submitted_at"));

        // Handle status column (add if exists, otherwise default to 'UNREAD')
        try {
            inquiry.setStatus(rs.getString("status"));
        } catch (SQLException e) {
            // Status column doesn't exist yet — default to UNREAD
            inquiry.setStatus("UNREAD");
        }

        return inquiry;
    }

    /**
     * Safely closes JDBC resources.
     */
    private void closeResources(ResultSet rs, PreparedStatement ps, Connection conn) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException ignored) {}
        try {
            if (ps != null) ps.close();
        } catch (SQLException ignored) {}
        DBConnection.closeConnection(conn);
    }
}