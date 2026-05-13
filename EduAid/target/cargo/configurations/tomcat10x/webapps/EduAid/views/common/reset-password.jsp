<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reset Password – EduAid</title>
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
    }
    .auth-logo { text-align: center; margin-bottom: 2rem; }
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
    }
    .auth-logo h1 { font-size: 1.8rem; font-weight: 700; color: #1a6b4a; }
    .auth-logo p { font-size: 0.9rem; color: #718096; margin-top: 0.25rem; }
    .form-group { margin-bottom: 1.25rem; }
    .form-label { display: block; font-size: 0.85rem; font-weight: 600; color: #4a5568; margin-bottom: 0.5rem; }
    .form-control {
      width: 100%;
      padding: 0.75rem 1rem;
      font-size: 0.95rem;
      border: 1.5px solid #e2e8e6;
      border-radius: 10px;
      transition: all 0.2s ease;
    }
    .form-control:focus { border-color: #1a6b4a; outline: none; box-shadow: 0 0 0 3px rgba(26,107,74,0.1); }
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
    }
    .btn-primary:hover { background: #134d35; transform: translateY(-2px); }
    .alert-error { background: #fdf0ef; color: #c0392b; padding: 0.75rem 1rem; border-radius: 10px; margin-bottom: 1rem; border: 1px solid #f5c6cb; }
    .password-requirements { font-size: 0.75rem; color: #718096; margin-top: 0.25rem; }
    .back-link { text-align: center; margin-top: 1.5rem; }
    .back-link a { color: #1a6b4a; text-decoration: none; }
  </style>
</head>
<body>

<div class="auth-wrapper">
  <div class="auth-card">
    <div class="auth-logo">
      <div class="logo-icon"><i class="fas fa-lock"></i></div>
      <h1>Edu<span style="color:#f4a226">Aid</span></h1>
      <p>Create new password</p>
    </div>

    <c:if test="${not empty errorMessage}">
      <div class="alert-error"><i class="fas fa-exclamation-triangle"></i> ${errorMessage}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/auth" method="post" id="resetForm">
      <input type="hidden" name="action" value="reset-password">
      <input type="hidden" name="token" value="${param.token}">
      <input type="hidden" name="email" value="${param.email}">

      <div class="form-group">
        <label class="form-label" for="password">New Password</label>
        <input type="password" id="password" name="password" class="form-control" required>
        <div class="password-requirements">Min 8 chars, 1 uppercase, 1 lowercase, 1 number, 1 special character</div>
      </div>

      <div class="form-group">
        <label class="form-label" for="confirmPassword">Confirm Password</label>
        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
      </div>

      <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Reset Password</button>
    </form>

    <div class="back-link">
      <a href="${pageContext.request.contextPath}/auth?action=login"><i class="fas fa-arrow-left"></i> Back to Login</a>
    </div>
  </div>
</div>

<script>
  document.getElementById('resetForm').addEventListener('submit', function(e) {
    var password = document.getElementById('password').value;
    var confirm = document.getElementById('confirmPassword').value;

    if (!password) {
      alert('Please enter a new password');
      e.preventDefault();
      return;
    }

    if (password !== confirm) {
      alert('Passwords do not match');
      e.preventDefault();
      return;
    }

    var strongPassword = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$/;
    if (!strongPassword.test(password)) {
      alert('Password must be at least 8 characters with uppercase, lowercase, number, and special character');
      e.preventDefault();
    }
  });
</script>
</body>
</html>