<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register – EduAid</title>
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
            max-width: 680px;
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

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 0.4rem;
        }

        .form-label .required {
            color: #c0392b;
            margin-left: 2px;
        }

        .form-control {
            width: 100%;
            padding: 0.7rem 0.9rem;
            font-size: 0.9rem;
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

        .form-control.is-invalid {
            border-color: #c0392b;
        }

        .field-error {
            font-size: 0.75rem;
            color: #c0392b;
            margin-top: 0.25rem;
        }

        select.form-control {
            cursor: pointer;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 80px;
        }

        .alert-info {
            background: #e8f4fd;
            color: #0c5460;
            border: 1px solid #bee5eb;
            padding: 0.75rem 1rem;
            border-radius: 10px;
            font-size: 0.85rem;
            margin: 1rem 0;
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

        .login-link {
            text-align: center;
            font-size: 0.9rem;
            color: #4a5568;
        }

        .login-link a {
            color: #1a6b4a;
            font-weight: 600;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
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

        @media (max-width: 640px) {
            .auth-card { padding: 1.5rem; }
            .form-grid { grid-template-columns: 1fr; }
            .form-grid .full-width { grid-column: 1; }
        }
    </style>
</head>
<body>

<div class="auth-wrapper">
    <div class="auth-card">

        <div class="auth-logo">
            <div class="logo-icon">📚</div>
            <h1>Edu<span style="color:#f4a226">Aid</span></h1>
            <p>Create your account</p>
        </div>

        <%-- General error --%>
        <c:if test="${not empty errors['general']}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-triangle"></i> ${errors['general']}
            </div>
        </c:if>

        <%-- Registration Form --%>
        <form action="${pageContext.request.contextPath}/auth" method="post" novalidate id="registerForm">
            <input type="hidden" name="action" value="register">

            <div class="form-grid">
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
                        <div class="field-error"><i class="fas fa-exclamation-circle"></i> ${errors['fullName']}</div>
                    </c:if>
                </div>

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
                           required>
                    <c:if test="${not empty errors['email']}">
                        <div class="field-error"><i class="fas fa-exclamation-circle"></i> ${errors['email']}</div>
                    </c:if>
                </div>

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
                        <div class="field-error"><i class="fas fa-exclamation-circle"></i> ${errors['phone']}</div>
                    </c:if>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">
                        Password <span class="required">*</span>
                    </label>
                    <input type="password"
                           id="password"
                           name="password"
                           class="form-control ${not empty errors['password'] ? 'is-invalid' : ''}"
                           placeholder="8+ chars with uppercase, lowercase, number, special"
                           required>
                    <c:if test="${not empty errors['password']}">
                        <div class="field-error"><i class="fas fa-exclamation-circle"></i> ${errors['password']}</div>
                    </c:if>
                </div>

                <div class="form-group">
                    <label class="form-label" for="confirmPassword">
                        Confirm Password <span class="required">*</span>
                    </label>
                    <input type="password"
                           id="confirmPassword"
                           name="confirmPassword"
                           class="form-control ${not empty errors['confirmPass'] ? 'is-invalid' : ''}"
                           placeholder="Re-enter your password"
                           required>
                    <c:if test="${not empty errors['confirmPass']}">
                        <div class="field-error"><i class="fas fa-exclamation-circle"></i> ${errors['confirmPass']}</div>
                    </c:if>
                </div>

                <div class="form-group">
                    <label class="form-label" for="role">
                        I want to register as <span class="required">*</span>
                    </label>
                    <select id="role"
                            name="role"
                            class="form-control ${not empty errors['role'] ? 'is-invalid' : ''}"
                            required>
                        <option value="" disabled ${empty role ? 'selected' : ''}>-- Select role --</option>
                        <option value="DONOR" ${role == 'DONOR' ? 'selected' : ''}>
                            📦 Donor (I want to donate resources)
                        </option>
                        <option value="RECIPIENT" ${role == 'RECIPIENT' ? 'selected' : ''}>
                            📚 Recipient (I want to receive resources)
                        </option>
                    </select>
                    <c:if test="${not empty errors['role']}">
                        <div class="field-error"><i class="fas fa-exclamation-circle"></i> ${errors['role']}</div>
                    </c:if>
                </div>

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
                        <div class="field-error"><i class="fas fa-exclamation-circle"></i> ${errors['dob']}</div>
                    </c:if>
                </div>

                <div class="form-group full-width">
                    <label class="form-label" for="institution">
                        School / University <span class="required">*</span>
                    </label>
                    <input type="text"
                           id="institution"
                           name="institution"
                           class="form-control ${not empty errors['institution'] ? 'is-invalid' : ''}"
                           placeholder="e.g. Islington College"
                           value="${not empty institution ? institution : ''}"
                           maxlength="200"
                           required>
                    <c:if test="${not empty errors['institution']}">
                        <div class="field-error"><i class="fas fa-exclamation-circle"></i> ${errors['institution']}</div>
                    </c:if>
                </div>

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
                        <div class="field-error"><i class="fas fa-exclamation-circle"></i> ${errors['address']}</div>
                    </c:if>
                </div>
            </div>

            <%-- Approval notice - FIXED text --%>
            <div class="alert-info">
                <i class="fas fa-info-circle"></i> <strong>Note:</strong> Your account will require <strong>admin approval</strong> before you can log in. You will be notified once approved.
            </div>

            <button type="submit" class="btn-primary">
                <i class="fas fa-user-plus"></i> Create Account
            </button>

        </form>

        <%-- Clean "or" divider --%>
        <div class="divider">
            <span>or</span>
        </div>

        <%-- Login link --%>
        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/auth?action=login">Sign in</a>
        </div>

    </div>
</div>

<%-- Consistent Footer --%>
<div class="footer-mini">
    <p>&copy; 2026 EduAid. Reducing educational inequality, one resource at a time.</p>
</div>

<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<script>
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        let valid = true;

        const fullName = document.getElementById('fullName').value.trim();
        if (!fullName) {
            alert('Full name is required.');
            valid = false;
        } else if (!/^[A-Za-z\s'\-]{2,100}$/.test(fullName)) {
            alert('Full name must contain letters only.');
            valid = false;
        }

        const email = document.getElementById('email').value.trim();
        if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            alert('Please enter a valid email address.');
            valid = false;
        }

        const phone = document.getElementById('phone').value.trim();
        if (!/^[0-9]{10}$/.test(phone)) {
            alert('Phone must be exactly 10 digits.');
            valid = false;
        }

        const password = document.getElementById('password').value;
        if (!/^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$/.test(password)) {
            alert('Password must have 8+ chars, uppercase, lowercase, digit, and special character.');
            valid = false;
        }

        const confirmPassword = document.getElementById('confirmPassword').value;
        if (password !== confirmPassword) {
            alert('Passwords do not match.');
            valid = false;
        }

        const role = document.getElementById('role').value;
        if (!role) {
            alert('Please select a role.');
            valid = false;
        }

        if (!valid) e.preventDefault();
    });

    document.getElementById('phone').addEventListener('input', function() {
        this.value = this.value.replace(/\D/g, '');
    });
</script>
</body>
</html>