<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Home – EduAid</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .hero {
            background: linear-gradient(135deg, #0d4d33, #1a6b4a);
            padding: 80px 24px;
            text-align: center;
            color: white;
            border-radius: 16px;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }
        .hero::before {
            content: "\f02d";
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            position: absolute;
            font-size: 200px;
            opacity: 0.05;
            bottom: -30px;
            right: -30px;
        }
        .hero h1 { font-size: 2.5rem; margin-bottom: 1rem; }
        .hero h1 span { color: #f4a226; }
        .hero p { font-size: 1.1rem; opacity: 0.9; max-width: 600px; margin: 0 auto 1rem; }

        .btn-dashboard {
            background: #f4a226;
            color: #1a1a1a;
            padding: 12px 28px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1rem;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            text-decoration: none;
            margin-top: 1rem;
        }
        .btn-dashboard:hover {
            background: #e09520;
            transform: translateY(-2px);
            text-decoration: none;
            color: #1a1a1a;
        }

        .stats-counter-section {
            background: linear-gradient(135deg, #1a6b4a, #0d4d33);
            padding: 3rem 2rem;
            border-radius: 16px;
            margin: 3rem 0;
            text-align: center;
            color: white;
        }
        .stat-number { font-size: 2.8rem; font-weight: 800; color: #f4a226; line-height: 1; margin-bottom: 0.5rem; }
        .stat-label-small { font-size: 0.9rem; opacity: 0.9; }

        .steps-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; margin: 2rem 0; }
        .step-card {
            background: white;
            padding: 2rem;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }
        .step-card:hover { transform: translateY(-5px); box-shadow: 0 12px 28px rgba(0,0,0,0.15); }
        .step-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #e8f5ee, #ffffff);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 2rem;
            color: #1a6b4a;
        }

        .categories-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 1.5rem; margin: 2rem 0; }
        .cat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }
        .cat-card:hover { transform: translateY(-5px); box-shadow: 0 12px 28px rgba(0,0,0,0.15); }
        .cat-icon {
            width: 55px;
            height: 55px;
            background: #e8f5ee;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.6rem;
            color: #1a6b4a;
        }

        .testimonial-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin: 2rem 0;
        }
        .testimonial-card {
            background: white;
            padding: 2rem;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }
        .testimonial-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 28px rgba(0,0,0,0.15);
        }
        .testimonial-quote {
            font-size: 2rem;
            color: #f4a226;
            margin-bottom: 1rem;
        }
        .testimonial-text {
            font-size: 0.95rem;
            color: #555;
            line-height: 1.7;
            margin: 1rem 0;
        }

        @media (max-width: 1024px) { .categories-grid { grid-template-columns: repeat(3, 1fr); } }
        @media (max-width: 768px) {
            .steps-grid { grid-template-columns: 1fr; }
            .categories-grid { grid-template-columns: repeat(2, 1fr); }
            .hero h1 { font-size: 1.8rem; }
        }
    </style>
</head>
<body>

<%@ include file="/views/common/navbar.jsp" %>

<main>
    <div class="container">

        <!-- Hero Section with Dashboard Button -->
        <div class="hero">
            <h1>Welcome back, <span>${sessionScope.userName}</span> 👋</h1>
            <p>You are logged in as <strong>Administrator</strong>. Manage users, categories, donations, and platform activity.</p>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-dashboard">
                <i class="fas fa-tachometer-alt"></i> Go to Admin Dashboard →
            </a>
        </div>

        <!-- Stats Counter Section -->
        <div class="stats-counter-section">
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

        <!-- How It Works Section -->
        <div style="padding: 2rem; border-radius: 16px; margin: 2rem 0; background: #f8faf9;">
            <h2 style="text-align: center; margin-bottom: 2rem;"><i class="fas fa-question-circle" style="color: #f4a226; margin-right: 10px;"></i> How EduAid Works</h2>
            <div class="steps-grid">
                <div class="step-card">
                    <div class="step-icon"><i class="fas fa-user-plus"></i></div>
                    <h3>1. Register</h3>
                    <p>Sign up as a Donor or Recipient. Our admin team reviews every registration to keep the community safe.</p>
                </div>
                <div class="step-card">
                    <div class="step-icon"><i class="fas fa-clipboard-list"></i></div>
                    <h3>2. Get Approved</h3>
                    <p>Once approved by admin, you can start donating or accessing digital resources immediately.</p>
                </div>
                <div class="step-card">
                    <div class="step-icon"><i class="fas fa-hand-holding-heart"></i></div>
                    <h3>3. Share or Download</h3>
                    <p>Donors upload digital resources. Recipients browse and download instantly. Simple, transparent, free.</p>
                </div>
            </div>
        </div>

        <!-- Categories Section -->
        <h2 style="text-align: center; margin: 2rem 0;"><i class="fas fa-th-large" style="color: #f4a226; margin-right: 10px;"></i> Digital Resource Categories</h2>
        <div class="categories-grid">
            <div class="cat-card">
                <div class="cat-icon"><i class="fas fa-book"></i></div>
                <h3>E-Books & PDFs</h3>
                <p>Digital textbooks, reference books, study guides</p>
            </div>
            <div class="cat-card">
                <div class="cat-icon"><i class="fas fa-file-alt"></i></div>
                <h3>Templates & Guides</h3>
                <p>Worksheets, lesson plans, resume templates</p>
            </div>
            <div class="cat-card">
                <div class="cat-icon"><i class="fas fa-laptop-code"></i></div>
                <h3>Educational Software</h3>
                <p>Learning apps, coding tools, digital resources</p>
            </div>
            <div class="cat-card">
                <div class="cat-icon"><i class="fas fa-video"></i></div>
                <h3>Video Lectures</h3>
                <p>Recorded lessons, tutorials, educational videos</p>
            </div>
            <div class="cat-card">
                <div class="cat-icon"><i class="fas fa-chalkboard"></i></div>
                <h3>Presentations</h3>
                <p>PowerPoint slides, teaching materials, notes</p>
            </div>
        </div>

        <!-- Testimonial Section -->
        <div style="margin: 3rem 0;">
            <h2 style="text-align: center; margin-bottom: 2rem;"><i class="fas fa-star" style="color: #f4a226; margin-right: 10px;"></i> What Our Community Says</h2>
            <div class="testimonial-grid">
                <div class="testimonial-card">
                    <div class="testimonial-quote"><i class="fas fa-quote-left"></i></div>
                    <p class="testimonial-text">EduAid helped me get digital textbooks I couldn't afford. Now I'm on the dean's list!</p>
                    <strong>- Samita R., Student</strong>
                    <div style="margin-top: 8px; color: #f4a226;">
                        <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                    </div>
                </div>
                <div class="testimonial-card">
                    <div class="testimonial-quote"><i class="fas fa-quote-left"></i></div>
                    <p class="testimonial-text">Sharing my digital teaching resources through EduAid is so easy. Happy to help others learn.</p>
                    <strong>- Rajesh P., Donor</strong>
                    <div style="margin-top: 8px; color: #f4a226;">
                        <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                    </div>
                </div>
                <div class="testimonial-card">
                    <div class="testimonial-quote"><i class="fas fa-quote-left"></i></div>
                    <p class="testimonial-text">The platform is clean, fast, and trustworthy. Instant downloads make learning accessible!</p>
                    <strong>- Priya S., Teacher</strong>
                    <div style="margin-top: 8px; color: #f4a226;">
                        <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                    </div>
                </div>
            </div>
        </div>

    </div>
</main>

<%@ include file="/views/common/footer.jsp" %>
</body>
</html>