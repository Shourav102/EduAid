package com.eduaid.service;

import com.eduaid.dao.UserDAO;
import com.eduaid.model.User;
import com.eduaid.util.PasswordUtil;
import com.eduaid.util.ValidationUtil;

import java.sql.Date;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * UserService - Business logic layer for all user-related operations.
 *
 * Sits between the Controller (Servlets) and the DAO layer.
 * Responsibilities:
 *  - Validate all incoming data before calling DAO
 *  - Hash passwords before persistence
 *  - Enforce business rules (e.g. no duplicate email/phone)
 *  - Return descriptive error maps so controllers can relay messages to JSP
 */
public class UserService {

    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    // ---------------------------------------------------------------
    // REGISTRATION
    // ---------------------------------------------------------------

    /**
     * Validates and registers a new user.
     *
     * @param fullName    user's full name
     * @param email       user's email
     * @param phone       user's phone number
     * @param password    plain-text password
     * @param confirmPass password confirmation
     * @param role        DONOR or RECIPIENT
     * @param dobStr      date of birth string (YYYY-MM-DD)
     * @param address     user's address
     * @param institution school/university name
     * @return Map with key "errors" (Map of field->message) or "success" (boolean true)
     */
    public Map<String, Object> registerUser(String fullName, String email, String phone,
                                             String password, String confirmPass,
                                             String role, String dobStr,
                                             String address, String institution) {

        Map<String, Object> result = new HashMap<>();
        Map<String, String> errors = new HashMap<>();

        // ---- Field-level validation ----
        addError(errors, "fullName",    ValidationUtil.validateFullName(fullName));
        addError(errors, "email",       ValidationUtil.validateEmail(email));
        addError(errors, "phone",       ValidationUtil.validatePhone(phone));
        addError(errors, "password",    ValidationUtil.validatePassword(password));
        addError(errors, "confirmPass", ValidationUtil.validatePasswordMatch(password, confirmPass));
        addError(errors, "role",        ValidationUtil.validateRole(role));
        addError(errors, "dob",         ValidationUtil.validateDOB(dobStr));
        addError(errors, "address",     ValidationUtil.validateRequired(address, "Address"));
        addError(errors, "institution", ValidationUtil.validateRequired(institution, "Institution / School name"));

        if (!errors.isEmpty()) {
            result.put("errors", errors);
            return result;
        }

        // ---- Business rule: unique email and phone ----
        try {
            if (userDAO.emailExists(email)) {
                errors.put("email", "An account with this email address already exists.");
            }
            if (userDAO.phoneExists(phone)) {
                errors.put("phone", "An account with this phone number already exists.");
            }
            if (!errors.isEmpty()) {
                result.put("errors", errors);
                return result;
            }

            // ---- Hash password before storing ----
            String hashedPassword = PasswordUtil.hashPassword(password);
            Date   dob            = Date.valueOf(dobStr);

            User newUser = new User(fullName, email, phone, hashedPassword,
                                    role, dob, address, institution);

            int generatedId = userDAO.insertUser(newUser);

            if (generatedId > 0) {
                result.put("success", true);
                result.put("userId",  generatedId);
            } else {
                result.put("errors", Map.of("general",
                        "Registration failed due to a server error. Please try again."));
            }

        } catch (SQLException e) {
            System.err.println("[UserService] registerUser SQL error: " + e.getMessage());
            result.put("errors", Map.of("general",
                    "A database error occurred. Please try again later."));
        }

        return result;
    }

    // ---------------------------------------------------------------
    // LOGIN / AUTHENTICATION
    // ---------------------------------------------------------------

    /**
     * Authenticates a user by email and password.
     *
     * Business rules enforced:
     *  - Email must exist
     *  - Password must match stored hash
     *  - Account must be APPROVED (not PENDING or DISABLED)
     *
     * @param email    submitted email
     * @param password submitted plain-text password
     * @return Map with key "user" (User object) on success, or "errorMessage" (String) on failure
     */
    public Map<String, Object> loginUser(String email, String password) {
        Map<String, Object> result = new HashMap<>();

        // Basic presence check
        if (ValidationUtil.isBlank(email) || ValidationUtil.isBlank(password)) {
            result.put("errorMessage", "Email and password are required.");
            return result;
        }

        try {
            User user = userDAO.findByEmail(email);

            if (user == null) {
                // Generic message to prevent account enumeration
                result.put("errorMessage", "Invalid email or password.");
                return result;
            }

            if (!PasswordUtil.verifyPassword(password, user.getPasswordHash())) {
                result.put("errorMessage", "Invalid email or password.");
                return result;
            }

            // Check account status
            switch (user.getStatus()) {
                case "PENDING":
                    result.put("errorMessage",
                        "Your account is pending admin approval. "
                      + "You will be notified once it is approved.");
                    break;
                case "DISABLED":
                    result.put("errorMessage",
                        "Your account has been disabled. "
                      + "Please contact the EduAid administrator.");
                    break;
                case "APPROVED":
                    result.put("user", user); // login success
                    break;
                default:
                    result.put("errorMessage", "Unknown account status. Please contact support.");
            }

        } catch (SQLException e) {
            System.err.println("[UserService] loginUser SQL error: " + e.getMessage());
            result.put("errorMessage", "A server error occurred. Please try again later.");
        }

        return result;
    }

