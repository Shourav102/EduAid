-- ============================================================
-- EduAid - Educational Resource Donation & Request System
-- Database Schema
-- ============================================================

CREATE DATABASE IF NOT EXISTS eduaid_db;
USE eduaid_db;

-- ============================================================
-- TABLE: categories
-- Stores resource categories (books, stationery, lab equipment)
-- ============================================================
CREATE TABLE IF NOT EXISTS categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL UNIQUE,
    description   TEXT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE: users
-- Stores all users (Admin, Donor, Recipient)
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    user_id        INT AUTO_INCREMENT PRIMARY KEY,
    full_name      VARCHAR(150)  NOT NULL,
    email          VARCHAR(150)  NOT NULL UNIQUE,   -- unique identifier
    phone          VARCHAR(20)   NOT NULL UNIQUE,   -- secondary unique identifier
    password_hash  VARCHAR(255)  NOT NULL,           -- SHA-256 hashed password
    role           ENUM('ADMIN','DONOR','RECIPIENT') NOT NULL DEFAULT 'RECIPIENT',
    status         ENUM('PENDING','APPROVED','DISABLED') NOT NULL DEFAULT 'PENDING',
    dob            DATE,
    address        TEXT,
    institution    VARCHAR(200),
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE: resources
-- Stores donated/listed educational resources
-- ============================================================
CREATE TABLE IF NOT EXISTS resources (
    resource_id   INT AUTO_INCREMENT PRIMARY KEY,
    title         VARCHAR(200)  NOT NULL,
    description   TEXT,
    category_id   INT           NOT NULL,
    donor_id      INT           NOT NULL,
    condition_type ENUM('NEW','GOOD','FAIR','POOR') NOT NULL DEFAULT 'GOOD',
    status        ENUM('PENDING','APPROVED','AVAILABLE','CLAIMED') NOT NULL DEFAULT 'PENDING',
    image_path    VARCHAR(300),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT,
    FOREIGN KEY (donor_id)    REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: requests
-- Tracks recipient requests for a specific resource
-- ============================================================
CREATE TABLE IF NOT EXISTS requests (
    request_id    INT AUTO_INCREMENT PRIMARY KEY,
    resource_id   INT           NOT NULL,
    recipient_id  INT           NOT NULL,
    message       TEXT,
    status        ENUM('PENDING','APPROVED','REJECTED','FULFILLED') NOT NULL DEFAULT 'PENDING',
    requested_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (resource_id)  REFERENCES resources(resource_id) ON DELETE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_request (resource_id, recipient_id)  -- one request per user per resource
);

-- ============================================================
-- TABLE: wishlist
-- Session-persistent wishlist items per user
-- ============================================================
CREATE TABLE IF NOT EXISTS wishlist (
    wishlist_id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT NOT NULL,
    resource_id   INT NOT NULL,
    added_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)     REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (resource_id) REFERENCES resources(resource_id) ON DELETE CASCADE,
    UNIQUE KEY unique_wishlist (user_id, resource_id)
);

-- ============================================================
-- TABLE: inquiries
-- Contact form submissions
-- ============================================================
CREATE TABLE IF NOT EXISTS inquiries (
    inquiry_id    INT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(150) NOT NULL,
    email         VARCHAR(150) NOT NULL,
    subject       VARCHAR(200),
    message       TEXT NOT NULL,
    submitted_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE: report_logs
-- Stores generated admin reports
-- ============================================================
CREATE TABLE IF NOT EXISTS report_logs (
    report_id     INT AUTO_INCREMENT PRIMARY KEY,
    report_type   VARCHAR(100) NOT NULL,
    generated_by  INT NOT NULL,
    generated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (generated_by) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- DEFAULT DATA: Seed admin account and categories
-- Password: Admin@123  (SHA-256 hashed)
-- ============================================================
INSERT INTO users (full_name, email, phone, password_hash, role, status)
VALUES (
    'EduAid Administrator',
    'admin@eduaid.com',
    '9800000000',
    '3a5f8e2c1b9d7f4e6c0a2b8d5f1e3c7a9b2d4f6e8c0a1b3d5f7e9c2a4b6d8f0e', -- placeholder, updated below
    'ADMIN',
    'APPROVED'
);

INSERT INTO categories (name, description) VALUES
    ('Books',           'Textbooks, reference books, novels, and academic reading materials'),
    ('Stationery',      'Pens, notebooks, calculators, and other writing/drawing supplies'),
    ('Lab Equipment',   'Scientific instruments, lab tools, and experimental apparatus'),
    ('Digital Media',   'USB drives, CDs, educational software, and digital learning tools'),
    ('Sports & Arts',   'Sports equipment, art supplies, and creative learning tools');

-- ============================================================
-- Update admin password hash: SHA-256 of "Admin@123"
-- ============================================================
UPDATE users
SET password_hash = '0a041b9462caa4a31bac3567e0b6e6fd9100787db2ab433d96f6d178cabfce90'
WHERE email = 'admin@eduaid.com';
