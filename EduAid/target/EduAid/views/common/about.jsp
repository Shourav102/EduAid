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
    /* Hero Section */
    .about-hero {
      background: linear-gradient(135deg, #0d4d33, #1a6b4a);
      padding: 80px 24px;
      text-align: center;
      color: white;
      border-radius: 16px;
      margin-bottom: 2rem;
      position: relative;
      overflow: hidden;
    }
    .about-hero::before {
      content: "\f02d";
      font-family: "Font Awesome 6 Free";
      font-weight: 900;
      position: absolute;
      font-size: 200px;
      opacity: 0.05;
      bottom: -30px;
      right: -30px;
    }
    .about-hero h1 { font-size: 2.8rem; margin-bottom: 1rem; }
    .about-hero h1 span { color: #f4a226; }
    .about-hero p { font-size: 1.1rem; opacity: 0.9; max-width: 600px; margin: 0 auto 2rem; }

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
    .hero-stat i { margin-right: 8px; }

    /* Mission Grid */
    .mission-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 2rem;
      margin: 3rem 0;
    }

    /* Value Cards with Hover Effects */
    .value-card {
      background: #ffffff;
      padding: 1.5rem;
      border-radius: 12px;
      border-left: 4px solid #f4a226;
      transition: all 0.3s cubic-bezier(0.2, 0.9, 0.4, 1.1);
      margin-bottom: 1rem;
      cursor: pointer;
      box-shadow: var(--shadow-sm);
    }
    .value-card:hover {
      transform: translateX(8px);
      box-shadow: var(--shadow-md);
      border-left-width: 6px;
    }
    .value-icon {
      font-size: 2rem;
      margin-bottom: 0.5rem;
      display: block;
      color: var(--primary);
    }
    .value-card:hover .value-icon {
      transform: scale(1.05);
    }

    /* Team Grid */
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
      box-shadow: var(--shadow-sm);
      transition: all 0.3s cubic-bezier(0.2, 0.9, 0.4, 1.1);
      cursor: pointer;
    }
    .team-card:hover {
      transform: translateY(-8px) scale(1.02);
      box-shadow: 0 20px 35px -10px rgba(26, 107, 74, 0.25);
    }
    .team-avatar {
      width: 100px;
      height: 100px;
      border-radius: 50%;
      margin: 0 auto 1rem;
      background: linear-gradient(135deg, #1a6b4a, #0d4d33);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 2.5rem;
      color: white;
      transition: all 0.3s ease;
    }
    .team-card:hover .team-avatar {
      transform: scale(1.05);
      box-shadow: 0 8px 20px rgba(26, 107, 74, 0.3);
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
      transform: translateY(-2px);
    }

    /* Impact Section */
    .impact-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 1.5rem;
      margin: 2rem 0;
    }
    .impact-card {
      background: #ffffff;
      padding: 1.8rem;
      border-radius: 16px;
      text-align: center;
      border-top: 3px solid #f4a226;
      transition: all 0.3s ease;
      cursor: pointer;
    }
    .impact-card:hover {
      transform: translateY(-5px);
      box-shadow: var(--shadow-md);
    }
    .impact-icon {
      font-size: 2.5rem;
      color: var(--primary);
      margin-bottom: 1rem;
      display: block;
    }
    .impact-card h3 { margin: 0.5rem 0; }

    /* CTA Section */
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
      display: inline-flex;
      align-items: center;
      gap: 8px;
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
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }
    .btn-cta-secondary:hover {
      background: rgba(255,255,255,0.1);
      transform: translateY(-2px);
      text-decoration: none;
      color: white;
    }

    /* Responsive */
    @media (max-width: 1024px) {
      .team-grid { grid-template-columns: repeat(3, 1fr); }
    }
    @media (max-width: 768px) {
      .mission-grid { grid-template-columns: 1fr; }
      .impact-grid { grid-template-columns: 1fr; }
      .team-grid { grid-template-columns: repeat(2, 1fr); }
      .about-hero h1 { font-size: 1.8rem; }
      .hero-stats { gap: 1rem; }
      .hero-stat { font-size: 0.8rem; padding: 0.3rem 1rem; }
    }
    @media (max-width: 480px) {
      .team-grid { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<main>
  <div class="container">

    <!-- Hero Section -->
    <div class="about-hero fade-in">
      <h1>Empowering Education<br>Through <span>Sharing</span></h1>
      <p>EduAid connects donors who have spare educational materials with students and teachers who need them most — completely free, safe, and community-driven.</p>
      <a href="${pageContext.request.contextPath}/auth?action=register" class="btn btn-primary" style="background: #f4a226; color: #1a1a1a; display: inline-flex; align-items: center; gap: 8px;">
        <i class="fas fa-user-plus"></i> Join EduAid Today →
      </a>
      <div class="hero-stats">
        <span class="hero-stat"><i class="fas fa-book"></i> 5+ Categories</span>
        <span class="hero-stat"><i class="fas fa-users"></i> 3 User Roles</span>
        <span class="hero-stat"><i class="fas fa-gem"></i> 100% Free</span>
      </div>
    </div>

    <!-- Our Story / Mission Section -->
    <h2 style="text-align: center; margin: 2rem 0;"><i class="fas fa-bullseye" style="color: var(--accent); margin-right: 10px;"></i> Our Mission</h2>
    <div class="mission-grid">
      <div>
        <p style="line-height: 1.8; color: #555; font-size: 1rem;">
          <i class="fas fa-exclamation-triangle" style="color: var(--accent); margin-right: 8px;"></i>
          <strong>Educational inequality</strong> is one of the most pressing challenges facing communities today.
          Millions of students are held back not by a lack of ability, but simply by a lack of access to basic
          learning materials — E-Books, Software & Apps, Digital Lab Tools, Educational Videos, and Templates & Guides.
        </p>
        <p style="line-height: 1.8; color: #555; margin-top: 1rem;">
          <i class="fas fa-hand-holding-heart" style="color: var(--primary); margin-right: 8px;"></i>
          <strong>EduAid</strong> was created to tackle this problem directly. By building a trusted, community-driven
          platform, we connect those who have spare educational resources with students and teachers who need them most.
        </p>
      </div>
      <div>
        <div class="value-card">
          <span class="value-icon"><i class="fas fa-scale-balanced"></i></span>
          <strong>Equity</strong>
          <p style="margin-top: 0.5rem;">Every student deserves equal access to learning materials regardless of their financial situation.</p>
        </div>
        <div class="value-card">
          <span class="value-icon"><i class="fas fa-users"></i></span>
          <strong>Community</strong>
          <p style="margin-top: 0.5rem;">We believe in the power of people helping people within a trusted network.</p>
        </div>
        <div class="value-card">
          <span class="value-icon"><i class="fas fa-leaf"></i></span>
          <strong>Sustainability</strong>
          <p style="margin-top: 0.5rem;">Reusing and sharing resources reduces waste and benefits the environment.</p>
        </div>
        <div class="value-card">
          <span class="value-icon"><i class="fas fa-search"></i></span>
          <strong>Transparency</strong>
          <p style="margin-top: 0.5rem;">Every action is reviewed and managed to ensure trust and accountability.</p>
        </div>
      </div>
    </div>

    <!-- Meet Our Team Section -->
    <h2 style="text-align: center; margin: 3rem 0 1rem;">Meet Our Team</h2>
    <p style="text-align: center; color: #666; margin-bottom: 2rem;">The dedicated team behind EduAid</p>

    <div class="team-grid">
      <!-- Member 1: Shourav Gurung -->
      <div class="team-card">
        <div class="team-avatar">
          <img src="${pageContext.request.contextPath}/images/team/shourav.jpeg"
               alt="Shourav Gurung"
               style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
        </div>
        <h3>Shourav Gurung</h3>
        <div class="team-role"><i class="fas fa-trophy"></i> Project Leader & Backend</div>
        <p>Overall architecture, authentication, session management, MVC structure</p>
        <div class="team-social">
          <a href="https://www.instagram.com/shouravgurung/" target="_blank" class="social-link"><i class="fab fa-instagram"></i></a>
          <a href="https://github.com/shourav102" target="_blank" class="social-link"><i class="fab fa-github"></i></a>
          <a href="mailto:shouravvolts@gmail.com" class="social-link"><i class="fas fa-envelope"></i></a>
        </div>
      </div>

      <!-- Member 2: Samir Tamang -->
      <div class="team-card">
        <div class="team-avatar">
          <img src="${pageContext.request.contextPath}/images/team/samirtamang.jpeg"
               alt="Samir Tamang"
               style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
        </div>
        <h3>Samir Tamang</h3>
        <div class="team-role"><i class="fas fa-database"></i> Database Engineer</div>
        <p>Normalized schema, ER diagrams, MySQL, data integrity</p>
        <div class="team-social">
          <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
          <a href="https://github.com/samirtamang" target="_blank" class="social-link"><i class="fab fa-github"></i></a>
          <a href="mailto:samirsthatamang67@gmail.com" class="social-link"><i class="fas fa-envelope"></i></a>
        </div>
      </div>

      <!-- Member 3: Samir Bhujel -->
      <div class="team-card">
        <div class="team-avatar">
          <img src="${pageContext.request.contextPath}/images/team/samirbhujel.jpg"
               alt="Samir Bhujel"
               style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
        </div>
        <h3>Samir Bhujel</h3>
        <div class="team-role"><i class="fas fa-palette"></i> UI/UX Designer</div>
        <p>Wireframes, prototypes, color schemes, visual design</p>
        <div class="team-social">
          <a href="https://www.instagram.com/samirbhujel5/" target="_blank" class="social-link"><i class="fab fa-instagram"></i></a>
          <a href="https://github.com/samirbhujel" target="_blank" class="social-link"><i class="fab fa-github"></i></a>
          <a href="mailto:samirbhujel806@gmail.com" class="social-link"><i class="fas fa-envelope"></i></a>
        </div>
      </div>

      <!-- Member 4: Niraj Shrestha -->
      <div class="team-card">
        <div class="team-avatar">
          <img src="${pageContext.request.contextPath}/images/team/niraj.jpg"
               alt="Niraj Shrestha"
               style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
        </div>
        <h3>Niraj Shrestha</h3>
        <div class="team-role"><i class="fas fa-laptop-code"></i> Frontend Developer</div>
        <p>JSP pages, responsive design, navbar, footer components</p>
        <div class="team-social">
          <a href="https://www.instagram.com/sthaniraj217/" target="_blank" class="social-link"><i class="fab fa-instagram"></i></a>
          <a href="https://github.com/niraj" target="_blank" class="social-link"><i class="fab fa-github"></i></a>
          <a href="mailto:sthaniraj555@gmail.com" class="social-link"><i class="fas fa-envelope"></i></a>
        </div>
      </div>

      <!-- Member 5: Shreyaz Bijukchhe -->
      <div class="team-card">
        <div class="team-avatar">
          <img src="${pageContext.request.contextPath}/images/team/shreyaz.jpg"
               alt="Shreyaz Bijukchhe"
               style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
        </div>
        <h3>Shreyaz Bijukchhe</h3>
        <div class="team-role"><i class="fas fa-vial"></i> QA & Backend Support</div>
        <p>Testing, test cases, quality assurance, backend assistance</p>
        <div class="team-social">
          <a href="https://www.instagram.com/sshrey4z/" target="_blank" class="social-link"><i class="fab fa-instagram"></i></a>
          <a href="https://github.com/shreyaz" target="_blank" class="social-link"><i class="fab fa-github"></i></a>
          <a href="mailto:bijukchheshreyaz@gmail.com" class="social-link"><i class="fas fa-envelope"></i></a>
        </div>
      </div>
    </div>

    <!-- Call to Action Section -->
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

<script>
  // Intersection observer for fade-in animations
  const fadeElements = document.querySelectorAll('.fade-in');

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0)';
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1 });

  fadeElements.forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(30px)';
    el.style.transition = 'all 0.6s ease-out';
    observer.observe(el);
  });
</script>

</body>
</html>