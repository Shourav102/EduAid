<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Pending – EduAid</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/views/common/navbar.jsp" />

<main>
    <div class="container" style="max-width: 600px; text-align: center; padding-top: 4rem;">
        <div class="card">
            <h1 style="color: #f4a226;">⏳ Account Under Review</h1>
            <p style="font-size: 1.1rem; margin: 1.5rem 0;">
                Thank you for registering with EduAid.<br>
                Your account is currently awaiting approval from an administrator.
            </p>
            <p>We will notify you once your account has been approved.</p>

            <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-primary" style="margin-top: 2rem;">
                Back to Login
            </a>
        </div>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp" />

</body>
</html>