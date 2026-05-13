<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Inquiries — EduAid Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
  <style>
    .unread-row { background-color: #f0faf5; font-weight: 600; }
    .badge-unread { background: #fef3e2; color: #b7680d; }
    .badge-read { background: #f0f0f0; color: #666; }
    .message-preview { max-width: 280px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-size: 13px; color: #555; }
    .expand-btn { background: none; border: none; color: #1a6b4a; font-size: 13px; cursor: pointer; font-weight: 600; padding: 0; font-family: 'Segoe UI', sans-serif; }
    .expand-btn:hover { text-decoration: underline; }
    .modal-overlay { display: none; position: fixed; top:0; left:0; right:0; bottom:0; background: rgba(0,0,0,0.45); z-index: 9998; align-items: center; justify-content: center; }
    .modal-overlay.open { display: flex; }
    .modal-box { background: #fff; border-radius: 16px; padding: 36px; max-width: 560px; width: 90%; box-shadow: 0 16px 48px rgba(0,0,0,0.2); position: relative; }
    .modal-close { position: absolute; top: 16px; right: 20px; background: none; border: none; font-size: 22px; cursor: pointer; color: #888; }
    .modal-close:hover { color: #1a1a1a; }
    .modal-label { font-size: 12px; font-weight: 700; color: #888; text-transform: uppercase; letter-spacing: 0.8px; margin-bottom: 4px; margin-top: 16px; }
    .modal-value { font-size: 15px; color: #1a1a1a; line-height: 1.7; }
    .modal-message { background: #f5f9f7; border-radius: 10px; padding: 16px; margin-top: 4px; font-size: 14px; color: #333; line-height: 1.8; white-space: pre-wrap; }
  </style>
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/home" class="navbar-brand">
    📚 Edu<span>Aid</span>
    <span style="font-size:0.75rem; opacity:0.75; font-weight:400; margin-left:6px;">Admin</span>
  </a>
  <button class="navbar-toggle" aria-label="Toggle navigation">
    <span></span><span></span><span></span>
  </button>
  <ul class="navbar-links">
    <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
    <li><a href="${pageContext.request.contextPath}/admin/users">Users</a></li>
    <li><a href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
    <li><a href="${pageContext.request.contextPath}/admin/inquiries" class="active">Inquiries</a></li>
    <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
    <li><a href="${pageContext.request.contextPath}/auth?action=logout" class="btn-nav-accent">Logout</a></li>
  </ul>
</nav>

<main>
  <div class="container">

    <div class="page-header">
      <h1>✉️ Contact Inquiries
        <c:if test="${unreadCount > 0}">
          <span class="badge badge-pending" style="margin-left:10px; font-size:0.85rem;">${unreadCount} unread</span>
        </c:if>
      </h1>
      <p>All messages submitted through the EduAid Contact Us page.</p>
    </div>

    <c:if test="${not empty successMessage}">
      <div class="alert alert-success">✅ ${successMessage}</div>
    </c:if>

    <div class="card">
      <c:choose>
        <c:when test="${empty inquiries}">
          <div class="alert alert-info">ℹ No inquiries received yet.</div>
        </c:when>
        <c:otherwise>
          <div class="table-wrapper">
            <table class="data-table">
              <thead>
              <tr>
                <th>#</th>
                <th>Status</th>
                <th>Name</th>
                <th>Email</th>
                <th>Subject</th>
                <th>Message</th>
                <th>Received</th>
                <th>Action</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="inq" items="${inquiries}" varStatus="s">
                <tr class="${inq.unread ? 'unread-row' : ''}">
                  <td>${s.count}</td>
                  <td><span class="badge ${inq.unread ? 'badge-unread' : 'badge-read'}">${inq.status}</span></td>
                  <td>${inq.fullName}</td>
                  <td><a href="mailto:${inq.email}" style="color:#1a6b4a;">${inq.email}</a></td>
                  <td>${inq.subject}</td>
                  <td>
                    <div class="message-preview">${inq.message}</div>
                    <button class="expand-btn"
                            onclick="openModal('${inq.fullName}','${inq.email}','${inq.subject}',`${inq.message}`,${inq.inquiryId},'${inq.status}')">
                      View full
                    </button>
                  </td>
                  <td style="font-size:0.8rem; color:var(--text-light);">${inq.submittedAt}</td>
                  <td>
                    <c:if test="${inq.unread}">
                      <form action="${pageContext.request.contextPath}/admin/inquiries" method="post">
                        <input type="hidden" name="action" value="read">
                        <input type="hidden" name="id" value="${inq.inquiryId}">
                        <button type="submit" class="btn btn-outline btn-sm">✓ Mark Read</button>
                      </form>
                    </c:if>
                    <c:if test="${!inq.unread}">
                      <span style="font-size:0.8rem; color:var(--text-light);">—</span>
                    </c:if>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

  </div>
</main>

<div class="modal-overlay" id="inquiryModal">
  <div class="modal-box">
    <button class="modal-close" onclick="closeModal()">&#10005;</button>
    <h2 style="font-size:18px; font-weight:700; color:#1a3d2b; margin-bottom:4px;">Inquiry Details</h2>
    <div id="modal-status"></div>
    <div class="modal-label">From</div>
    <div class="modal-value" id="modal-name"></div>
    <div class="modal-label">Email</div>
    <div class="modal-value" id="modal-email"></div>
    <div class="modal-label">Subject</div>
    <div class="modal-value" id="modal-subject"></div>
    <div class="modal-label">Message</div>
    <div class="modal-message" id="modal-message"></div>
  </div>
</div>

<footer>
  <p>&copy; 2026 EduAid Admin Panel.</p>
</footer>

<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<script>
  function openModal(name, email, subject, message, id, status) {
    document.getElementById('modal-name').textContent = name;
    document.getElementById('modal-email').textContent = email;
    document.getElementById('modal-subject').textContent = subject;
    document.getElementById('modal-message').textContent = message;
    document.getElementById('modal-status').innerHTML = status === 'UNREAD'
            ? '<span class="badge badge-pending" style="font-size:11px;">UNREAD</span>'
            : '<span class="badge badge-disabled" style="font-size:11px;">READ</span>';
    document.getElementById('inquiryModal').classList.add('open');
  }

  function closeModal() {
    document.getElementById('inquiryModal').classList.remove('open');
  }

  document.getElementById('inquiryModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
  });
</script>

</body>
</html>