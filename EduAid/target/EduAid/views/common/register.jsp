<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register – EduAid</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%-- ============================================================
     REGISTRATION PAGE
     Displays server-side validation errors inline under each field.
     Repopulates all fields on validation failure (except passwords).
     ============================================================ --%>

<div class="auth-wrapper" style="padding: 2rem 1rem;">
    <div class="auth-card wide">

        <%-- Logo / Branding --%>
        <div class="auth-logo">
            <div class="logo-icon">📚</div>
            <h1>Edu<span style="color:var(--accent)">Aid</span></h1>
            <p>Create your account – join us in reducing educational inequality</p>
        </div>

        <%-- General error (e.g. DB failure) --%>
        <c:if test="${not empty errors['general']}">
            <div class="alert alert-error">⚠ ${errors['general']}</div>
        </c:if>

        <%-- Registration Form --%>
        <form action="${pageContext.request.contextPath}/auth"
              method="post"
              novalidate
              id="registerForm">
            <input type="hidden" name="action" value="register">

            <div class="form-grid">

                <%-- Full Name --%>
                <div class="form-group full-width">
                    <label class="form-label" for="fullName">
                        Full Name <span class="required">*</span>
                    </label>
                    <input type="text"
                           id="fullName"
                           name="fullName"
                           class="form-control ${not empty errors['fullName'] ? 'is-invalid' : ''}"
                           placeholder="e.g. Priya Sharma"
                           value="${not empty fullName ? fullName : ''}"
                           maxlength="150"
                           required>
                    <c:if test="${not empty errors['fullName']}">
                        <div class="field-error">${errors['fullName']}</div>
                    </c:if>
                </div>

                <%-- Email --%>
                <div class="form-group">
                    <label class="form-label" for="email">
                        Email Address <span class="required">*</span>
                    </label>
                    <input type="email"
                           id="email"
                           name="email"
                           class="form-control ${not empty errors['email'] ? 'is-invalid' : ''}"
                           placeholder="you@example.com"
                           value="${not empty email ? email : ''}"
                           required
                           autocomplete="email">
                    <c:if test="${not empty errors['email']}">
                        <div class="field-error">${errors['email']}</div>
                    </c:if>
                </div>

                <%-- Phone --%>
                <div class="form-group">
                    <label class="form-label" for="phone">
                        Phone Number <span class="required">*</span>
                    </label>
                    <input type="tel"
                           id="phone"
                           name="phone"
                           class="form-control ${not empty errors['phone'] ? 'is-invalid' : ''}"
                           placeholder="10-digit number"
                           value="${not empty phone ? phone : ''}"
                           maxlength="10"
                           required>
                    <c:if test="${not empty errors['phone']}">
                        <div class="field-error">${errors['phone']}</div>
                    </c:if>
                </div>

                <%-- Password --%>
                <div class="form-group">
                    <label class="form-label" for="password">
                        Password <span class="required">*</span>
                    </label>
                    <input type="password"
                           id="password"
                           name="password"
                           class="form-control ${not empty errors['password'] ? 'is-invalid' : ''}"
                           placeholder="Min 8 chars, upper, lower, digit, special"
                           required
                           autocomplete="new-password">
                    <c:if test="${not empty errors['password']}">
                        <div class="field-error">${errors['password']}</div>
                    </c:if>
                </div>

                <%-- Confirm Password --%>
                <div class="form-group">
                    <label class="form-label" for="confirmPassword">
                        Confirm Password <span class="required">*</span>
                    </label>
                    <input type="password"
                           id="confirmPassword"
                           name="confirmPassword"
                           class="form-control ${not empty errors['confirmPass'] ? 'is-invalid' : ''}"
                           placeholder="Re-enter your password"
                           required
                           autocomplete="new-password">
                    <c:if test="${not empty errors['confirmPass']}">
                        <div class="field-error">${errors['confirmPass']}</div>
                    </c:if>
                </div>

                <%-- Role Selection --%>
                <div class="form-group">
                    <label class="form-label" for="role">
                        I want to register as <span class="required">*</span>
                    </label>
                    <select id="role"
                            name="role"
                            class="form-control ${not empty errors['role'] ? 'is-invalid' : ''}"
                            required>
                        <option value="" disabled ${empty role ? 'selected' : ''}>-- Select role --</option>
                        <option value="DONOR"     ${role == 'DONOR'     ? 'selected' : ''}>
                            Donor (I want to donate resources)
                        </option>
                        <option value="RECIPIENT" ${role == 'RECIPIENT' ? 'selected' : ''}>
                            Recipient (I want to receive resources)
                        </option>
                    </select>
                    <c:if test="${not empty errors['role']}">
                        <div class="field-error">${errors['role']}</div>
                    </c:if>
                </div>

                <%-- Date of Birth --%>
                <div class="form-group">
                    <label class="form-label" for="dob">
                        Date of Birth <span class="required">*</span>
                    </label>
                    <input type="date"
                           id="dob"
                           name="dob"
                           class="form-control ${not empty errors['dob'] ? 'is-invalid' : ''}"
                           value="${not empty dob ? dob : ''}"
                           required>
                    <c:if test="${not empty errors['dob']}">
                        <div class="field-error">${errors['dob']}</div>
                    </c:if>
                </div>

                <%-- Institution --%>
                <div class="form-group full-width">
                    <label class="form-label" for="institution">
                        School / University <span class="required">*</span>
                    </label>
                    <input type="text"
                           id="institution"
                           name="institution"
                           class="form-control ${not empty errors['institution'] ? 'is-invalid' : ''}"
                           placeholder="e.g. Islington College, Kathmandu"
                           value="${not empty institution ? institution : ''}"
                           maxlength="200"
                           required>
                    <c:if test="${not empty errors['institution']}">
                        <div class="field-error">${errors['institution']}</div>
                    </c:if>
                </div>

                <%-- Address --%>
                <div class="form-group full-width">
                    <label class="form-label" for="address">
                        Address <span class="required">*</span>
                    </label>
                    <textarea id="address"
                              name="address"
                              class="form-control ${not empty errors['address'] ? 'is-invalid' : ''}"
                              placeholder="Your current address"
                              rows="2"
                              maxlength="300"
                              required>${not empty address ? address : ''}</textarea>
                    <c:if test="${not empty errors['address']}">
                        <div class="field-error">${errors['address']}</div>
                    </c:if>
                </div>

            </div><%-- end form-grid --%>

            <%-- Info note about approval --%>
            <div class="alert alert-info" style="margin-bottom:1.2rem;">
                ℹ Your account will require <strong>admin approval</strong> before you can log in.
                You will be notified once approved.
            </div>

            <%-- Submit --%>
            <button type="submit" class="btn btn-primary btn-full btn-lg" id="submitBtn">
                Create Account
            </button>

        </form>

        <div class="divider">or</div>

        <p style="text-align:center; font-size:0.9rem; color:var(--text-mid);">
            Already have an account?
            <a href="${pageContext.request.contextPath}/auth?action=login" style="font-weight:600;">
                Sign in
            </a>
        </p>

    </div>
