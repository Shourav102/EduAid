<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<footer class="site-footer">

    <div class="footer-container">

        <div class="footer-brand">
            <div class="footer-logo">Edu<span class="footer-accent">Aid</span></div>
            <p class="footer-tagline">Reducing educational inequality, one resource at a time.</p>
        </div>

        <div class="footer-links">
            <h4 class="footer-heading">Quick Links</h4>
            <ul class="footer-nav">
                <li><a href="${pageContext.request.contextPath}/home" class="footer-link">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/about" class="footer-link">About Us</a></li>
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
        <p class="footer-copyright">&copy; 2026 EduAid. All rights reserved.</p>
    </div>

</footer>