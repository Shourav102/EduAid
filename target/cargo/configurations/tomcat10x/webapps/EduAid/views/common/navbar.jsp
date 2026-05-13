<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar">
    <div class="navbar-container">

        <%-- ===== LOGO / BRAND ===== --%>
        <a href="${pageContext.request.contextPath}/home" class="navbar-brand">
            <span class="brand-icon">📚</span>
            <span class="brand-text">Edu<span class="brand-accent">Aid</span></span>
        </a>

        <%-- ===== HAMBURGER BUTTON (mobile only) ===== --%>
        <button class="hamburger" id="hamburgerBtn" aria-label="Toggle navigation menu" onclick="toggleMenu()">
            <span class="hamburger-line"></span>
            <span class="hamburger-line"></span>
            <span class="hamburger-line"></span>
        </button>

        <%-- ===== NAV LINKS ===== --%>
        <ul class="nav-links" id="navLinks">
            <li>
                <a href="${pageContext.request.contextPath}/home" class="nav-link">Home</a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/about" class="nav-link">About Us</a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/contact" class="nav-link">Contact</a>
            </li>

            <%-- Show Login/Register if user is NOT logged in --%>
            <c:if test="${empty sessionScope.loggedInUser}">
                <li>
                    <a href="${pageContext.request.contextPath}/auth?action=login" class="nav-link nav-login">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/auth?action=register" class="nav-link nav-register">
                        <i class="fas fa-user-plus"></i> Register
                    </a>
                </li>
            </c:if>

            <%-- Show DASHBOARD link ONLY if user is logged in --%>
            <c:if test="${not empty sessionScope.loggedInUser}">
                <li>
                    <c:choose>
                        <c:when test="${sessionScope.userRole == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-link">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </c:otherwise>
                    </c:choose>
                </li>
            </c:if>

            <%-- Show Logout ONLY if user is logged in --%>
            <c:if test="${not empty sessionScope.loggedInUser}">
                <li>
                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="nav-link nav-logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </li>
            </c:if>
        </ul>

    </div>
</nav>

<style>
    .navbar {
        background-color: #1a6b4a;
        width: 100%;
        position: sticky;
        top: 0;
        z-index: 1000;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
    }

    .navbar-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 24px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        height: 70px;
    }

    .navbar-brand {
        display: flex;
        align-items: center;
        gap: 10px;
        text-decoration: none;
        color: #ffffff;
        transition: transform 0.2s ease;
    }

    .navbar-brand:hover {
        transform: scale(1.02);
        text-decoration: none;
    }

    .brand-icon {
        font-size: 1.5rem;
        color: #f4a226;
    }

    .brand-text {
        font-size: 24px;
        font-weight: 700;
        letter-spacing: 0.5px;
        color: #ffffff;
        font-family: 'Segoe UI', sans-serif;
    }

    .brand-accent {
        color: #f4a226;
    }

    .nav-links {
        list-style: none;
        margin: 0;
        padding: 0;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .nav-link {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        color: #e8f5f0;
        text-decoration: none;
        font-size: 15px;
        font-weight: 500;
        font-family: 'Segoe UI', sans-serif;
        padding: 8px 16px;
        border-radius: 8px;
        transition: all 0.2s ease;
    }

    .nav-link:hover {
        background-color: rgba(255, 255, 255, 0.15);
        color: #ffffff;
        transform: translateY(-1px);
        text-decoration: none;
    }

    .nav-login {
        border: 1px solid rgba(255, 255, 255, 0.3);
    }

    .nav-register {
        background-color: #f4a226;
        color: #1a1a1a;
        font-weight: 600;
    }

    .nav-register:hover {
        background-color: #e09520;
        color: #1a1a1a;
        transform: translateY(-1px);
    }

    .nav-logout {
        background-color: #dc3545;
        color: white;
        font-weight: 600;
    }

    .nav-logout:hover {
        background-color: #c82333;
        color: white;
        transform: translateY(-1px);
    }

    .hamburger {
        display: none;
        flex-direction: column;
        justify-content: center;
        gap: 5px;
        background: none;
        border: none;
        cursor: pointer;
        padding: 6px;
        border-radius: 4px;
    }

    .hamburger:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }

    .hamburger-line {
        display: block;
        width: 24px;
        height: 2px;
        background-color: #ffffff;
        border-radius: 2px;
        transition: transform 0.3s ease, opacity 0.3s ease;
    }

    .hamburger.open .hamburger-line:nth-child(1) {
        transform: translateY(7px) rotate(45deg);
    }
    .hamburger.open .hamburger-line:nth-child(2) {
        opacity: 0;
    }
    .hamburger.open .hamburger-line:nth-child(3) {
        transform: translateY(-7px) rotate(-45deg);
    }

    @media (max-width: 768px) {
        .hamburger {
            display: flex;
        }

        .nav-links {
            display: none;
            flex-direction: column;
            align-items: flex-start;
            gap: 4px;
            position: absolute;
            top: 70px;
            left: 0;
            width: 100%;
            background-color: #155a3e;
            padding: 12px 24px 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .nav-links.open {
            display: flex;
        }
        .nav-links li {
            width: 100%;
        }

        .nav-link {
            display: flex;
            width: 100%;
            padding: 12px 16px;
            font-size: 16px;
        }

        .nav-login, .nav-register, .nav-logout {
            justify-content: center;
        }
    }
</style>

<script>
    function toggleMenu() {
        var navLinks = document.getElementById('navLinks');
        var hamburger = document.getElementById('hamburgerBtn');
        navLinks.classList.toggle('open');
        hamburger.classList.toggle('open');
    }

    document.addEventListener('click', function(event) {
        var navbar = document.querySelector('.navbar');
        var navLinks = document.getElementById('navLinks');
        var hamburger = document.getElementById('hamburgerBtn');
        if (navbar && !navbar.contains(event.target)) {
            if (navLinks) navLinks.classList.remove('open');
            if (hamburger) hamburger.classList.remove('open');
        }
    });
</script>