</div>

<footer>
    <p>&copy; 2026 EduAid. Reducing educational inequality, one resource at a time.</p>
</footer>

<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<script>
    // Client-side validation for the registration form
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        let valid = true;

        // Full name - letters only
        const fullName = document.getElementById('fullName').value.trim();
        if (!fullName) {
            markInvalid('fullName', 'Full name is required.');
            valid = false;
        } else if (!/^[A-Za-z\s'\-]{2,100}$/.test(fullName)) {
            markInvalid('fullName', 'Full name must contain letters only.');
            valid = false;
        } else {
            markValid('fullName');
        }

        // Email
        const email = document.getElementById('email').value.trim();
        if (!email || !isValidEmail(email)) {
            markInvalid('email', 'Please enter a valid email address.');
            valid = false;
        } else { markValid('email'); }

        // Phone - 10 digits
        const phone = document.getElementById('phone').value.trim();
        if (!/^[0-9]{10}$/.test(phone)) {
            markInvalid('phone', 'Phone must be exactly 10 digits.');
            valid = false;
        } else { markValid('phone'); }

        // Password strength
        const password = document.getElementById('password').value;
        if (!isStrongPassword(password)) {
            markInvalid('password', 'Password must have 8+ chars, uppercase, lowercase, digit, special char.');
            valid = false;
        } else { markValid('password'); }

        // Confirm password
        const confirmPassword = document.getElementById('confirmPassword').value;
        if (password !== confirmPassword) {
            markInvalid('confirmPassword', 'Passwords do not match.');
            valid = false;
        } else { markValid('confirmPassword'); }

        // Role
        const role = document.getElementById('role').value;
        if (!role) {
            markInvalid('role', 'Please select a role.');
            valid = false;
        } else { markValid('role'); }

        if (!valid) e.preventDefault();
    });

    // Phone: allow only digits
    document.getElementById('phone').addEventListener('input', function() {
        this.value = this.value.replace(/\D/g, '');
    });
</script>
</body>
</html>
