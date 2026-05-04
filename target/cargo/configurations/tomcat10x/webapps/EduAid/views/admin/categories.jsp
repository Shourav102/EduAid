<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categories – EduAid Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand">
        📚 Edu<span>Aid</span> <span style="font-size:0.75rem; opacity:0.75; font-weight:400;">Admin</span>
    </a>
    <button class="navbar-toggle" aria-label="Toggle navigation">
        <span></span><span></span><span></span>
    </button>
    <ul class="navbar-links">
        <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/users">Users</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/categories" class="active">Categories</a></li>
        <li><a href="${pageContext.request.contextPath}/about">About</a></li>
        <li><a href="${pageContext.request.contextPath}/auth?action=logout" class="btn-nav-accent">Logout</a></li>
    </ul>
</nav>

<main>
    <div class="container">

        <div class="page-header" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:1rem;">
            <div>
                <h1>🗂️ Category Management</h1>
                <p>Add, edit, or delete resource categories used across EduAid.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/categories?action=add"
               class="btn btn-accent">
                + Add New Category
            </a>
        </div>

        <%-- Flash messages --%>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">✅ ${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">⚠ ${errorMessage}</div>
        </c:if>

        <div class="card">
            <c:choose>
                <c:when test="${empty categories}">
                    <div class="alert alert-info">
                        ℹ No categories yet.
                        <a href="${pageContext.request.contextPath}/admin/categories?action=add">
                            Add the first category.
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Category Name</th>
                                    <th>Description</th>
                                    <th>Created</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="cat" items="${categories}" varStatus="s">
                                    <tr>
                                        <td>${s.count}</td>
                                        <td><strong>${cat.name}</strong></td>
                                        <td>${cat.description}</td>
                                        <td style="font-size:0.8rem; color:var(--text-light);">
                                            ${cat.createdAt}
                                        </td>
                                        <td>
                                            <div style="display:flex; gap:0.4rem;">
                                                <%-- Edit --%>
                                                <a href="${pageContext.request.contextPath}/admin/categories?action=edit&id=${cat.categoryId}"
                                                   class="btn btn-outline btn-sm">
                                                    ✏ Edit
                                                </a>
                                                <%-- Delete --%>
                                                <form action="${pageContext.request.contextPath}/admin/categories"
                                                      method="post"
                                                      onsubmit="return confirm('Delete category \'${cat.name}\'? This cannot be undone.');">
                                                    <input type="hidden" name="action"     value="delete">
                                                    <input type="hidden" name="categoryId" value="${cat.categoryId}">
                                                    <button type="submit" class="btn btn-danger btn-sm">
                                                        🗑 Delete
                                                    </button>
                                                </form>
                                            </div>
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
    <p>&copy; 2026 EduAid Admin Panel.</p>
</footer>

<script src="${pageContext.request.contextPath}/js/validation.js"></script>
</body>
</html>
