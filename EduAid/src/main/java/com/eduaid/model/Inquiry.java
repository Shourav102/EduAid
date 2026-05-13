package com.eduaid.model;

import java.sql.Timestamp;

/**
 * Inquiry - Model class representing a row in the `inquiries` table.
 * Stores contact form submissions from the Contact Us page.
 */
public class Inquiry {

    private int       inquiryId;
    private String    fullName;
    private String    email;
    private String    subject;
    private String    message;
    private String    status;       // UNREAD | READ
    private Timestamp submittedAt;

    public Inquiry() {}

    public Inquiry(String fullName, String email, String subject, String message) {
        this.fullName = fullName;
        this.email    = email;
        this.subject  = subject;
        this.message  = message;
        this.status   = "UNREAD";
    }

    public int       getInquiryId()                    { return inquiryId; }
    public void      setInquiryId(int inquiryId)       { this.inquiryId = inquiryId; }

    public String    getFullName()                     { return fullName; }
    public void      setFullName(String fullName)      { this.fullName = fullName; }

    public String    getEmail()                        { return email; }
    public void      setEmail(String email)            { this.email = email; }

    public String    getSubject()                      { return subject; }
    public void      setSubject(String subject)        { this.subject = subject; }

    public String    getMessage()                      { return message; }
    public void      setMessage(String message)        { this.message = message; }

    public String    getStatus()                       { return status; }
    public void      setStatus(String status)          { this.status = status; }

    public Timestamp getSubmittedAt()                  { return submittedAt; }
    public void      setSubmittedAt(Timestamp t)       { this.submittedAt = t; }

    public boolean   isUnread()                        { return "UNREAD".equals(status); }
}