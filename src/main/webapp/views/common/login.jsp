<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – EduAid</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .auth-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
            background: linear-gradient(135deg, #e8f5ee 0%, #f0f7f3 100%);
        }

        .auth-card {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 2.5rem;
            width: 100%;
            max-width: 440px;
            transition: transform 0.3s ease;
        }

        .auth-card:hover {
            transform: translateY(-5px);
        }

        .auth-logo {
            text-align: center;
            margin-bottom: 2rem;
        }

        .logo-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #1a6b4a, #0d4d33);
            border-radius: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 12px rgba(26, 107, 74, 0.2);
        }

        .auth-logo h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: #1a6b4a;
        }

        .auth-logo p {
            font-size: 0.9rem;
            color: #718096;
            margin-top: 0.25rem;
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 0.5rem;
        }

        .form-label .required {
            color: #c0392b;
            margin-left: 2px;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            border: 1.5px solid #e2e8e6;
            border-radius: 10px;
            background: #ffffff;
            transition: all 0.2s ease;
            outline: none;
        }

        .form-control:focus {
            border-color: #1a6b4a;
            box-shadow: 0 0 0 3px rgba(26, 107, 74, 0.1);
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .checkbox-group input {
            width: 16px;
            height: 16px;
            accent-color: #1a6b4a;
            cursor: pointer;
        }

        .checkbox-group label {
            font-size: 0.9rem;
            color: #4a5568;
            cursor: pointer;
        }

        .btn-primary {
            width: 100%;
            background: #1a6b4a;
            color: white;
            padding: 0.85rem;
            font-size: 1rem;
            font-weight: 600;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-top: 0.5rem;
        }

        .btn-primary:hover {
            background: #134d35;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(26, 107, 74, 0.3);
        }

        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 1.5rem 0;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #e2e8e6;
        }

        .divider span {
            padding: 0 1rem;
            color: #a0aec0;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .register-link {
            text-align: center;
            font-size: 0.9rem;
            color: #4a5568;
        }

        .register-link a {
            color: #1a6b4a;
            font-weight: 600;
            text-decoration: none;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .alert {
            padding: 0.75rem 1rem;
            border-radius: 10px;
            font-size: 0.85rem;
            margin-bottom: 1.25rem;
        }

        .alert-success {
            background: #e8f5ee;
            color: #1a6b4a;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #fdf0ef;
            color: #c0392b;
            border: 1px solid #f5c6cb;
        }

        .footer-mini {
            text-align: center;
            padding: 1.5rem;
            background: #155a3e;
            color: #a8d5be;
            font-size: 0.8rem;
        }

        .footer-mini a {
            color: #f4a226;
            text-decoration: none;
        }

        .footer-mini a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="auth-wrapper">
    <div class="auth-card">

        <div class="auth-logo">
            <div class="logo-icon">📚</div>
            <h1>Edu<span style="color:#f4a226">Aid</span></h1>
            <p>Sign in to your account</p>
        </div>

        <%-- Registration success message --%>
        <c:if test="${not empty sessionScope.registrationSuccess}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${sessionScope.registrationSuccess}
            </div>
            <% session.removeAttribute("registrationSuccess"); %>
        </c:if>

        <%-- Login error message --%>
        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-triangle"></i> ${requestScope.errorMessage}
            </div>
        </c:if>

        <%-- Login Form --%>
        <form action="${pageContext.request.contextPath}/auth" method="post" novalidate id="loginForm">
            <input type="hidden" name="action" value="login">

            <div class="form-group">
                <label class="form-label" for="email">
                    Email Address <span class="required">*</span>
                </label>
                <input type="email"
                       id="email"
                       name="email"
                       class="form-control"
                       placeholder="you@example.com"
                       value="${not empty rememberedEmail ? rememberedEmail : (not empty email ? email : '')}"
                       required>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">
                    Password <span class="required">*</span>
                </label>
                <input type="password"
                       id="password"
                       name="password"
                       class="form-control"
                       placeholder="Enter your password"
                       required>
            </div>

            <div class="form-group" style="display: flex; justify-content: space-between; align-items: center;">
                <div class="checkbox-group">
                    <input type="checkbox" id="rememberMe" name="rememberMe"
                    ${not empty rememberedEmail ? 'checked' : ''}>
                    <label for="rememberMe">Remember me</label>
                </div>
                <a href="${pageContext.request.contextPath}/auth?action=forgot-password" style="font-size: 0.85rem; color: #1a6b4a;">Forgot password?</a>
            </div>

            <button type="submit" class="btn-primary">
                <i class="fas fa-sign-in-alt"></i> Sign In
            </button>
        </form>

        <div class="divider">
            <span>or</span>
        </div>

        <div class="register-link">
            Don't have an account? <a href="${pageContext.request.contextPath}/auth?action=register">Register here</a>
        </div>

    </div>
</div>

<div class="footer-mini">
    <p>&copy; 2026 EduAid. Reducing educational inequality, one resource at a time.
        | <a href="${pageContext.request.contextPath}/about">About</a>
        | <a href="${pageContext.request.contextPath}/contact">Contact</a>
    </p>
</div>

<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<script>
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        let valid = true;
        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value.trim();

        if (!email) {
            alert('Email address is required.');
            valid = false;
        } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            alert('Please enter a valid email address.');
            valid = false;
        }
        if (!password) {
            alert('Password is required.');
            valid = false;
        }
        if (!valid) e.preventDefault();
    });
</script>
</body>
</html>