    // ---------------------------------------------------------------
    // PROFILE UPDATE
    // ---------------------------------------------------------------

    /**
     * Validates and updates a user's profile information.
     *
     * @param userId      the user being updated
     * @param fullName    new full name
     * @param phone       new phone number
     * @param address     new address
     * @param institution new institution name
     * @return Map with "errors" map or "success" true
     */
    public Map<String, Object> updateProfile(int userId, String fullName, String phone,
                                              String address, String institution) {
        Map<String, Object> result = new HashMap<>();
        Map<String, String> errors = new HashMap<>();

        addError(errors, "fullName",    ValidationUtil.validateFullName(fullName));
        addError(errors, "phone",       ValidationUtil.validatePhone(phone));
        addError(errors, "address",     ValidationUtil.validateRequired(address, "Address"));
        addError(errors, "institution", ValidationUtil.validateRequired(institution, "Institution"));

        if (!errors.isEmpty()) {
            result.put("errors", errors);
            return result;
        }

        try {
            // Check if new phone belongs to someone else
            User existing = userDAO.findById(userId);
            if (existing == null) {
                result.put("errors", Map.of("general", "User account not found."));
                return result;
            }
            if (!existing.getPhone().equals(phone) && userDAO.phoneExists(phone)) {
                errors.put("phone", "This phone number is already registered to another account.");
                result.put("errors", errors);
                return result;
            }

            existing.setFullName(fullName);
            existing.setPhone(phone);
            existing.setAddress(address);
            existing.setInstitution(institution);

            boolean updated = userDAO.updateProfile(existing);
            result.put("success", updated);

        } catch (SQLException e) {
            System.err.println("[UserService] updateProfile SQL error: " + e.getMessage());
            result.put("errors", Map.of("general", "A database error occurred. Please try again."));
        }

        return result;
    }

    // ---------------------------------------------------------------
    // PASSWORD CHANGE
    // ---------------------------------------------------------------

    /**
     * Changes a user's password after verifying the current one.
     *
     * @param userId          the user's ID
     * @param currentPassword plain-text current password
     * @param newPassword     plain-text new password
     * @param confirmNew      new password confirmation
     * @return Map with "errors" map or "success" true
     */
    public Map<String, Object> changePassword(int userId, String currentPassword,
                                               String newPassword, String confirmNew) {
        Map<String, Object> result = new HashMap<>();
        Map<String, String> errors = new HashMap<>();

        addError(errors, "newPassword", ValidationUtil.validatePassword(newPassword));
        addError(errors, "confirmNew",  ValidationUtil.validatePasswordMatch(newPassword, confirmNew));

        if (!errors.isEmpty()) {
            result.put("errors", errors);
            return result;
        }

        try {
            User user = userDAO.findById(userId);
            if (user == null) {
                result.put("errors", Map.of("general", "User not found."));
                return result;
            }

            if (!PasswordUtil.verifyPassword(currentPassword, user.getPasswordHash())) {
                errors.put("currentPassword", "Current password is incorrect.");
                result.put("errors", errors);
                return result;
            }

            String newHash = PasswordUtil.hashPassword(newPassword);
            boolean updated = userDAO.updatePassword(userId, newHash);
            result.put("success", updated);

        } catch (SQLException e) {
            System.err.println("[UserService] changePassword SQL error: " + e.getMessage());
            result.put("errors", Map.of("general", "A database error occurred. Please try again."));
        }

        return result;
    }

    // ---------------------------------------------------------------
    // ADMIN OPERATIONS
    // ---------------------------------------------------------------

    /** Retrieves all users for the admin user management panel. */
    public List<User> getAllUsers() throws SQLException {
        return userDAO.findAll();
    }

    /** Retrieves users awaiting admin approval. */
    public List<User> getPendingUsers() throws SQLException {
        return userDAO.findPendingUsers();
    }

    /** Approves a user account. */
    public boolean approveUser(int userId) throws SQLException {
        return userDAO.updateStatus(userId, "APPROVED");
    }

    /** Disables a user account. */
    public boolean disableUser(int userId) throws SQLException {
        return userDAO.updateStatus(userId, "DISABLED");
    }

    /** Finds a single user by ID. */
    public User getUserById(int userId) throws SQLException {
        return userDAO.findById(userId);
    }

    // ---------------------------------------------------------------
    // Private helper
    // ---------------------------------------------------------------
    private void addError(Map<String, String> errors, String field, String message) {
        if (message != null) {
            errors.put(field, message);
        }
    }
}
