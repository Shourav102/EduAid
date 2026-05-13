package com.eduaid.model;

import java.sql.Timestamp;

public class Wishlist {
    private int wishlistId;
    private int recipientId;
    private int resourceId;
    private Timestamp createdAt;

    // Extra fields for display (joined from other tables)
    private String resourceTitle;
    private String resourceDescription;
    private String conditionType;
    private String resourceStatus;
    private String categoryName;

    // Constructors
    public Wishlist() {}

    public Wishlist(int recipientId, int resourceId) {
        this.recipientId = recipientId;
        this.resourceId = resourceId;
    }

    // Getters and Setters
    public int getWishlistId() {
        return wishlistId;
    }

    public void setWishlistId(int wishlistId) {
        this.wishlistId = wishlistId;
    }

    public int getRecipientId() {
        return recipientId;
    }

    public void setRecipientId(int recipientId) {
        this.recipientId = recipientId;
    }

    public int getResourceId() {
        return resourceId;
    }

    public void setResourceId(int resourceId) {
        this.resourceId = resourceId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getResourceTitle() {
        return resourceTitle;
    }

    public void setResourceTitle(String resourceTitle) {
        this.resourceTitle = resourceTitle;
    }

    public String getResourceDescription() {
        return resourceDescription;
    }

    public void setResourceDescription(String resourceDescription) {
        this.resourceDescription = resourceDescription;
    }

    public String getConditionType() {
        return conditionType;
    }

    public void setConditionType(String conditionType) {
        this.conditionType = conditionType;
    }

    public String getResourceStatus() {
        return resourceStatus;
    }

    public void setResourceStatus(String resourceStatus) {
        this.resourceStatus = resourceStatus;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    @Override
    public String toString() {
        return "Wishlist{" +
                "wishlistId=" + wishlistId +
                ", recipientId=" + recipientId +
                ", resourceId=" + resourceId +
                ", resourceTitle='" + resourceTitle + '\'' +
                '}';
    }
}