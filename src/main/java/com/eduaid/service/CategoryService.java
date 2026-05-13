package com.eduaid.service;

import com.eduaid.dao.CategoryDAO;
import com.eduaid.model.Category;
import com.eduaid.util.ValidationUtil;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * CategoryService - Business logic layer for category management.
 *
 * Validates input, enforces uniqueness rules, and delegates
 * persistence operations to CategoryDAO.
 */
public class CategoryService {

    private final CategoryDAO categoryDAO;

    public CategoryService() {
        this.categoryDAO = new CategoryDAO();
    }

    // ---------------------------------------------------------------
    // CREATE
    // ---------------------------------------------------------------

    /**
     * Validates and creates a new category.
     *
     * @param name        category name
     * @param description category description
     * @return Map with "success" true, or "errors" map
     */
    public Map<String, Object> createCategory(String name, String description) {
        Map<String, Object> result = new HashMap<>();
        Map<String, String> errors = new HashMap<>();

        // Validation
        String nameErr = ValidationUtil.validateRequired(name, "Category name");
        if (nameErr != null) errors.put("name", nameErr);
        else {
            String lengthErr = ValidationUtil.validateMaxLength(name, "Category name", 100);
            if (lengthErr != null) errors.put("name", lengthErr);
        }

        String descErr = ValidationUtil.validateRequired(description, "Description");
        if (descErr != null) errors.put("description", descErr);

        if (!errors.isEmpty()) { result.put("errors", errors); return result; }

        try {
            // Uniqueness check
            if (categoryDAO.nameExists(name.trim())) {
                errors.put("name", "A category with this name already exists.");
                result.put("errors", errors);
                return result;
            }

            Category category = new Category(name.trim(), description.trim());
            int id = categoryDAO.insertCategory(category);

            if (id > 0) result.put("success", true);
            else        result.put("errors", Map.of("general", "Failed to create category. Please try again."));

        } catch (SQLException e) {
            System.err.println("[CategoryService] createCategory error: " + e.getMessage());
            result.put("errors", Map.of("general", "A database error occurred."));
        }
        return result;
    }

    // ---------------------------------------------------------------
    // READ
    // ---------------------------------------------------------------

    /** Returns all categories. */
    public List<Category> getAllCategories() throws SQLException {
        return categoryDAO.findAll();
    }

    /** Returns a single category by ID. */
    public Category getCategoryById(int id) throws SQLException {
        return categoryDAO.findById(id);
    }

    // ---------------------------------------------------------------
    // UPDATE
    // ---------------------------------------------------------------

    /**
     * Validates and updates a category.
     *
     * @param categoryId  ID of the category being edited
     * @param name        new name
     * @param description new description
     * @return Map with "success" true, or "errors" map
     */
    public Map<String, Object> updateCategory(int categoryId, String name, String description) {
        Map<String, Object> result = new HashMap<>();
        Map<String, String> errors = new HashMap<>();

        String nameErr = ValidationUtil.validateRequired(name, "Category name");
        if (nameErr != null) errors.put("name", nameErr);
        else {
            String lengthErr = ValidationUtil.validateMaxLength(name, "Category name", 100);
            if (lengthErr != null) errors.put("name", lengthErr);
        }

        String descErr = ValidationUtil.validateRequired(description, "Description");
        if (descErr != null) errors.put("description", descErr);

        if (!errors.isEmpty()) { result.put("errors", errors); return result; }

        try {
            // Uniqueness check excluding current category
            if (categoryDAO.nameExistsExcluding(name.trim(), categoryId)) {
                errors.put("name", "Another category with this name already exists.");
                result.put("errors", errors);
                return result;
            }

            Category category = new Category(name.trim(), description.trim());
            category.setCategoryId(categoryId);
            boolean updated = categoryDAO.updateCategory(category);

            if (updated) result.put("success", true);
            else         result.put("errors", Map.of("general", "Category not found or update failed."));

        } catch (SQLException e) {
            System.err.println("[CategoryService] updateCategory error: " + e.getMessage());
            result.put("errors", Map.of("general", "A database error occurred."));
        }
        return result;
    }

    // ---------------------------------------------------------------
    // DELETE
    // ---------------------------------------------------------------

    /**
     * Deletes a category if it has no linked resources.
     *
     * @param categoryId ID of the category to delete
     * @return Map with "success" true, or "errorMessage" string
     */
    public Map<String, Object> deleteCategory(int categoryId) {
        Map<String, Object> result = new HashMap<>();
        try {
            // Safety check: prevent deletion if resources exist in this category
            int resourceCount = categoryDAO.countResourcesInCategory(categoryId);
            if (resourceCount > 0) {
                result.put("errorMessage",
                    "Cannot delete this category — it has " + resourceCount
                  + " resource(s) linked to it. Reassign or remove those resources first.");
                return result;
            }

            boolean deleted = categoryDAO.deleteCategory(categoryId);
            if (deleted) result.put("success", true);
            else         result.put("errorMessage", "Category not found or could not be deleted.");

        } catch (SQLException e) {
            System.err.println("[CategoryService] deleteCategory error: " + e.getMessage());
            result.put("errorMessage", "A database error occurred. Please try again.");
        }
        return result;
    }
}
