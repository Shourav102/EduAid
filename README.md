# 📚 EduAid - Educational Resource Sharing Platform

![EduAid Banner](https://via.placeholder.com/1200x400/1a6b4a/ffffff?text=EduAid)

## 🌟 Overview

EduAid is a web-based platform designed to **reduce educational inequality** by enabling users to donate and access digital educational resources. The platform connects donors who have resources to share with recipients (students and teachers) who need them most — completely free, instant, and community-driven.

**Live Demo:** [Coming Soon]  
**Coursework:** Advanced Programming and Technologies (CS5054NP)

---

## 🚀 Features

### 👤 Public Users
- Marketing homepage explaining platform
- User registration (Donor/Recipient)
- Secure login with remember-me cookie
- About Us & Contact pages with FAQ

### 👑 Admin Dashboard
- **User Management** - Approve/disable user accounts
- **Category Management** - Add/edit/delete resource categories
- **Donation Management** - Approve/reject resource donations
- **Inquiry Management** - View and respond to contact messages
- **Analytics Charts** - User distribution & donations by category (Chart.js)

### 🤝 Donor Dashboard
- **Donate Resources** - Upload digital files (PDF, images, documents)
- **Track Donations** - View status (Pending/Approved/Rejected)
- **View Wishlists** - See what recipients need
- **File Preview** - View uploaded files before download

### 🎓 Recipient Dashboard
- **Browse Resources** - Search and filter available resources
- **Instant Download** - Download approved resources immediately
- **Create Wishlist** - Request specific resources donors can fulfill
- **Manage Wishlist** - View and remove wishlist items
- **Profile Management** - Edit personal information

### 🔐 Security Features
- SHA-256 password hashing
- Session management (30-minute timeout)
- Remember-me cookie (7 days)
- Role-based access control (Admin/Donor/Recipient)
- Password reset via email

---

## 🛠️ Tech Stack

| Category | Technologies |
|----------|--------------|
| **Backend** | Java 17, Jakarta EE, Servlet API |
| **Frontend** | JSP, HTML5, CSS3, JavaScript, jQuery |
| **Database** | MySQL 8.0 |
| **Server** | Apache Tomcat 10.x (via Maven Cargo plugin) |
| **Build Tool** | Apache Maven |
| **Libraries** | Font Awesome 6, Chart.js, Gson, JavaMail |
| **Version Control** | Git & GitHub |

---

## 📋 Prerequisites

- **Java JDK 17** or higher
- **Apache Maven** 3.8+
- **MySQL** 8.0+ (XAMPP/WAMP/MAMP)
- **Git** (for cloning)

---

## ⚙️ Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/EduAid.git
cd EduAid
