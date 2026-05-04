<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Server Error – EduAid</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card" style="text-align:center;">
        <div style="font-size:4rem; margin-bottom:1rem;">⚙️</div>
        <h1 style="color:var(--error); font-size:2.5rem; margin-bottom:0.5rem;">500</h1>
        <h2 style="margin-bottom:1rem;">Internal Server Error</h2>
        <p style="color:var(--text-mid); margin-bottom:1.5rem;">
            Something went wrong on our end. Please try again later
            or contact the EduAid administrator.
        </p>
        <a href="${pageContext.request.contextPath}/auth?action=login" class="btn btn-primary">
            ← Back to Home
        </a>
    </div>
</div>
</body>
</html>
