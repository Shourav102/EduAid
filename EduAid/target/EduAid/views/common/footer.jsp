<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<footer class="site-footer">

    <div class="footer-container">

        <div class="footer-brand">
            <span class="footer-logo">Edu<span class="footer-accent">Aid</span></span>
            <p class="footer-tagline">Reducing educational inequality, one resource at a time.</p>
        </div>

        <div class="footer-links">
            <h4 class="footer-heading">Quick Links</h4>
            <ul class="footer-nav">
                <li><a href="${pageContext.request.contextPath}/about" class="footer-link">About</a></li>
                <li><a href="${pageContext.request.contextPath}/contact" class="footer-link">Contact</a></li>
                <li><a href="${pageContext.request.contextPath}/auth?action=login" class="footer-link">Login</a></li>
                <li><a href="${pageContext.request.contextPath}/auth?action=register" class="footer-link">Register</a></li>
            </ul>
        </div>

        <div class="footer-about">
            <h4 class="footer-heading">Our Mission</h4>
            <p class="footer-description">
                EduAid connects donors and recipients to share educational resources —
                books, stationery, lab equipment, and more — so that every student
                has the tools they need to learn.
            </p>
        </div>

    </div>

    <div class="footer-bottom">
        <p class="footer-copyright">&copy; 2026 EduAid. Reducing educational inequality.</p>
    </div>

</footer>

<style>
    .site-footer {
        background-color: #155a3e;
        color: #c8e6d8;
        margin-top: auto;
        font-family: 'Segoe UI', sans-serif;
    }

    .footer-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 48px 24px 32px;
        display: flex;
        flex-wrap: wrap;
        gap: 40px;
        justify-content: space-between;
    }

    .footer-brand   { flex: 1 1 200px; }
    .footer-links   { flex: 1 1 150px; }
    .footer-about   { flex: 1 1 220px; max-width: 300px; }

    .footer-logo    { font-size: 26px; font-weight: 700; color: #ffffff; letter-spacing: 0.5px; }
    .footer-accent  { color: #f4a226; }

    .footer-tagline {
        margin-top: 10px;
        font-size: 14px;
        line-height: 1.6;
        color: #a8d5be;
        max-width: 220px;
    }

    .footer-heading {
        font-size: 14px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: #f4a226;
        margin-bottom: 14px;
    }

    .footer-nav {
        list-style: none;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .footer-link {
        color: #c8e6d8;
        text-decoration: none;
        font-size: 14px;
        transition: color 0.2s ease, padding-left 0.2s ease;
        display: inline-block;
    }

    .footer-link:hover { color: #f4a226; padding-left: 4px; }

    .footer-description { font-size: 14px; line-height: 1.7; color: #a8d5be; }

    .footer-bottom {
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        padding: 16px 24px;
        text-align: center;
    }

    .footer-copyright { font-size: 13px; color: #7fb99a; margin: 0; }

    @media (max-width: 600px) {
        .footer-container { flex-direction: column; gap: 28px; padding: 32px 20px 24px; }
        .footer-about     { max-width: 100%; }
        .footer-tagline   { max-width: 100%; }
        .footer-bottom    { padding: 14px 20px; }
    }
</style>