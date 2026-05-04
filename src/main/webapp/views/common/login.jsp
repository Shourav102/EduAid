<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – EduAid</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%-- ============================================================
     LOGIN PAGE
     Displays error messages from AuthController (session / request attrs)
     Pre-fills email from remember-me cookie (rememberedEmail attr)
     ============================================================ --%>

<div class="auth-wrapper">
    <div class="auth-card">

        <%-- Logo / Branding --%>
        <div class="auth-logo">
            <div class="logo-icon">📚</div>
            <h1>Edu<span style="color:var(--accent)">Aid</span></h1>
            <p>Sign in to your account</p>
        </div>

        <%-- Registration success message (set in session after redirect) --%>
        <c:if test="${not empty sessionScope.registrationSuccess}">
            <div class="alert alert-success">
                ✅ ${sessionScope.registrationSuccess}
            </div>
            <% session.removeAttribute("registrationSuccess"); %>
        </c:if>

        <%-- Login error message from AuthController --%>
        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-error">
                ⚠ ${requestScope.errorMessage}
            </div>
        </c:if>

        <%-- Login Form --%>
        <form action="${pageContext.request.contextPath}/auth" method="post" novalidate id="loginForm">
            <input type="hidden" name="action" value="login">

            <%-- Email --%>
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
                       required
                       autocomplete="email">
                <div class="field-error" id="emailError" style="display:none;"></div>
            </div>

            <%-- Password --%>
            <div class="form-group">
                <label class="form-label" for="password">
                    Password <span class="required">*</span>
                </label>
                <input type="password"
                       id="password"
                       name="password"
                       class="form-control"
                       placeholder="Enter your password"
                       required
                       autocomplete="current-password">
                <div class="field-error" id="passwordError" style="display:none;"></div>
            </div>

            <%-- Remember Me --%>
            <div class="form-group" style="display:flex; justify-content:space-between; align-items:center;">
                <div class="checkbox-group">
                    <input type="checkbox" id="rememberMe" name="rememberMe"
                           ${not empty rememberedEmail ? 'checked' : ''}>
                    <label for="rememberMe">Remember me</label>
                </div>
                <a href="#" style="font-size:0.88rem; color:var(--primary);">Forgot password?</a>
            </div>

            <%-- Submit --%>
            <button type="submit" class="btn btn-primary btn-full btn-lg" id="submitBtn">
                Sign In
            </button>
        </form>

        <div class="divider">or</div>

        <%-- Register link --%>
        <p style="text-align:center; font-size:0.9rem; color:var(--text-mid);">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/auth?action=register" style="font-weight:600;">
                Register here
            </a>
        </p>

    </div>
</div>

<%-- Footer --%>
<footer>
    <p>&copy; 2026 EduAid. Reducing educational inequality, one resource at a time.
       | <a href="${pageContext.request.contextPath}/about">About</a>
       | <a href="${pageContext.request.contextPath}/contact">Contact</a>
    </p>
</footer>

<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<script>
    // Client-side validation for login form
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        let valid = true;

        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value.trim();

        // Email
        if (!email) {
            showError('emailError', 'Email address is required.');
            document.getElementById('email').classList.add('is-invalid');
            valid = false;
        } else if (!isValidEmail(email)) {
            showError('emailError', 'Please enter a valid email address.');
            document.getElementById('email').classList.add('is-invalid');
            valid = false;
        } else {
            hideError('emailError');
            document.getElementById('email').classList.remove('is-invalid');
        }

        // Password
        if (!password) {
            showError('passwordError', 'Password is required.');
            document.getElementById('password').classList.add('is-invalid');
            valid = false;
        } else {
            hideError('passwordError');
            document.getElementById('password').classList.remove('is-invalid');
        }

        if (!valid) e.preventDefault();
    });
</script>
</body>
</html>
