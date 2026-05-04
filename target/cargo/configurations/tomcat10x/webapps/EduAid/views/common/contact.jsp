<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Contact Us — EduAid</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    body { margin:0; padding:0; font-family:'Segoe UI',sans-serif; background-color:#f5f9f7; color:#1a1a1a; display:flex; flex-direction:column; min-height:100vh; }
    .contact-main { flex:1; }

    .contact-hero { background-color:#1a6b4a; color:#ffffff; padding:60px 24px 50px; text-align:center; }
    .contact-hero h1 { font-size:36px; font-weight:700; margin:0 0 12px; color:#ffffff; }
    .contact-hero h1 span { color:#f4a226; }
    .contact-hero p  { font-size:16px; color:#b8ddc8; margin:0 auto; max-width:500px; line-height:1.7; }

    .contact-wrapper { max-width:1100px; margin:0 auto; padding:60px 24px; display:flex; flex-wrap:wrap; gap:48px; align-items:flex-start; }

    .contact-form-card { flex:1 1 400px; background-color:#ffffff; border-radius:14px; padding:40px 36px; box-shadow:0 4px 20px rgba(0,0,0,0.07); }
    .form-section-title    { font-size:22px; font-weight:700; color:#1a3d2b; margin:0 0 6px; }
    .form-section-subtitle { font-size:14px; color:#666666; margin:0 0 28px; }

    .form-group { margin-bottom:20px; }
    .form-label { display:block; font-size:14px; font-weight:600; color:#1a3d2b; margin-bottom:6px; }
    .required   { color:#e53e3e; margin-left:2px; }

    .form-control { width:100%; padding:12px 14px; border:1.5px solid #c5e0d0; border-radius:8px; font-size:15px; font-family:'Segoe UI',sans-serif; background-color:#f9fdfb; color:#1a1a1a; box-sizing:border-box; transition:border-color 0.2s ease,box-shadow 0.2s ease; outline:none; }
    .form-control:focus { border-color:#1a6b4a; box-shadow:0 0 0 3px rgba(26,107,74,0.12); background-color:#ffffff; }
    .form-control.textarea-field { resize:vertical; min-height:130px; }

    .form-row { display:flex; gap:16px; flex-wrap:wrap; }
    .form-row .form-group { flex:1 1 180px; }

    .btn-submit { width:100%; padding:14px; background-color:#1a6b4a; color:#ffffff; font-size:16px; font-weight:600; font-family:'Segoe UI',sans-serif; border:none; border-radius:8px; cursor:pointer; margin-top:8px; transition:background-color 0.2s ease,transform 0.1s ease; }
    .btn-submit:hover  { background-color:#155a3e; transform:translateY(-1px); }
    .btn-submit:active { transform:translateY(0); }

    .success-msg { display:none; background-color:#eef7f2; border:1px solid #1a6b4a; border-radius:8px; padding:16px 20px; color:#1a6b4a; font-size:15px; font-weight:500; margin-top:16px; text-align:center; }

    .contact-info { flex:0 1 280px; display:flex; flex-direction:column; gap:20px; }
    .info-card { background-color:#ffffff; border-radius:12px; padding:24px 22px; box-shadow:0 2px 10px rgba(0,0,0,0.06); border-left:4px solid #1a6b4a; }
    .info-card-icon  { font-size:22px; margin-bottom:10px; display:block; }
    .info-card-title { font-size:15px; font-weight:600; color:#1a3d2b; margin-bottom:4px; }
    .info-card-text  { font-size:14px; color:#555555; line-height:1.6; margin:0; }

    .info-note   { background-color:#fff8ec; border:1px solid #f4a226; border-radius:10px; padding:18px 20px; }
    .info-note p { font-size:13px; color:#7a4f00; margin:0; line-height:1.7; }

    @media (max-width:768px) {
      .contact-hero h1  { font-size:26px; }
      .contact-hero     { padding:40px 20px 36px; }
      .contact-wrapper  { flex-direction:column; padding:32px 16px; gap:28px; }
      .contact-form-card { padding:28px 20px; }
      .form-row         { flex-direction:column; gap:0; }
      .contact-info     { flex:1 1 auto; width:100%; }
    }
  </style>
</head>
<body>

<%@ include file="/views/common/navbar.jsp" %>

<main class="contact-main">

  <section class="contact-hero">
    <h1>Get in <span>Touch</span></h1>
    <p>Have a question about EduAid? Fill in the form and we will get back to you.</p>
  </section>

  <div class="contact-wrapper">

    <div class="contact-form-card">
      <h2 class="form-section-title">Send us a message</h2>
      <p class="form-section-subtitle">All fields marked with * are required</p>

      <c:if test="${param.success eq 'true'}">
        <div class="success-msg" style="display:block;">
          &#10003; Your message was sent successfully! We will be in touch soon.
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/contact" method="post" id="contactForm">

        <div class="form-row">
          <div class="form-group">
            <label class="form-label" for="fullName">Full Name <span class="required">*</span></label>
            <input type="text" id="fullName" name="fullName" class="form-control" placeholder="e.g. John Smith" required maxlength="100"/>
          </div>
          <div class="form-group">
            <label class="form-label" for="email">Email Address <span class="required">*</span></label>
            <input type="email" id="email" name="email" class="form-control" placeholder="e.g. john@email.com" required maxlength="150"/>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="subject">Subject <span class="required">*</span></label>
          <input type="text" id="subject" name="subject" class="form-control" placeholder="What is your message about?" required maxlength="200"/>
        </div>

        <div class="form-group">
          <label class="form-label" for="message">Message <span class="required">*</span></label>
          <textarea id="message" name="message" class="form-control textarea-field" placeholder="Write your message here..." required maxlength="2000"></textarea>
        </div>

        <button type="submit" class="btn-submit">Send Message</button>

      </form>
    </div>

    <div class="contact-info">
      <div class="info-card">
        <span class="info-card-icon">&#128233;</span>
        <div class="info-card-title">Email Us</div>
        <p class="info-card-text">support@eduaid.com</p>
      </div>
      <div class="info-card">
        <span class="info-card-icon">&#128205;</span>
        <div class="info-card-title">Our Location</div>
        <p class="info-card-text">EduAid Platform<br>Educational Resource Centre<br>United Kingdom</p>
      </div>
      <div class="info-card">
        <span class="info-card-icon">&#128337;</span>
        <div class="info-card-title">Response Time</div>
        <p class="info-card-text">We aim to respond to all enquiries within 1 to 2 working days.</p>
      </div>
      <div class="info-note">
        <p>&#9888; If you are having trouble logging in or your account is still pending, please include your registered email address in the message.</p>
      </div>
    </div>

  </div>
</main>

<%@ include file="/views/common/footer.jsp" %>

<script>
  document.getElementById('contactForm').addEventListener('submit', function(e) {
    var name    = document.getElementById('fullName').value.trim();
    var email   = document.getElementById('email').value.trim();
    var subject = document.getElementById('subject').value.trim();
    var message = document.getElementById('message').value.trim();

    if (!name || !email || !subject || !message) {
      e.preventDefault();
      alert('Please fill in all required fields before submitting.');
      return;
    }

    if (/\d/.test(name)) {
      e.preventDefault();
      alert('Full Name should not contain numbers.');
      return;
    }
  });
</script>

</body>
</html>