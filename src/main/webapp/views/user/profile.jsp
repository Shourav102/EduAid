<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile – EduAid</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/views/common/navbar.jsp" />

<main>
    <div class="container">
        <div class="page-header">
            <h1>My Profile</h1>
        </div>

        <div class="card" style="max-width: 700px; margin: 0 auto;">
            <div class="card-title">Account Information</div>

            <div style="display: grid; grid-template-columns: 140px 1fr; gap: 12px 20px; line-height: 1.8;">
                <strong>Full Name:</strong>
                <span>${sessionScope.loggedInUser.fullName}</span>

                <strong>Email:</strong>
                <span>${sessionScope.loggedInUser.email}</span>

                <strong>Phone:</strong>
                <span>${sessionScope.loggedInUser.phone}</span>

                <strong>Role:</strong>
                <span>${sessionScope.loggedInUser.role}</span>

                <strong>Institution:</strong>
                <span>${sessionScope.loggedInUser.institution}</span>

                <strong>Address:</strong>
                <span>${sessionScope.loggedInUser.address}</span>

                <strong>Member Since:</strong>
                <span>${sessionScope.loggedInUser.createdAt}</span>
            </div>

            <div style="margin-top: 2rem;">
                <a href="#" class="btn btn-primary">Edit Profile</a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp" />

</body>
</html>