<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard – EduAid</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/views/common/navbar.jsp" />

<main>
    <div class="container">

        <div class="page-header">
            <h1>Welcome, ${sessionScope.userName} 👋</h1>
            <p>Role: <strong>${sessionScope.userRole}</strong> | Let's make education more accessible together.</p>
        </div>

        <!-- Quick Action Cards -->
        <div class="stats-grid" style="grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1.5rem;">
            <a href="#" class="stat-card">
                <div class="stat-icon">📦</div>
                <div class="stat-label">Donate a Resource</div>
            </a>
            <a href="#" class="stat-card">
                <div class="stat-icon">🔎</div>
                <div class="stat-label">Browse Resources</div>
            </a>
            <a href="#" class="stat-card">
                <div class="stat-icon">📋</div>
                <div class="stat-label">My Requests</div>
            </a>
            <a href="#" class="stat-card">
                <div class="stat-icon">❤️</div>
                <div class="stat-label">My Wishlist</div>
            </a>
        </div>

        <div class="card">
            <div class="card-title">Recent Activity</div>
            <p style="color: #666;">You don't have any recent activity yet. Start contributing by donating or requesting resources!</p>
        </div>

    </div>
</main>

<jsp:include page="/views/common/footer.jsp" />

</body>
</html>