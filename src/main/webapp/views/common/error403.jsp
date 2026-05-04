<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied – EduAid</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card" style="text-align:center;">
        <div style="font-size:4rem; margin-bottom:1rem;">🚫</div>
        <h1 style="color:var(--error); font-size:2.5rem; margin-bottom:0.5rem;">403</h1>
        <h2 style="margin-bottom:1rem;">Access Denied</h2>
        <p style="color:var(--text-mid); margin-bottom:1.5rem;">
            You do not have permission to access this page.
            Please contact an administrator if you believe this is a mistake.
        </p>
        <a href="${pageContext.request.contextPath}/auth?action=login" class="btn btn-primary">
            ← Back to Login
        </a>
    </div>
</div>
</body>
</html>
