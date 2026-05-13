package com.eduaid.controller;

import com.eduaid.dao.InquiryDAO;
import com.eduaid.model.Inquiry;
import com.eduaid.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * ContactController - Handles the Contact Us page and inquiry submission.
 *
 * GET  /contact               → show contact page
 * POST /contact               → process form, save to DB
 * GET  /admin/inquiries       → admin view all inquiries
 * POST /admin/inquiries       → mark inquiry as read
 */
@WebServlet({"/contact", "/admin/inquiries"})
public class ContactController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private InquiryDAO inquiryDAO;

    @Override
    public void init() throws ServletException {
        inquiryDAO = new InquiryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        if (uri.contains("/admin/inquiries")) {
            showAdminInquiries(req, resp);
        } else {
            req.getRequestDispatcher("/contact.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        if (uri.contains("/admin/inquiries")) {
            handleMarkAsRead(req, resp);
        } else {
            handleContactSubmission(req, resp);
        }
    }

    private void handleContactSubmission(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName = req.getParameter("fullName");
        String email    = req.getParameter("email");
        String subject  = req.getParameter("subject");
        String message  = req.getParameter("message");

        boolean hasError = false;

        if (ValidationUtil.isBlank(fullName) || fullName.trim().matches(".*\\d.*")) {
            req.setAttribute("nameError", ValidationUtil.isBlank(fullName)
                    ? "Full name is required."
                    : "Full name must not contain numbers.");
            hasError = true;
        }
        if (ValidationUtil.isBlank(email) || ValidationUtil.validateEmail(email) != null) {
            req.setAttribute("emailError", "Please enter a valid email address.");
            hasError = true;
        }
        if (ValidationUtil.isBlank(subject)) {
            req.setAttribute("subjectError", "Subject is required.");
            hasError = true;
        }
        if (ValidationUtil.isBlank(message)) {
            req.setAttribute("messageError", "Message is required.");
            hasError = true;
        }

        if (hasError) {
            req.setAttribute("fullName", ValidationUtil.sanitise(fullName));
            req.setAttribute("email",    ValidationUtil.sanitise(email));
            req.setAttribute("subject",  ValidationUtil.sanitise(subject));
            req.setAttribute("message",  ValidationUtil.sanitise(message));
            req.getRequestDispatcher("/contact.jsp").forward(req, resp);
            return;
        }

        try {
            Inquiry inquiry = new Inquiry(
                    fullName.trim(), email.trim(),
                    subject.trim(),  message.trim()
            );
            int id = inquiryDAO.insertInquiry(inquiry);

            if (id > 0) {
                req.getSession().setAttribute("contactSuccess",
                        "Thank you for reaching out, " + fullName.trim() + "! "
                                + "We will get back to you within 1–2 working days.");
                resp.sendRedirect(req.getContextPath() + "/contact");
            } else {
                req.setAttribute("generalError", "Failed to send your message. Please try again.");
                req.getRequestDispatcher("/contact.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            System.err.println("[ContactController] DB error: " + e.getMessage());
            req.setAttribute("generalError", "A server error occurred. Please try again later.");
            req.getRequestDispatcher("/contact.jsp").forward(req, resp);
        }
    }

    private void showAdminInquiries(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Inquiry> inquiries = inquiryDAO.findAll();
            int unreadCount         = inquiryDAO.countUnread();
            req.setAttribute("inquiries",   inquiries);
            req.setAttribute("unreadCount", unreadCount);

            HttpSession session = req.getSession(false);
            if (session != null) {
                req.setAttribute("successMessage", session.getAttribute("successMessage"));
                session.removeAttribute("successMessage");
            }

            req.getRequestDispatcher("/views/admin/inquiries.jsp").forward(req, resp);
        } catch (SQLException e) {
            System.err.println("[ContactController] DB error: " + e.getMessage());
            req.getRequestDispatcher("/views/common/error500.jsp").forward(req, resp);
        }
    }

    private void handleMarkAsRead(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idStr = req.getParameter("id");
        try {
            int id = Integer.parseInt(idStr.trim());
            inquiryDAO.markAsRead(id);
            req.getSession().setAttribute("successMessage", "Inquiry marked as read.");
        } catch (Exception e) {
            System.err.println("[ContactController] markAsRead error: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/inquiries");
    }
}