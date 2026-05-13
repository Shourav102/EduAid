<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduAid — Empowering Education Through Sharing</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .hero-buttons { display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap; margin-top: 2rem; }
        .btn-hero-primary { background: var(--accent); color: #1a1a1a; padding: 0.8rem 2rem; border-radius: 8px; font-weight: 700; transition: all var(--transition); display: inline-block; }
        .btn-hero-primary:hover { background: var(--accent-dark); transform: translateY(-2px); text-decoration: none; color: #1a1a1a; }
        .btn-hero-outline { background: transparent; color: #fff; padding: 0.8rem 2rem; border-radius: 8px; border: 2px solid rgba(255,255,255,0.4); transition: all var(--transition); display: inline-block; }
        .btn-hero-outline:hover { border-color: #fff; background: rgba(255,255,255,0.08); text-decoration: none; color: #fff; }

        .steps-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; margin: 2rem 0; }
        .categories-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 1.5rem; margin: 2rem 0; }
        .roles-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; margin: 2rem 0; }

        /* Step Card Icon Styling */
        .step-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, var(--primary-light), #ffffff);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.2rem;
            font-size: 2rem;
            color: var(--primary);
            transition: all 0.3s ease;
        }

        .step-card:hover .step-icon {
            background: var(--primary);
            color: white;
            transform: scale(1.05);
        }

        /* Category Card Icon Styling */
        .cat-icon {
            width: 55px;
            height: 55px;
            background: var(--primary-light);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.6rem;
            color: var(--primary);
            transition: all 0.3s ease;
        }

        .cat-card:hover .cat-icon {
            background: var(--primary);
            color: white;
            transform: translateY(-3px);
        }

        /* Updated Stats Counter Section */
        .stats-counter-section {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            padding: 3rem 2rem;
            border-radius: var(--radius-lg);
            margin: 3rem 0;
            text-align: center;
            color: white;
        }
        .stat-number {
            font-size: 2.8rem;
            font-weight: 800;
            color: var(--accent);
            line-height: 1;
            margin-bottom: 0.5rem;
        }
        .stat-label-small {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        /* Testimonial Section */
        .testimonial-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin: 2rem 0;
        }
        .testimonial-card {
            background: #ffffff;
            padding: 2rem;
            border-radius: var(--radius-lg);
            text-align: center;
            box-shadow: var(--shadow-sm);
            transition: all var(--transition);
        }
        .testimonial-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }
        .testimonial-quote {
            font-size: 3rem;
            color: var(--accent);
            line-height: 1;
            margin-bottom: 0.5rem;
        }
        .testimonial-text {
            font-size: 0.95rem;
            color: var(--text-mid);
            line-height: 1.7;
            margin: 1rem 0;
        }

        @media (max-width: 1024px) { .categories-grid { grid-template-columns: repeat(3, 1fr); } }
        @media (max-width: 768px) {
            .steps-grid, .roles-grid { grid-template-columns: 1fr; }
            .categories-grid { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</head>
<body>

<%@ include file="/views/common/navbar.jsp" %>

<main>
    <div class="container">

        <%-- Hero Section --%>
        <div class="hero">
            <h1>Share Digital Resources.<br>Change <span>Lives</span>.</h1>
            <p>EduAid connects donors who have digital educational materials with students and teachers who need them most — completely free, instant download, and community-driven.</p>
            <div class="hero-buttons">
                <a href="${pageContext.request.contextPath}/auth?action=register" class="btn-hero-primary"><i class="fas fa-user-plus" style="margin-right: 8px;"></i> Get Started Free →</a>
                <a href="${pageContext.request.contextPath}/about" class="btn-hero-outline"><i class="fas fa-info-circle" style="margin-right: 8px;"></i> Learn More</a>
            </div>
        </div>

        <%-- Stats Counter Section --%>
        <div class="stats-counter-section fade-in">
            <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 2rem; max-width: 800px; margin: 0 auto;">
                <div>
                    <div class="stat-number">500+</div>
                    <div class="stat-label-small"><i class="fas fa-file-pdf" style="margin-right: 5px;"></i> Digital Resources</div>
                </div>
                <div>
                    <div class="stat-number">150+</div>
                    <div class="stat-label-small"><i class="fas fa-users" style="margin-right: 5px;"></i> Active Users</div>
                </div>
                <div>
                    <div class="stat-number">5</div>
                    <div class="stat-label-small"><i class="fas fa-tags" style="margin-right: 5px;"></i> Categories</div>
                </div>
                <div>
                    <div class="stat-number">100%</div>
                    <div class="stat-label-small"><i class="fas fa-download" style="margin-right: 5px;"></i> Instant Access</div>
                </div>
            </div>
        </div>

        <%-- How It Works Section --%>
        <div class="section-alt" style="padding: 3rem; border-radius: var(--radius-lg); margin: 2rem 0;">
            <h2 style="text-align: center; margin-bottom: 2rem;"><i class="fas fa-question-circle" style="color: var(--accent); margin-right: 10px;"></i> How EduAid Works</h2>
            <div class="steps-grid">
                <div class="step-card fade-in-delay-1">
                    <div class="step-icon">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <h3>1. Register</h3>
                    <p>Sign up as a Donor or Recipient. Our admin team reviews every registration to keep the community safe.</p>
                </div>
                <div class="step-card fade-in-delay-2">
                    <div class="step-icon">
                        <i class="fas fa-clipboard-list"></i>
                    </div>
                    <h3>2. Get Approved</h3>
                    <p>Once approved by admin, you can start donating or accessing digital resources immediately.</p>
                </div>
                <div class="step-card fade-in-delay-3">
                    <div class="step-icon">
                        <i class="fas fa-hand-holding-heart"></i>
                    </div>
                    <h3>3. Share or Download</h3>
                    <p>Donors upload digital resources. Recipients browse and download instantly. Simple, transparent, free.</p>
                </div>
            </div>
        </div>

        <%-- Categories Section (UPDATED for Digital Resources) --%>
        <h2 style="text-align: center; margin: 3rem 0 1rem;"><i class="fas fa-th-large" style="color: var(--accent); margin-right: 10px;"></i> Digital Resource Categories</h2>
        <div class="categories-grid">
            <div class="cat-card fade-in-delay-1">
                <div class="cat-icon">
                    <i class="fas fa-book"></i>
                </div>
                <h3>E-Books & PDFs</h3>
                <p>Digital textbooks, reference books, study guides</p>
            </div>
            <div class="cat-card fade-in-delay-1">
                <div class="cat-icon">
                    <i class="fas fa-file-alt"></i>
                </div>
                <h3>Templates & Guides</h3>
                <p>Worksheets, lesson plans, resume templates</p>
            </div>
            <div class="cat-card fade-in-delay-2">
                <div class="cat-icon">
                    <i class="fas fa-laptop-code"></i>
                </div>
                <h3>Educational Software</h3>
                <p>Learning apps, coding tools, digital resources</p>
            </div>
            <div class="cat-card fade-in-delay-2">
                <div class="cat-icon">
                    <i class="fas fa-video"></i>
                </div>
                <h3>Video Lectures</h3>
                <p>Recorded lessons, tutorials, educational videos</p>
            </div>
            <div class="cat-card fade-in-delay-3">
                <div class="cat-icon">
                    <i class="fas fa-chalkboard"></i>
                </div>
                <h3>Presentations</h3>
                <p>PowerPoint slides, teaching materials, notes</p>
            </div>
        </div>

        <%-- Testimonial Section --%>
        <div style="margin: 4rem 0;">
            <h2 style="text-align: center; margin-bottom: 2rem;"><i class="fas fa-star" style="color: var(--accent); margin-right: 10px;"></i> What Our Community Says</h2>
            <div class="testimonial-grid">
                <div class="testimonial-card">
                    <div class="testimonial-quote"><i class="fas fa-quote-left"></i></div>
                    <p class="testimonial-text">EduAid helped me get digital textbooks I couldn't afford. Now I'm on the dean's list!</p>
                    <strong>- Samita R., Student</strong>
                    <div style="margin-top: 8px; color: var(--accent);">
                        <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                    </div>
                </div>
                <div class="testimonial-card">
                    <div class="testimonial-quote"><i class="fas fa-quote-left"></i></div>
                    <p class="testimonial-text">Sharing my digital teaching resources through EduAid is so easy. Happy to help others learn.</p>
                    <strong>- Rajesh P., Donor</strong>
                    <div style="margin-top: 8px; color: var(--accent);">
                        <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                    </div>
                </div>
                <div class="testimonial-card">
                    <div class="testimonial-quote"><i class="fas fa-quote-left"></i></div>
                    <p class="testimonial-text">The platform is clean, fast, and trustworthy. Instant downloads make learning accessible!</p>
                    <strong>- Priya S., Teacher</strong>
                    <div style="margin-top: 8px; color: var(--accent);">
                        <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                    </div>
                </div>
            </div>
        </div>

    </div>
</main>

<%@ include file="/views/common/footer.jsp" %>

<script>
    // Simple intersection observer for fade-in animations
    const fadeElements = document.querySelectorAll('.fade-in, .fade-in-delay-1, .fade-in-delay-2, .fade-in-delay-3');

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
        observer.observe(el);
    });
</script>

</body>
</html>