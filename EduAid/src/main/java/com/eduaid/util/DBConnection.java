package com.eduaid.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection - Utility class responsible for creating and returning
 * a JDBC connection to the MySQL database (XAMPP / localhost).
 *
 * Pattern: Static factory method - no instantiation needed.
 */
public class DBConnection {

    // ---------------------------------------------------------------
    // Database configuration constants
    // ---------------------------------------------------------------
    private static final String DRIVER   = "com.mysql.cj.jdbc.Driver";
    private static final String URL      = "jdbc:mysql://localhost:3306/eduaid_db"
                                         + "?useSSL=false"
                                         + "&serverTimezone=UTC"
                                         + "&allowPublicKeyRetrieval=true";
    private static final String DB_USER  = "root";   // default XAMPP user
    private static final String DB_PASS  = "";        // default XAMPP password (empty)

    // Private constructor – utility class should not be instantiated
    private DBConnection() {}

    /**
     * Returns a live JDBC Connection to eduaid_db.
     *
     * @return Connection object
     * @throws SQLException if the connection cannot be established
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER);
            return DriverManager.getConnection(URL, DB_USER, DB_PASS);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found. "
                    + "Add mysql-connector-j to your classpath.", e);
        }
    }

    /**
     * Safely closes a connection (null-safe convenience method).
     *
     * @param conn Connection to close (may be null)
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("[DBConnection] Failed to close connection: " + e.getMessage());
            }
        }
    }
}
