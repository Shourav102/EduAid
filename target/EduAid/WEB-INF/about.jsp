<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us — EduAid</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { margin:0; padding:0; font-family:'Segoe UI',sans-serif; background-color:#f5f9f7; color:#1a1a1a; display:flex; flex-direction:column; min-height:100vh; }
        .about-main { flex:1; }

        .about-hero { background-color:#1a6b4a; color:#ffffff; padding:80px 24px 60px; text-align:center; }
        .about-hero-label { display:inline-block; background-color:rgba(244,162,38,0.2); color:#f4a226; font-size:13px; font-weight:600; letter-spacing:2px; text-transform:uppercase; padding:6px 16px; border-radius:20px; margin-bottom:20px; }
        .about-hero-title { font-size:42px; font-weight:700; line-height:1.2; margin:0 0 16px; color:#ffffff; }
        .about-hero-title span { color:#f4a226; }
        .about-hero-subtitle { font-size:18px; line-height:1.7; color:#b8ddc8; max-width:600px; margin:0 auto; }

        .about-content { max-width:1100px; margin:0 auto; padding:60px 24px; }
        .section-label { font-size:12px; font-weight:600; letter-spacing:2px; text-transform:uppercase; color:#f4a226; margin-bottom:8px; }
        .section-title { font-size:28px; font-weight:700; color:#1a3d2b; margin:0 0 16px; line-height:1.3; }
        .section-text  { font-size:16px; line-height:1.8; color:#444444; max-width:700px; }

        .about-intro { display:flex; flex-wrap:wrap; gap:48px; align-items:center; margin-bottom:70px; }
        .about-intro-text { flex:1 1 300px; }
        .about-stats { flex:1 1 260px; display:flex; flex-direction:column; gap:16px; }
        .stat-card { background-color:#ffffff; border-left:4px solid #1a6b4a; border-radius:10px; padding:20px 24px; box-shadow:0 2px 10px rgba(0,0,0,0.06); }
        .stat-number { font-size:32px; font-weight:700; color:#1a6b4a; line-height:1; margin-bottom:4px; }
        .stat-desc   { font-size:14px; color:#666666; }

        .about-cause { background-color:#eef7f2; border-radius:16px; padding:48px 40px; margin-bottom:70px; border:1px solid #c5e0d0; }
        .cause-grid  { display:flex; flex-wrap:wrap; gap:32px; margin-top:28px; }
        .cause-card  { flex:1 1 220px; background-color:#ffffff; border-radius:12px; padding:24px; box-shadow:0 2px 8px rgba(0,0,0,0.05); }
        .cause-icon       { font-size:28px; margin-bottom:12px; display:block; }
        .cause-card-title { font-size:16px; font-weight:600; color:#1a3d2b; margin-bottom:8px; }
        .cause-card-text  { font-size:14px; color:#555555; line-height:1.7; }

        .about-who { margin-bottom:70px; }
        .who-grid  { display:flex; flex-wrap:wrap; gap:24px; margin-top:28px; }
        .who-card  { flex:1 1 240px; border-radius:14px; padding:32px 28px; }
        .who-card.donor     { background-color:#1a6b4a; color:#ffffff; }
        .who-card.recipient { background-color:#f4a226; color:#1a1a1a; }
        .who-card.admin     { background-color:#1a3d2b; color:#ffffff; }
        .who-card-role  { font-size:12px; font-weight:600; letter-spacing:2px; text-transform:uppercase; opacity:0.75; margin-bottom:10px; }
        .who-card-title { font-size:22px; font-weight:700; margin-bottom:12px; }
        .who-card-text  { font-size:14px; line-height:1.7; opacity:0.9; }

        .about-how  { margin-bottom:70px; }
        .steps-list { margin-top:32px; display:flex; flex-direction:column; }
        .step-item  { display:flex; gap:24px; align-items:flex-start; position:relative; padding-bottom:32px; }
        .step-item:not(:last-child)::after { content:''; position:absolute; left:19px; top:44px; bottom:0; width:2px; background-color:#c5e0d0; }
        .step-number  { width:40px; height:40px; min-width:40px; border-radius:50%; background-color:#1a6b4a; color:#ffffff; font-size:16px; font-weight:700; display:flex; align-items:center; justify-content:center; position:relative; z-index:1; }
        .step-content { padding-top:6px; }
        .step-title   { font-size:17px; font-weight:600; color:#1a3d2b; margin-bottom:6px; }
        .step-text    { font-size:15px; color:#555555; line-height:1.7; max-width:580px; }

        .about-cta  { background-color:#1a6b4a; border-radius:16px; padding:56px 40px; text-align:center; color:#ffffff; }
        .cta-title  { font-size:30px; font-weight:700; color:#ffffff; margin-bottom:12px; }
        .cta-text   { font-size:16px; color:#b8ddc8; margin-bottom:32px; line-height:1.7; }
        .cta-buttons { display:flex; gap:16px; justify-content:center; flex-wrap:wrap; }
        .btn-cta-primary   { background-color:#f4a226; color:#1a1a1a; font-weight:600; font-size:16px; padding:14px 32px; border-radius:8px; text-decoration:none; display:inline-block; transition:background-color 0.2s ease,transform 0.1s ease; }
        .btn-cta-primary:hover { background-color:#e09520; transform:translateY(-1px); }
        .btn-cta-secondary { background-color:transparent; color:#ffffff; font-weight:600; font-size:16px; padding:14px 32px; border-radius:8px; border:2px solid rgba(255,255,255,0.5); text-decoration:none; display:inline-block; transition:border-color 0.2s ease,background-color 0.2s ease; }
        .btn-cta-secondary:hover { border-color:#ffffff; background-color:rgba(255,255,255,0.1); }

        @media (max-width:768px) {
            .about-hero-title    { font-size:28px; }
            .about-hero-subtitle { font-size:16px; }
            .about-hero          { padding:50px 20px 40px; }
            .about-intro         { flex-direction:column; gap:32px; }
            .about-cause         { padding:32px 20px; }
            .who-grid            { flex-direction:column; }
            .about-cta           { padding:40px 20px; }
            .cta-title           { font-size:24px; }
            .cta-buttons         { flex-direction:column; align-items:center; }
            .btn-cta-primary, .btn-cta-secondary { width:100%; max-width:280px; text-align:center; }
        }
    </style>
</head>
<body>

<%@ include file="/views/common/navbar.jsp" %>

<main class="about-main">

    <section class="about-hero">
        <p class="about-hero-label">Our Story</p>
        <h1 class="about-hero-title">Education is a right,<br>not a <span>privilege</span></h1>
        <p class="about-hero-subtitle">EduAid bridges the gap between those who have educational resources to share and those who need them most.</p>
    </section>

    <div class="about-content">

        <div class="about-intro">
            <div class="about-intro-text">
                <p class="section-label">What We Are</p>
                <h2 class="section-title">A platform built to reduce educational inequality</h2>
                <p class="section-text">EduAid connects <strong>Donors</strong> — people with spare educational materials — with <strong>Recipients</strong> — students and teachers who cannot afford them.</p>
                <p class="section-text" style="margin-top:16px;">Whether it is textbooks, stationery, lab equipment, or digital resources, EduAid makes sharing simple, safe, and meaningful.</p>
            </div>
            <div class="about-stats">
                <div class="stat-card"><div class="stat-number">5+</div><div class="stat-desc">Resource categories: Books, Stationery, Lab Equipment, Digital Media and more</div></div>
                <div class="stat-card"><div class="stat-number">100%</div><div class="stat-desc">Free to use — no charges for donors or recipients</div></div>
                <div class="stat-card"><div class="stat-number">1 Goal</div><div class="stat-desc">Ensure every student has the tools they need to learn</div></div>
            </div>
        </div>

        <div class="about-cause">
            <p class="section-label">The Ethical Cause</p>
            <h2 class="section-title">Why EduAid exists</h2>
            <p class="section-text">Millions of students are held back not by lack of ability, but by lack of access to basic learning materials. EduAid tackles this through community sharing.</p>
            <div class="cause-grid">
                <div class="cause-card"><span class="cause-icon">&#128218;</span><div class="cause-card-title">Access to Books</div><p class="cause-card-text">Many students cannot afford required textbooks. EduAid enables donors to pass on books they no longer need.</p></div>
                <div class="cause-card"><span class="cause-icon">&#9999;</span><div class="cause-card-title">Basic Stationery</div><p class="cause-card-text">Something as simple as a pen or notebook can make the difference between attending class or staying home.</p></div>
                <div class="cause-card"><span class="cause-icon">&#128300;</span><div class="cause-card-title">Lab Equipment</div><p class="cause-card-text">Science students need equipment to practise. EduAid helps redistribute surplus lab resources.</p></div>
                <div class="cause-card"><span class="cause-icon">&#127775;</span><div class="cause-card-title">Equal Opportunity</div><p class="cause-card-text">Every child deserves a fair start. Educational inequality can be reduced through community action.</p></div>
            </div>
        </div>

        <div class="about-who">
            <p class="section-label">Who We Help</p>
            <h2 class="section-title">Three roles, one shared mission</h2>
            <p class="section-text">EduAid serves three types of users, each playing a vital role in the donation ecosystem.</p>
            <div class="who-grid">
                <div class="who-card donor"><div class="who-card-role">Role</div><div class="who-card-title">Donor</div><p class="who-card-text">Teachers, parents, or students who have spare educational materials and want to give them to someone who needs them.</p></div>
                <div class="who-card recipient"><div class="who-card-role">Role</div><div class="who-card-title">Recipient</div><p class="who-card-text">Students or teachers in need of resources who cannot easily afford them. They browse and apply for listed materials.</p></div>
                <div class="who-card admin"><div class="who-card-role">Role</div><div class="who-card-title">Admin</div><p class="who-card-text">The platform manager who approves registrations, manages categories, and oversees all EduAid activity.</p></div>
            </div>
        </div>

        <div class="about-how">
            <p class="section-label">How It Works</p>
            <h2 class="section-title">Simple steps, real impact</h2>
            <p class="section-text">Getting started on EduAid takes only a few minutes.</p>
            <div class="steps-list">
                <div class="step-item"><div class="step-number">1</div><div class="step-content"><div class="step-title">Register your account</div><p class="step-text">Sign up as a Donor or Recipient. Your account will be reviewed by Admin before you can log in.</p></div></div>
                <div class="step-item"><div class="step-number">2</div><div class="step-content"><div class="step-title">Admin approves your account</div><p class="step-text">Our admin reviews every registration to keep the platform safe and trustworthy.</p></div></div>
                <div class="step-item"><div class="step-number">3</div><div class="step-content"><div class="step-title">Donors list their resources</div><p class="step-text">Approved donors list educational materials with details like category and condition.</p></div></div>
                <div class="step-item"><div class="step-number">4</div><div class="step-content"><div class="step-title">Recipients browse and apply</div><p class="step-text">Recipients search available resources, save to wishlist, and submit a request for what they need.</p></div></div>
                <div class="step-item"><div class="step-number">5</div><div class="step-content"><div class="step-title">Resources reach those in need</div><p class="step-text">The donation is fulfilled and a student who needed materials can now focus on learning.</p></div></div>
            </div>
        </div>

        <div class="about-cta">
            <h2 class="cta-title">Ready to make a difference?</h2>
            <p class="cta-text">Join EduAid today and be part of a community that believes education should be accessible to everyone.</p>
            <div class="cta-buttons">
                <a href="${pageContext.request.contextPath}/auth?action=register" class="btn-cta-primary">Register Now</a>
                <a href="${pageContext.request.contextPath}/contact" class="btn-cta-secondary">Contact Us</a>
            </div>
        </div>

    </div>
</main>

<%@ include file="/views/common/footer.jsp" %>

</body>
</html>