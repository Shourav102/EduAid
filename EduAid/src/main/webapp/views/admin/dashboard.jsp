<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard – EduAid</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

<%-- ============================================================
     ADMIN NAVBAR
     ============================================================ --%>
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand">
        📚 Edu<span>Aid</span> <span style="font-size:0.75rem; opacity:0.75; font-weight:400;">Admin</span>
    </a>
    <button class="navbar-toggle" aria-label="Toggle navigation">
        <span></span><span></span><span></span>
    </button>
    <ul class="navbar-links">
        <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="active">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/users">Users</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
        <li><a href="${pageContext.request.contextPath}/about">About</a></li>
        <li>
            <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn-nav-accent">
                Logout
            </a>
        </li>
    </ul>
</nav>

<%-- ============================================================
     MAIN CONTENT
     ============================================================ --%>
<main>
    <div class="container">

        <%-- Page Header --%>
        <div class="page-header">
            <h1>Welcome back, ${sessionScope.userName} 👋</h1>
            <p>Here's an overview of EduAid activity requiring your attention.</p>
        </div>

        <%-- Summary Stats Cards --%>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div class="stat-value">${totalUsers}</div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card stat-card--warning">
                <div class="stat-icon">⏳</div>
                <div class="stat-value">${pendingCount}</div>
                <div class="stat-label">Pending Approvals</div>
            </div>
            <div class="stat-card stat-card--success">
                <div class="stat-icon">✅</div>
                <div class="stat-value">${approvedCount}</div>
                <div class="stat-label">Approved Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🗂️</div>
                <div class="stat-value">${catCount}</div>
                <div class="stat-label">Categories</div>
            </div>
        </div>

        <%-- Quick Action Buttons --%>
        <div style="display:flex; gap:1rem; flex-wrap:wrap; margin-bottom:2rem;">
            <a href="${pageContext.request.contextPath}/admin/users"      class="btn btn-primary">
                Manage Users
            </a>
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-outline">
                Manage Categories
            </a>
            <a href="${pageContext.request.contextPath}/admin/categories?action=add" class="btn btn-accent">
                + Add Category
            </a>
        </div>

        <%-- Pending Users Table --%>
        <div class="card">
            <div class="card-title">⏳ Users Awaiting Approval
                <span class="badge badge-pending" style="margin-left:0.5rem;">${pendingCount}</span>
            </div>
            <div class="card-subtitle">These users have registered and are waiting for your approval.</div>

            <c:choose>
                <c:when test="${empty pendingUsers}">
                    <div class="alert alert-success">✅ No pending approvals — you're all caught up!</div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Institution</th>
                                <th>Registered</th>
                                <th>Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="user" items="${pendingUsers}" varStatus="s">
                                <tr>
                                    <td>${s.count}</td>
                                    <td>${user.fullName}</td>
                                    <td>${user.email}</td>
                                    <td><span class="badge badge-pending">${user.role}</span></td>
                                    <td>${user.institution}</td>
                                    <td>${user.createdAt}</td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/users"
                                              method="post" style="display:inline;">
                                            <input type="hidden" name="action"  value="approve">
                                            <input type="hidden" name="userId"  value="${user.userId}">
                                            <button type="submit" class="btn btn-primary btn-sm">
                                                Approve
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</main>

<footer>
    <p>&copy; 2026 EduAid Admin Panel. Logged in as <strong>${sessionScope.userName}</strong>.</p>
</footer>

<script src="${pageContext.request.contextPath}/js/validation.js"></script>
</body>
</html>