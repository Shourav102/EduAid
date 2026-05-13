package com.eduaid.util;

import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeParseException;

/**
 * ValidationUtil - Centralised validation logic used across controllers.
 *
 * All methods return boolean or a String error message (null = valid).
 * This keeps validation out of Servlets and Models, keeping them clean.
 */
public class ValidationUtil {

    // Regex constants
    private static final String EMAIL_REGEX    = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
    private static final String PHONE_REGEX    = "^[0-9]{10}$";
    private static final String NAME_REGEX     = "^[A-Za-z\\s'-]{2,100}$";  // letters, spaces, hyphens, apostrophes
    private static final String PASSWORD_REGEX = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,}$";

    private ValidationUtil() {}

    // ---------------------------------------------------------------
    // Name validation
    // ---------------------------------------------------------------
    /**
     * Validates a full name: letters, spaces, hyphens, apostrophes only.
     * No numbers allowed.
     */
    public static String validateFullName(String name) {
        if (isBlank(name))             return "Full name is required.";
        if (!name.matches(NAME_REGEX)) return "Full name must contain letters only (2–100 characters).";
        return null; // valid
    }

    // ---------------------------------------------------------------
    // Email validation
    // ---------------------------------------------------------------
    public static String validateEmail(String email) {
        if (isBlank(email))              return "Email address is required.";
        if (!email.matches(EMAIL_REGEX)) return "Please enter a valid email address (e.g. user@example.com).";
        return null;
    }

    // ---------------------------------------------------------------
    // Phone validation
    // ---------------------------------------------------------------
    public static String validatePhone(String phone) {
        if (isBlank(phone))              return "Phone number is required.";
        if (!phone.matches(PHONE_REGEX)) return "Phone number must be exactly 10 digits (numbers only).";
        return null;
    }

    // ---------------------------------------------------------------
    // Password validation
    // ---------------------------------------------------------------
    /**
     * Strong password: min 8 chars, at least one uppercase, one lowercase,
     * one digit, and one special character.
     */
    public static String validatePassword(String password) {
        if (isBlank(password))                return "Password is required.";
        if (password.length() < 8)            return "Password must be at least 8 characters long.";
        if (!password.matches(PASSWORD_REGEX))
            return "Password must contain at least one uppercase letter, one lowercase letter, "
                 + "one digit, and one special character (@#$%^&+=!).";
        return null;
    }

    /**
     * Confirms two password fields match.
     */
    public static String validatePasswordMatch(String password, String confirmPassword) {
        if (isBlank(confirmPassword)) return "Please confirm your password.";
        if (!password.equals(confirmPassword)) return "Passwords do not match.";
        return null;
    }

    // ---------------------------------------------------------------
    // Date of birth validation
    // ---------------------------------------------------------------
    /**
     * Validates DOB: must be a valid date and the user must be at least 10 years old.
     */
    public static String validateDOB(String dobStr) {
        if (isBlank(dobStr)) return "Date of birth is required.";
        try {
            LocalDate dob  = LocalDate.parse(dobStr); // expects YYYY-MM-DD
            LocalDate today = LocalDate.now();
            if (dob.isAfter(today)) return "Date of birth cannot be in the future.";
            int age = Period.between(dob, today).getYears();
            if (age < 10) return "You must be at least 10 years old to register.";
            if (age > 100) return "Please enter a valid date of birth.";
        } catch (DateTimeParseException e) {
            return "Invalid date format. Please use YYYY-MM-DD.";
        }
        return null;
    }

    // ---------------------------------------------------------------
    // Role validation
    // ---------------------------------------------------------------
    public static String validateRole(String role) {
        if (isBlank(role)) return "Please select a role (Donor or Recipient).";
        if (!role.equals("DONOR") && !role.equals("RECIPIENT"))
            return "Invalid role selected.";
        return null;
    }

    // ---------------------------------------------------------------
    // Generic text / field validation
    // ---------------------------------------------------------------
    public static String validateRequired(String value, String fieldName) {
        if (isBlank(value)) return fieldName + " is required.";
        return null;
    }

    public static String validateMaxLength(String value, String fieldName, int max) {
        if (value != null && value.length() > max)
            return fieldName + " must not exceed " + max + " characters.";
        return null;
    }

    // ---------------------------------------------------------------
    // Helper: null / blank check
    // ---------------------------------------------------------------
    public static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    /**
     * Sanitises a string for safe display in JSP (basic XSS protection).
     * Use this when echoing user input back to the view.
     */
    public static String sanitise(String input) {
        if (input == null) return "";
        return input.trim()
                    .replace("&",  "&amp;")
                    .replace("<",  "&lt;")
                    .replace(">",  "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'",  "&#x27;");
    }
}
