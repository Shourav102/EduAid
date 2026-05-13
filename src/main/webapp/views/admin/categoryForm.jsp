<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${editMode ? 'Edit' : 'Add'} Category – EduAid Admin</title>
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
        <li><a href="${pageContext.request.contextPath}/admin/users">Users</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/categories" class="active">Categories</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/inquiries">Inquiries</a></li>
        <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
        <li><a href="${pageContext.request.contextPath}/auth?action=logout" class="btn-nav-accent">Logout</a></li>
    </ul>
</nav>

<main>
    <div class="container-sm" style="max-width:600px;">

        <div class="page-header">
            <h1>${editMode ? '✏️ Edit Category' : '➕ Add New Category'}</h1>
            <p>${editMode ? 'Update the category name and description.' : 'Create a new resource category for EduAid.'}</p>
        </div>

        <c:if test="${not empty errors['general']}">
            <div class="alert alert-error">⚠ ${errors['general']}</div>
        </c:if>

        <div class="card">
            <form action="${pageContext.request.contextPath}/admin/categories"
                  method="post"
                  novalidate
                  id="categoryForm">

                <input type="hidden" name="action" value="${editMode ? 'edit' : 'add'}">
                <c:if test="${editMode}">
                    <input type="hidden" name="categoryId" value="${category.categoryId}">
                </c:if>

                <div class="form-group">
                    <label class="form-label" for="name">
                        Category Name <span class="required">*</span>
                    </label>
                    <input type="text"
                           id="name"
                           name="name"
                           class="form-control ${not empty errors['name'] ? 'is-invalid' : ''}"
                           placeholder="e.g. Books, Lab Equipment, Stationery"
                           value="${editMode ? category.name : (not empty name ? name : '')}"
                           maxlength="100"
                           required>
                    <c:if test="${not empty errors['name']}">
                        <div class="field-error">${errors['name']}</div>
                    </c:if>
                </div>

                <div class="form-group">
                    <label class="form-label" for="description">
                        Description <span class="required">*</span>
                    </label>
                    <textarea id="description"
                              name="description"
                              class="form-control ${not empty errors['description'] ? 'is-invalid' : ''}"
                              placeholder="Briefly describe what this category includes..."
                              rows="3"
                              maxlength="300"
                              required>${editMode ? category.description : (not empty description ? description : '')}</textarea>
                    <c:if test="${not empty errors['description']}">
                        <div class="field-error">${errors['description']}</div>
                    </c:if>
                </div>

                <div style="display:flex; gap:0.75rem; margin-top:1.5rem;">
                    <button type="submit" class="btn btn-primary">
                        ${editMode ? '💾 Save Changes' : '➕ Create Category'}
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/categories"
                       class="btn btn-outline">
                        Cancel
                    </a>
                </div>

            </form>
        </div>

    </div>
</main>

<footer>
    <p>&copy; 2026 EduAid Admin Panel.</p>
</footer>

<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<script>
    document.getElementById('categoryForm').addEventListener('submit', function(e) {
        let valid = true;

        const name = document.getElementById('name').value.trim();
        if (!name) {
            markInvalid('name', 'Category name is required.');
            valid = false;
        } else if (name.length > 100) {
            markInvalid('name', 'Category name must not exceed 100 characters.');
            valid = false;
        } else {
            markValid('name');
        }

        const desc = document.getElementById('description').value.trim();
        if (!desc) {
            markInvalid('description', 'Description is required.');
            valid = false;
        } else {
            markValid('description');
        }

        if (!valid) e.preventDefault();
    });
</script>
</body>
</html>