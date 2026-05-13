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
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background-color: #f5f9f7; color: #1a1a1a; display: flex; flex-direction: column; min-height: 100vh; }
        .contact-main { flex: 1; }

        /* HERO */
        .contact-hero { background: linear-gradient(135deg, #0d4d33, #1a6b4a); padding: 72px 24px 60px; text-align: center; color: #fff; }
        .contact-hero .hero-tag { display: inline-block; background: rgba(244,162,38,0.2); color: #f4a226; font-size: 12px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; padding: 6px 16px; border-radius: 30px; margin-bottom: 20px; }
        .contact-hero h1 { font-size: 46px; font-weight: 800; margin-bottom: 14px; color: #fff; }
        .contact-hero h1 span { color: #f4a226; }
        .contact-hero p  { font-size: 17px; color: #b8ddc8; max-width: 500px; margin: 0 auto; line-height: 1.7; }

        /* BODY GRID */
        .contact-body { max-width: 1100px; margin: 0 auto; padding: 64px 24px; display: grid; grid-template-columns: 380px 1fr; gap: 48px; align-items: start; }

        /* INFO CARDS */
        .contact-left { display: flex; flex-direction: column; gap: 20px; }
        .info-card { background: #fff; border-radius: 14px; padding: 24px 22px; box-shadow: 0 2px 10px rgba(0,0,0,0.06); border-left: 4px solid #1a6b4a; display: flex; align-items: flex-start; gap: 16px; }
        .info-card-icon { width: 44px; height: 44px; min-width: 44px; border-radius: 12px; background: #eef7f2; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; }
        .info-card-content h4 { font-size: 14px; font-weight: 700; color: #1a3d2b; margin-bottom: 4px; }
        .info-card-content p  { font-size: 14px; color: #555; line-height: 1.6; }
        .info-card-content a  { color: #1a6b4a; text-decoration: none; font-weight: 600; }
        .info-card-content a:hover { text-decoration: underline; }
        .social-row { display: flex; gap: 10px; margin-top: 4px; }
        .soc-icon { width: 36px; height: 36px; border-radius: 50%; background: #eef7f2; border: 1.5px solid #c5e0d0; display: flex; align-items: center; justify-content: center; font-size: 14px; color: #1a6b4a; text-decoration: none; transition: background 0.2s, color 0.2s; }
        .soc-icon:hover { background: #1a6b4a; color: #fff; text-decoration: none; }

        /* FORM CARD */
        .contact-form-card { background: #fff; border-radius: 16px; padding: 40px 36px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
        .form-title    { font-size: 22px; font-weight: 700; color: #1a3d2b; margin-bottom: 6px; }
        .form-subtitle { font-size: 14px; color: #666; margin-bottom: 28px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 13px; font-weight: 700; color: #1a3d2b; margin-bottom: 7px; text-transform: uppercase; letter-spacing: 0.5px; }
        .required { color: #e53e3e; margin-left: 2px; }
        .form-input { width: 100%; padding: 13px 15px; border: 1.5px solid #d1ddd5; border-radius: 9px; font-size: 15px; font-family: 'Segoe UI', sans-serif; background: #f9fdfb; color: #1a1a1a; transition: border-color 0.2s, box-shadow 0.2s; outline: none; }
        .form-input:focus { border-color: #1a6b4a; box-shadow: 0 0 0 3px rgba(26,107,74,0.12); background: #fff; }
        .form-input.error { border-color: #e53e3e; }
        textarea.form-input { resize: vertical; min-height: 140px; }
        .field-error-msg { font-size: 12px; color: #e53e3e; margin-top: 5px; display: flex; align-items: center; gap: 4px; }
        .btn-submit { width: 100%; padding: 15px; background: #1a6b4a; color: #fff; font-size: 16px; font-weight: 700; font-family: 'Segoe UI', sans-serif; border: none; border-radius: 9px; cursor: pointer; transition: background 0.2s, transform 0.1s; margin-top: 4px; }
        .btn-submit:hover  { background: #155a3e; transform: translateY(-1px); }
        .btn-submit:active { transform: translateY(0); }
        .alert-success { background: #eef7f2; border: 1px solid #1a6b4a; border-radius: 10px; padding: 16px 18px; color: #1a6b4a; font-size: 15px; font-weight: 500; margin-bottom: 24px; display: flex; align-items: flex-start; gap: 10px; }
        .alert-error   { background: #fdf0ef; border: 1px solid #e53e3e; border-radius: 10px; padding: 14px 18px; color: #c0392b; font-size: 14px; margin-bottom: 20px; }

        /* FAQ */
        .faq-section { background: #fff; padding: 72px 24px; }
        .faq-inner   { max-width: 800px; margin: 0 auto; text-align: center; }
        .faq-label    { font-size: 12px; font-weight: 700; letter-spacing: 2.5px; text-transform: uppercase; color: #f4a226; margin-bottom: 10px; }
        .faq-title    { font-size: 32px; font-weight: 800; color: #1a3d2b; margin-bottom: 12px; }
        .faq-subtitle { font-size: 15px; color: #666; margin-bottom: 40px; line-height: 1.7; }
        .faq-list     { display: flex; flex-direction: column; gap: 14px; text-align: left; }
        .faq-item     { background: #f5f9f7; border-radius: 12px; border: 1.5px solid #e0ede7; overflow: hidden; }
        .faq-question { width: 100%; background: none; border: none; padding: 20px 24px; font-size: 15px; font-weight: 700; color: #1a3d2b; text-align: left; cursor: pointer; display: flex; justify-content: space-between; align-items: center; gap: 16px; font-family: 'Segoe UI', sans-serif; transition: background 0.2s; }
        .faq-question:hover { background: #eef7f2; }
        .faq-chevron  { font-size: 12px; color: #1a6b4a; transition: transform 0.25s; min-width: 16px; }
        .faq-answer   { display: none; padding: 0 24px 20px; font-size: 14px; color: #555; line-height: 1.8; }
        .faq-item.open .faq-answer   { display: block; }
        .faq-item.open .faq-chevron  { transform: rotate(180deg); }
        .faq-item.open .faq-question { background: #eef7f2; }

        /* MAP */
        .map-section iframe { width: 100%; height: 380px; border: none; display: block; }

        /* RESPONSIVE */
        @media (max-width: 900px) { .contact-body { grid-template-columns: 1fr; gap: 32px; } .contact-left { order: 2; } .contact-form-card { order: 1; } }
        @media (max-width: 600px) { .contact-hero h1 { font-size: 30px; } .contact-hero { padding: 50px 20px 44px; } .contact-body { padding: 40px 16px; } .contact-form-card { padding: 28px 20px; } .form-row { grid-template-columns: 1fr; } .faq-section { padding: 48px 16px; } .faq-title { font-size: 24px; } }
    </style>
</head>
<body>

<%@ include file="/views/common/navbar.jsp" %>

<main class="contact-main">

    <section class="contact-hero">
        <p class="hero-tag">Get In Touch</p>
        <h1>We'd Love to <span>Hear From You!</span></h1>
        <p>Have a question, suggestion, or just want to say hello? Our team is here and happy to help.</p>
    </section>

    <div class="contact-body">

        <div class="contact-left">
            <div class="info-card">
                <div class="info-card-icon">📧</div>
                <div class="info-card-content">
                    <h4>Email Us</h4>
                    <p><a href="mailto:support@eduaid.com">support@eduaid.com</a></p>
                    <p style="margin-top:4px; font-size:13px; color:#888;">We respond within 1–2 working days</p>
                </div>
            </div>
            <div class="info-card">
                <div class="info-card-icon">📞</div>
                <div class="info-card-content">
                    <h4>Call Us</h4>
                    <p><a href="tel:+97714400000">+977 1 440 0000</a></p>
                    <p style="margin-top:4px; font-size:13px; color:#888;">Monday – Friday, 9 AM – 5 PM</p>
                </div>
            </div>
            <div class="info-card">
                <div class="info-card-icon">📍</div>
                <div class="info-card-content">
                    <h4>Visit Us</h4>
                    <p>Informatics College<br>Matepani, Pokhara<br>Nepal, 33700</p>
                </div>
            </div>
            <div class="info-card">
                <div class="info-card-icon">🌐</div>
                <div class="info-card-content">
                    <h4>Follow Us</h4>
                    <p style="margin-bottom:10px;">Stay connected on social media</p>
                    <div class="social-row">
                        <a href="#" class="soc-icon">f</a>
                        <a href="#" class="soc-icon">&#9737;</a>
                        <a href="#" class="soc-icon">in</a>
                        <a href="#" class="soc-icon">𝕏</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="contact-form-card">
            <h2 class="form-title">Send Us a Message</h2>
            <p class="form-subtitle">All fields marked with * are required</p>

            <c:if test="${not empty sessionScope.contactSuccess}">
                <div class="alert-success">✅ ${sessionScope.contactSuccess}</div>
                <% session.removeAttribute("contactSuccess"); %>
            </c:if>

            <c:if test="${not empty generalError}">
                <div class="alert-error">⚠ ${generalError}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/contact" method="post" id="contactForm" novalidate>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="fullName">Full Name <span class="required">*</span></label>
                        <input type="text" id="fullName" name="fullName"
                               class="form-input ${not empty nameError ? 'error' : ''}"
                               placeholder="e.g. John Doe"
                               value="${not empty fullName ? fullName : ''}" maxlength="150" required/>
                        <c:if test="${not empty nameError}"><div class="field-error-msg">⚠ ${nameError}</div></c:if>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="email">Email Address <span class="required">*</span></label>
                        <input type="email" id="email" name="email"
                               class="form-input ${not empty emailError ? 'error' : ''}"
                               placeholder="e.g. john@email.com"
                               value="${not empty email ? email : ''}" maxlength="150" required/>
                        <c:if test="${not empty emailError}"><div class="field-error-msg">⚠ ${emailError}</div></c:if>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="subject">Subject <span class="required">*</span></label>
                    <input type="text" id="subject" name="subject"
                           class="form-input ${not empty subjectError ? 'error' : ''}"
                           placeholder="What is your message about?"
                           value="${not empty subject ? subject : ''}" maxlength="200" required/>
                    <c:if test="${not empty subjectError}"><div class="field-error-msg">⚠ ${subjectError}</div></c:if>
                </div>

                <div class="form-group">
                    <label class="form-label" for="message">Message <span class="required">*</span></label>
                    <textarea id="message" name="message"
                              class="form-input ${not empty messageError ? 'error' : ''}"
                              placeholder="Write your message here..."
                              maxlength="2000" required>${not empty message ? message : ''}</textarea>
                    <c:if test="${not empty messageError}"><div class="field-error-msg">⚠ ${messageError}</div></c:if>
                </div>

                <button type="submit" class="btn-submit">&#9993; Send Message</button>

            </form>
        </div>
    </div>

    <section class="faq-section">
        <div class="faq-inner">
            <p class="faq-label">FAQ</p>
            <h2 class="faq-title">Frequently Asked Questions</h2>
            <p class="faq-subtitle">Quick answers to the most common questions about EduAid.</p>
            <div class="faq-list">
                <div class="faq-item">
                    <button class="faq-question" onclick="toggleFaq(this)">How long does account approval take? <span class="faq-chevron">&#9660;</span></button>
                    <div class="faq-answer">Account approvals are typically completed within 1 to 2 working days. Our admin team reviews every registration to ensure the safety of our community. You will be able to log in as soon as your account is approved.</div>
                </div>
                <div class="faq-item">
                    <button class="faq-question" onclick="toggleFaq(this)">Who can donate resources on EduAid? <span class="faq-chevron">&#9660;</span></button>
                    <div class="faq-answer">Anyone can register as a Donor — including students, teachers, parents, or organisations. Once your account is approved, you can start listing educational resources such as E-Books, Software & Apps, Digital Lab Tools, Educational Videos, and Templates & Guides.</div>
                </div>
                <div class="faq-item">
                    <button class="faq-question" onclick="toggleFaq(this)">Is EduAid free to use? <span class="faq-chevron">&#9660;</span></button>
                    <div class="faq-answer">Yes, EduAid is completely free for both donors and recipients. There are no charges, subscription fees, or hidden costs of any kind. Our mission is to reduce educational inequality, and charging users would contradict that goal.</div>
                </div>
                <div class="faq-item">
                    <button class="faq-question" onclick="toggleFaq(this)">How do I apply for a resource I need? <span class="faq-chevron">&#9660;</span></button>
                    <div class="faq-answer">Once your Recipient account is approved, browse all available resources using the search feature. When you find something you need, click "Apply" and submit your request. You can also save items to your wishlist to come back to later.</div>
                </div>
                <div class="faq-item">
                    <button class="faq-question" onclick="toggleFaq(this)">What types of resources can be donated? <span class="faq-chevron">&#9660;</span></button>
                    <div class="faq-answer">EduAid currently supports five categories: E-Books, Software & Apps, Digital Lab Tools, Educational Videos, and Templates & Guides. We plan to expand these categories in the future to cover more educational needs.</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Map Section - Updated to Informatics College, Matepani, Pokhara -->
    <section>
        <iframe
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3532.123456789!2d83.998!3d28.218!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3995945a4c5c5c5d%3A0x5f42b55e03b7f0c4!2sInformatics%20College!5e0!3m2!1sen!2snp!4v1700000000000!5m2!1sen!2snp"
                width="100%"
                height="380"
                style="border:0; display:block;"
                allowfullscreen=""
                loading="lazy"
                title="Informatics College, Matepani, Pokhara">
        </iframe>
    </section>

</main>

<%@ include file="/views/common/footer.jsp" %>

<script>
    function toggleFaq(btn) {
        var item = btn.parentElement;
        var isOpen = item.classList.contains('open');
        document.querySelectorAll('.faq-item').forEach(function(el) { el.classList.remove('open'); });
        if (!isOpen) item.classList.add('open');
    }

    document.getElementById('contactForm').addEventListener('submit', function(e) {
        var valid = true;
        var name    = document.getElementById('fullName').value.trim();
        var email   = document.getElementById('email').value.trim();
        var subject = document.getElementById('subject').value.trim();
        var message = document.getElementById('message').value.trim();

        if (!name)           { markError('fullName', 'Full name is required.'); valid = false; }
        else if (/\d/.test(name)) { markError('fullName', 'Full name must not contain numbers.'); valid = false; }
        else                 { clearError('fullName'); }

        if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) { markError('email', 'Please enter a valid email address.'); valid = false; }
        else { clearError('email'); }

        if (!subject) { markError('subject', 'Subject is required.'); valid = false; } else { clearError('subject'); }
        if (!message) { markError('message', 'Message is required.');  valid = false; } else { clearError('message'); }

        if (!valid) e.preventDefault();
    });

    function markError(id, msg) {
        var el = document.getElementById(id);
        el.classList.add('error');
        var existing = el.parentElement.querySelector('.client-error');
        if (!existing) { var div = document.createElement('div'); div.className = 'field-error-msg client-error'; div.textContent = '⚠ ' + msg; el.parentElement.appendChild(div); }
    }

    function clearError(id) {
        var el = document.getElementById(id);
        el.classList.remove('error');
        var existing = el.parentElement.querySelector('.client-error');
        if (existing) existing.remove();
    }
</script>

</body>
</html>