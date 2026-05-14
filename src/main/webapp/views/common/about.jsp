<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us – EduAid</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .about-hero {
            background: linear-gradient(135deg, #0d4d33, #1a6b4a);
            padding: 60px 24px;
            text-align: center;
            color: white;
            border-radius: 16px;
            margin-bottom: 2rem;
        }
        .about-hero h1 { font-size: 2.5rem; margin-bottom: 1rem; }
        .about-hero h1 span { color: #f4a226; }
        .about-hero p { font-size: 1.1rem; max-width: 600px; margin: 0 auto; }

        .hero-stats {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin-top: 2rem;
            flex-wrap: wrap;
        }
        .hero-stat {
            background: rgba(255,255,255,0.15);
            padding: 0.5rem 1.5rem;
            border-radius: 40px;
            font-size: 0.9rem;
        }

        .mission-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin: 3rem 0;
        }

        .value-card {
            background: #ffffff;
            padding: 1.5rem;
            border-radius: 12px;
            border-left: 4px solid #f4a226;
            transition: all 0.3s ease;
            margin-bottom: 1rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .value-card:hover {
            transform: translateX(8px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
        }
        .value-icon { font-size: 2rem; margin-bottom: 0.5rem; display: block; color: #1a6b4a; }

        .team-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 1.5rem;
            margin: 2rem 0;
        }
        .team-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }
        .team-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 28px rgba(0,0,0,0.15);
        }
        .team-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin: 0 auto 1rem;
            overflow: hidden;
        }
        .team-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .team-role {
            display: inline-block;
            background: #e8f5ee;
            color: #1a6b4a;
            font-size: 0.7rem;
            font-weight: 700;
            padding: 0.2rem 0.8rem;
            border-radius: 20px;
            margin: 0.5rem 0;
        }
        .team-social {
            display: flex;
            justify-content: center;
            gap: 0.8rem;
            margin-top: 1rem;
        }
        .social-link {
            width: 32px;
            height: 32px;
            background: #e8f5ee;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #1a6b4a;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .social-link:hover {
            background: #1a6b4a;
            color: white;
        }

        .impact-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin: 2rem 0;
        }
        .impact-card {
            background: #ffffff;
            padding: 1.5rem;
            border-radius: 16px;
            text-align: center;
            border-top: 3px solid #f4a226;
            transition: all 0.3s ease;
        }
        .impact-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }
        .impact-icon { font-size: 2.5rem; color: #1a6b4a; margin-bottom: 1rem; display: block; }

        .cta-section {
            background: linear-gradient(135deg, #1a6b4a, #0d4d33);
            padding: 3rem;
            text-align: center;
            border-radius: 16px;
            margin: 2rem 0;
            color: white;
        }
        .cta-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 1.5rem;
            flex-wrap: wrap;
        }
        .btn-cta-primary {
            background: #f4a226;
            color: #1a1a1a;
            padding: 0.8rem 2rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 700;
            transition: all 0.3s ease;
        }
        .btn-cta-primary:hover {
            background: #e09520;
            transform: translateY(-2px);
            text-decoration: none;
            color: #1a1a1a;
        }
        .btn-cta-secondary {
            background: transparent;
            color: white;
            padding: 0.8rem 2rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 700;
            border: 2px solid white;
            transition: all 0.3s ease;
        }
        .btn-cta-secondary:hover {
            background: rgba(255,255,255,0.1);
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }

        @media (max-width: 1024px) { .team-grid { grid-template-columns: repeat(3, 1fr); } }
        @media (max-width: 768px) {
            .mission-grid { grid-template-columns: 1fr; }
            .impact-grid { grid-template-columns: 1fr; }
            .team-grid { grid-template-columns: repeat(2, 1fr); }
            .about-hero h1 { font-size: 1.8rem; }
        }
        @media (max-width: 480px) { .team-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<main>
    <div class="container">

        <!-- Hero Section -->
        <div class="about-hero">
            <h1>Empowering Education<br>Through <span>Sharing</span></h1>
            <p>EduAid connects donors who have digital educational materials with students and teachers who need them most — completely free, safe, and community-driven.</p>
            <a href="${pageContext.request.contextPath}/auth?action=register" class="btn btn-primary" style="background: #f4a226; color: #1a1a1a; display: inline-flex; align-items: center; gap: 8px;">
                <i class="fas fa-user-plus"></i> Join EduAid Today →
            </a>
            <div class="hero-stats">
                <span class="hero-stat"><i class="fas fa-book"></i> 5+ Categories</span>
                <span class="hero-stat"><i class="fas fa-users"></i> 3 User Roles</span>
                <span class="hero-stat"><i class="fas fa-download"></i> Instant Access</span>
            </div>
        </div>

        <!-- Mission Section -->
        <h2 style="text-align: center; margin: 2rem 0;"><i class="fas fa-bullseye" style="color: #f4a226; margin-right: 10px;"></i> Our Mission</h2>
        <div class="mission-grid">
            <div>
                <p style="line-height: 1.8; color: #555;">
                    <i class="fas fa-exclamation-triangle" style="color: #f4a226; margin-right: 8px;"></i>
                    <strong>Educational inequality</strong> is one of the most pressing challenges facing communities today.
                    Millions of students are held back not by a lack of ability, but simply by a lack of access to basic
                    learning materials.
                </p>
                <p style="line-height: 1.8; color: #555; margin-top: 1rem;">
                    <i class="fas fa-hand-holding-heart" style="color: #1a6b4a; margin-right: 8px;"></i>
                    <strong>EduAid</strong> was created to tackle this problem directly. By building a trusted, community-driven
                    platform, we connect donors with students and teachers who need resources most.
                </p>
            </div>
            <div>
                <div class="value-card">
                    <span class="value-icon"><i class="fas fa-scale-balanced"></i></span>
                    <strong>Equity</strong>
                    <p>Every student deserves equal access to learning materials regardless of their financial situation.</p>
                </div>
                <div class="value-card">
                    <span class="value-icon"><i class="fas fa-users"></i></span>
                    <strong>Community</strong>
                    <p>We believe in the power of people helping people within a trusted network.</p>
                </div>
                <div class="value-card">
                    <span class="value-icon"><i class="fas fa-leaf"></i></span>
                    <strong>Sustainability</strong>
                    <p>Reusing and sharing digital resources reduces waste and benefits the environment.</p>
                </div>
                <div class="value-card">
                    <span class="value-icon"><i class="fas fa-search"></i></span>
                    <strong>Transparency</strong>
                    <p>Every action is reviewed and managed to ensure trust and accountability.</p>
                </div>
            </div>
        </div>

        <!-- Team Section -->
        <h2 style="text-align: center; margin: 3rem 0 1rem;"><i class="fas fa-users" style="color: #f4a226; margin-right: 10px;"></i> Meet Our Team</h2>
        <p style="text-align: center; color: #666; margin-bottom: 2rem;">The dedicated team behind EduAid</p>

        <div class="team-grid">
            <!-- Shourav Gurung -->
            <div class="team-card">
                <div class="team-avatar">
                    <img src="${pageContext.request.contextPath}/images/team/shourav.jpeg" alt="Shourav Gurung">
                </div>
                <h3>Shourav Gurung</h3>
                <div class="team-role"><i class="fas fa-trophy"></i> Project Leader & Backend</div>
                <p>Overall architecture, authentication, session management, MVC structure</p>
                <div class="team-social">
                    <a href="https://www.instagram.com/shouravgurung/" target="_blank" class="social-link"><i class="fab fa-instagram"></i></a>
                    <a href="https://github.com/shourav102" target="_blank" class="social-link"><i class="fab fa-github"></i></a>
                    <a href="mailto:shourav@eduaid.com" class="social-link"><i class="fas fa-envelope"></i></a>
                </div>
            </div>

            <!-- Samir Tamang -->
            <div class="team-card">
                <div class="team-avatar">
                    <img src="${pageContext.request.contextPath}/images/team/samirtamang.jpeg" alt="Samir Tamang">
                </div>
                <h3>Samir Tamang</h3>
                <div class="team-role"><i class="fas fa-database"></i> Database Engineer</div>
                <p>Normalized schema, ER diagrams, MySQL, data integrity</p>
                <div class="team-social">
                    <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
                    <a href="https://github.com/samirtamang" target="_blank" class="social-link"><i class="fab fa-github"></i></a>
                    <a href="mailto:samir.tamang@eduaid.com" class="social-link"><i class="fas fa-envelope"></i></a>
                </div>
            </div>

            <!-- Samir Bhujel -->
            <div class="team-card">
                <div class="team-avatar">
                    <img src="${pageContext.request.contextPath}/images/team/samirbhujel.jpg" alt="Samir Bhujel">
                </div>
                <h3>Samir Bhujel</h3>
                <div class="team-role"><i class="fas fa-palette"></i> UI/UX Designer</div>
                <p>Wireframes, prototypes, color schemes, visual design</p>
                <div class="team-social">
                    <a href="https://www.instagram.com/samirbhujel5/" target="_blank" class="social-link"><i class="fab fa-instagram"></i></a>
                    <a href="https://github.com/samirbhujel" target="_blank" class="social-link"><i class="fab fa-github"></i></a>
                    <a href="mailto:samir.bhujel@eduaid.com" class="social-link"><i class="fas fa-envelope"></i></a>
                </div>
            </div>

            <!-- Niraj Shrestha -->
            <div class="team-card">
                <div class="team-avatar">
                    <img src="${pageContext.request.contextPath}/images/team/niraj.jpg" alt="Niraj Shrestha">
                </div>
                <h3>Niraj Shrestha</h3>
                <div class="team-role"><i class="fas fa-laptop-code"></i> Frontend Developer</div>
                <p>JSP pages, responsive design, navbar, footer components</p>
                <div class="team-social">
                    <a href="https://www.instagram.com/sthaniraj217/" target="_blank" class="social-link"><i class="fab fa-instagram"></i></a>
                    <a href="https://github.com/niraj" target="_blank" class="social-link"><i class="fab fa-github"></i></a>
                    <a href="mailto:niraj@eduaid.com" class="social-link"><i class="fas fa-envelope"></i></a>
                </div>
            </div>

            <!-- Shreyaz Bijukchhe -->
            <div class="team-card">
                <div class="team-avatar">
                    <img src="${pageContext.request.contextPath}/images/team/shreyaz.jpg" alt="Shreyaz Bijukchhe">
                </div>
                <h3>Shreyaz Bijukchhe</h3>
                <div class="team-role"><i class="fas fa-vial"></i> QA & Backend Support</div>
                <p>Testing, test cases, quality assurance, backend assistance</p>
                <div class="team-social">
                    <a href="https://www.instagram.com/sshrey4z/" target="_blank" class="social-link"><i class="fab fa-instagram"></i></a>
                    <a href="https://github.com/shreyaz" target="_blank" class="social-link"><i class="fab fa-github"></i></a>
                    <a href="mailto:shreyaz@eduaid.com" class="social-link"><i class="fas fa-envelope"></i></a>
                </div>
            </div>
        </div>

        <!-- Impact Section -->
        <h2 style="text-align: center; margin: 3rem 0 1rem;"><i class="fas fa-chart-line" style="color: #f4a226; margin-right: 10px;"></i> Our Vision</h2>
        <div class="impact-grid">
            <div class="impact-card">
                <span class="impact-icon"><i class="fas fa-bullseye"></i></span>
                <h3>10,000 Students</h3>
                <p>Onboard 10,000 verified students and teachers into the EduAid community.</p>
            </div>
            <div class="impact-card">
                <span class="impact-icon"><i class="fas fa-expand-alt"></i></span>
                <h3>Expand Categories</h3>
                <p>Add more digital resource categories to serve diverse educational needs.</p>
            </div>
            <div class="impact-card">
                <span class="impact-icon"><i class="fas fa-mobile-alt"></i></span>
                <h3>Mobile App</h3>
                <p>Launch dedicated Android and iOS apps for easier access anywhere.</p>
            </div>
        </div>

        <!-- CTA Section -->
        <div class="cta-section">
            <h2><i class="fas fa-rocket"></i> Ready to Make a Difference?</h2>
            <p>Join EduAid today and help build a world where every student has the tools they need to succeed.</p>
            <div class="cta-buttons">
                <a href="${pageContext.request.contextPath}/auth?action=register" class="btn-cta-primary">
                    <i class="fas fa-user-plus"></i> Get Started Free →
                </a>
                <a href="${pageContext.request.contextPath}/contact" class="btn-cta-secondary">
                    <i class="fas fa-envelope"></i> Contact Us
                </a>
            </div>
        </div>

    </div>
</main>

<jsp:include page="footer.jsp" />

</body>
</html>