package com.eduaid.model;

import java.sql.Timestamp;

/**
 * Category - Model class representing a row in the `categories` table.
 *
 * Categories classify resources (e.g. Books, Stationery, Lab Equipment).
 * Follows JavaBean conventions.
 */
public class Category {

    private int       categoryId;
    private String    name;
    private String    description;
    private Timestamp createdAt;

    // ---------------------------------------------------------------
    // Constructors
    // ---------------------------------------------------------------
    public Category() {}

    public Category(String name, String description) {
        this.name        = name;
        this.description = description;
    }

    // ---------------------------------------------------------------
    // Getters & Setters
    // ---------------------------------------------------------------
    public int getCategoryId()                   { return categoryId; }
    public void setCategoryId(int categoryId)    { this.categoryId = categoryId; }

    public String getName()                { return name; }
    public void   setName(String name)     { this.name = name; }

    public String getDescription()                     { return description; }
    public void   setDescription(String description)   { this.description = description; }

    public Timestamp getCreatedAt()                    { return createdAt; }
    public void      setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Category{categoryId=" + categoryId + ", name='" + name + "'}";
    }
}
