<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management – EduAid Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/home" class="navbar-brand">
        📚 Edu<span>Aid</span> <span style="font-size:0.75rem; opacity:0.75; font-weight:400;">Admin</span>
    </a>
    <button class="navbar-toggle" aria-label="Toggle navigation">
        <span></span><span></span><span></span>
    </button>
    <ul class="navbar-links">
        <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/users" class="active">Users</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/inquiries">Inquiries</a></li>
        <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
        <li><a href="${pageContext.request.contextPath}/auth?action=logout" class="btn-nav-accent">Logout</a></li>
    </ul>
</nav>

<main>
    <div class="container">

        <div class="page-header">
            <h1>👥 User Management</h1>
            <p>View, approve, and manage all registered user accounts.</p>
        </div>

        <%-- Flash messages --%>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">✅ ${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">⚠ ${errorMessage}</div>
        </c:if>

        <div class="card">
            <div class="card-title">All Registered Users</div>

            <%-- Search/filter bar --%>
            <div style="margin-bottom:1rem;">
                <input type="text"
                       id="userSearch"
                       class="form-control"
                       placeholder="🔍 Search by name, email or role..."
                       style="max-width:360px;"
                       oninput="filterTable()">
            </div>

            <c:choose>
                <c:when test="${empty users}">
                    <div class="alert alert-info">ℹ No users registered yet.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrapper">
                        <table class="data-table" id="usersTable">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Institution</th>
                                <th>Registered</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="user" items="${users}" varStatus="s">
                                <tr>
                                    <td>${s.count}</td>
                                    <td>${user.fullName}</td>
                                    <td>${user.email}</td>
                                    <td>${user.phone}</td>
                                    <td>
                                            <span class="badge ${user.role == 'ADMIN' ? 'badge-approved' : 'badge-pending'}">
                                                    ${user.role}
                                            </span>
                                    </td>
                                    <td>
                                            <span class="badge
                                                ${user.status == 'APPROVED' ? 'badge-approved' :
                                                  user.status == 'PENDING'  ? 'badge-pending'  :
                                                                              'badge-disabled'}">
                                                    ${user.status}
                                            </span>
                                    </td>
                                    <td>${user.institution}</td>
                                    <td style="font-size:0.8rem; color:var(--text-light);">
                                            ${user.createdAt}
                                    </td>
                                    <td>
                                            <%-- Only show action buttons for non-admin users --%>
                                        <c:if test="${user.role != 'ADMIN'}">
                                            <div style="display:flex; gap:0.4rem; flex-wrap:wrap;">

                                                    <%-- Approve button: show only if PENDING --%>
                                                <c:if test="${user.status == 'PENDING'}">
                                                    <form action="${pageContext.request.contextPath}/admin/users"
                                                          method="post">
                                                        <input type="hidden" name="action" value="approve">
                                                        <input type="hidden" name="userId" value="${user.userId}">
                                                        <button type="submit" class="btn btn-primary btn-sm">
                                                            ✓ Approve
                                                        </button>
                                                    </form>
                                                </c:if>

                                                    <%-- Disable button: show only if APPROVED --%>
                                                <c:if test="${user.status == 'APPROVED'}">
                                                    <form action="${pageContext.request.contextPath}/admin/users"
                                                          method="post"
                                                          onsubmit="return confirm('Disable ${user.fullName}\'s account?');">
                                                        <input type="hidden" name="action" value="disable">
                                                        <input type="hidden" name="userId" value="${user.userId}">
                                                        <button type="submit" class="btn btn-danger btn-sm">
                                                            ✕ Disable
                                                        </button>
                                                    </form>
                                                </c:if>

                                                    <%-- Re-approve button: show only if DISABLED --%>
                                                <c:if test="${user.status == 'DISABLED'}">
                                                    <form action="${pageContext.request.contextPath}/admin/users"
                                                          method="post">
                                                        <input type="hidden" name="action" value="approve">
                                                        <input type="hidden" name="userId" value="${user.userId}">
                                                        <button type="submit" class="btn btn-outline btn-sm">
                                                            ↺ Re-enable
                                                        </button>
                                                    </form>
                                                </c:if>

                                            </div>
                                        </c:if>
                                        <c:if test="${user.role == 'ADMIN'}">
                                            <span style="font-size:0.8rem; color:var(--text-light);">—</span>
                                        </c:if>
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
<script>
    function filterTable() {
        const query = document.getElementById('userSearch').value.toLowerCase();
        const rows = document.querySelectorAll('#usersTable tbody tr');
        rows.forEach(function(row) {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(query) ? '' : 'none';
        });
    }
</script>
</body>
</html>