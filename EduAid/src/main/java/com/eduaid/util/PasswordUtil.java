package com.eduaid.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * PasswordUtil - Handles password hashing using SHA-256.
 *
 * Passwords are NEVER stored in plain text. Every password is hashed
 * before being persisted to the database, and login verification
 * compares hashes only.
 */
public class PasswordUtil {

    // Private constructor – static utility class
    private PasswordUtil() {}

    /**
     * Hashes a plain-text password using the SHA-256 algorithm.
     *
     * @param plainPassword the raw password entered by the user
     * @return hexadecimal SHA-256 hash string (64 characters)
     * @throws RuntimeException if SHA-256 is unavailable (should never happen on JVM)
     */
    public static String hashPassword(String plainPassword) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(plainPassword.getBytes("UTF-8"));

            // Convert byte array to hexadecimal string
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0'); // pad single character hex values
                }
                hexString.append(hex);
            }
            return hexString.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available.", e);
        } catch (java.io.UnsupportedEncodingException e) {
            throw new RuntimeException("UTF-8 encoding not supported.", e);
        }
    }

    /**
     * Verifies a plain-text password against a stored SHA-256 hash.
     *
     * @param plainPassword  the raw password entered by the user
     * @param hashedPassword the stored hash from the database
     * @return true if they match, false otherwise
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        return hashPassword(plainPassword).equals(hashedPassword);
    }
}
