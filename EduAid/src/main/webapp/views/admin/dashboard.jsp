<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard – EduAid</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .stat-card {
            background: white;
            border-radius: 16px;
            border: 1px solid #e2e8e6;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            transition: all 0.3s ease;
        }
        .stat-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); transform: translateY(-2px); }
        .stat-card--warning { border-top: 4px solid #f4a226; }
        .stat-card--success { border-top: 4px solid #1a6b4a; }
        .stat-icon { font-size: 2rem; margin-bottom: 0.5rem; }
        .stat-value { font-size: 2.2rem; font-weight: 800; color: #1a6b4a; line-height: 1; }
        .stat-label { font-size: 0.85rem; color: #718096; margin-top: 0.3rem; font-weight: 500; }

        /* Quick Action Cards */
        .action-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .action-card {
            background: linear-gradient(135deg, #1a6b4a, #0d4d33);
            color: white;
            padding: 1.2rem;
            border-radius: 12px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: block;
        }
        .action-card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0,0,0,0.2); text-decoration: none; color: white; }
        .action-icon { font-size: 1.5rem; margin-bottom: 0.5rem; display: block; }
        .action-card h4 { margin-bottom: 0.2rem; color: white; font-size: 0.9rem; }
        .action-card p { font-size: 0.7rem; opacity: 0.9; }

        /* Charts Row */
        .charts-row {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        .chart-card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            border: 1px solid #e2e8e6;
        }
        .chart-title { font-size: 1rem; font-weight: 700; color: #1a3d2b; margin-bottom: 1rem; }
        canvas { max-height: 250px; width: 100% !important; }

        .table-wrapper {
            overflow-x: auto;
            border-radius: 12px;
            border: 1px solid #e2e8e6;
            margin-bottom: 1rem;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }
        .data-table thead { background: #e8f5ee; }
        .data-table th {
            padding: 0.75rem 1rem;
            text-align: left;
            font-weight: 700;
            color: #134d35;
            font-size: 0.82rem;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            white-space: nowrap;
        }
        .data-table td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #e2e8e6;
            vertical-align: middle;
        }
        .data-table tbody tr:last-child td { border-bottom: none; }
        .data-table tbody tr:hover { background: #f7faf8; }

        .badge-pending { background: #fef3e2; color: #b7680d; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.8rem; display: inline-block; }
        .badge-approved { background: #e8f5ee; color: #1a6b4a; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.8rem; display: inline-block; }
        .badge-disabled { background: #f0f0f0; color: #666; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.8rem; display: inline-block; }
        .badge-rejected { background: #fdf0ef; color: #c0392b; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.8rem; display: inline-block; }

        .btn-sm { padding: 0.3rem 0.8rem; font-size: 0.75rem; border-radius: 6px; }
        .btn-primary { background: #1a6b4a; color: white; border: none; cursor: pointer; }
        .btn-primary:hover { background: #134d35; }
        .btn-danger { background: #c0392b; color: white; border: none; cursor: pointer; }
        .btn-danger:hover { background: #a93226; }
        .btn-outline { background: transparent; border: 1px solid #1a6b4a; color: #1a6b4a; cursor: pointer; }
        .btn-outline:hover { background: #e8f5ee; }

        .card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            border: 1px solid #e2e8e6;
        }
        .card-title { font-size: 1.2rem; font-weight: 700; color: #1a3d2b; margin-bottom: 0.5rem; }
        .section-title { font-size: 1rem; font-weight: 700; margin: 1rem 0 0.5rem; padding-bottom: 0.5rem; border-bottom: 2px solid #e2e8e6; }
        .alert-success { background: #e8f5ee; color: #1a6b4a; padding: 0.75rem 1rem; border-radius: 10px; }

        .file-viewer-modal {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }
        .file-viewer-content {
            background: white;
            max-width: 900px;
            width: 95%;
            border-radius: 20px;
            padding: 2rem;
            max-height: 85vh;
            overflow-y: auto;
        }
        .file-viewer { text-align: center; }
        .file-viewer img { max-width: 100%; max-height: 70vh; border-radius: 8px; }
        .file-viewer iframe { width: 100%; height: 70vh; border: none; border-radius: 8px; }

        @media (max-width: 900px) { .stats-grid, .action-grid, .charts-row { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 480px) { .stats-grid, .action-grid, .charts-row { grid-template-columns: 1fr; } }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/home" class="navbar-brand">
        📚 Edu<span>Aid</span> <span style="font-size:0.75rem; opacity:0.75; font-weight:400;">Admin</span>
    </a>
    <button class="navbar-toggle" aria-label="Toggle navigation">
        <span></span><span></span><span></span>
    </button>
    <ul class="navbar-links">
        <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="active">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/users">Users</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/inquiries">Inquiries</a></li>
        <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
        <li><a href="${pageContext.request.contextPath}/auth?action=logout" class="btn-nav-accent">Logout</a></li>
    </ul>
</nav>

<main>
    <div class="container">
        <div class="page-header">
            <h1>Welcome back, ${sessionScope.userName} 👋</h1>
            <p>Here's an overview of EduAid activity requiring your attention.</p>
        </div>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-users"></i></div>
                <div class="stat-value">${totalUsers}</div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card stat-card--warning">
                <div class="stat-icon"><i class="fas fa-clock"></i></div>
                <div class="stat-value">${pendingCount}</div>
                <div class="stat-label">Pending Approvals</div>
            </div>
            <div class="stat-card stat-card--success">
                <div class="stat-icon"><i class="fas fa-check-circle"></i></div>
                <div class="stat-value">${approvedCount}</div>
                <div class="stat-label">Approved Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-tags"></i></div>
                <div class="stat-value">${catCount}</div>
                <div class="stat-label">Categories</div>
            </div>
        </div>

        <!-- Quick Action Cards -->
        <div class="action-grid">
            <a href="${pageContext.request.contextPath}/admin/users" class="action-card">
                <i class="fas fa-user-cog action-icon"></i>
                <h4>Manage Users</h4>
                <p>Approve or disable accounts</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/categories" class="action-card">
                <i class="fas fa-tags action-icon"></i>
                <h4>Manage Categories</h4>
                <p>Add, edit, delete categories</p>
            </a>
            <a href="#" onclick="document.getElementById('resourcesContainer').scrollIntoView({behavior:'smooth'});" class="action-card">
                <i class="fas fa-boxes action-icon"></i>
                <h4>Manage Donations</h4>
                <p>Approve or reject resources</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/inquiries" class="action-card">
                <i class="fas fa-envelope action-icon"></i>
                <h4>View Inquiries</h4>
                <p>Read user messages</p>
            </a>
        </div>

        <!-- Charts Row -->
        <div class="charts-row">
            <div class="chart-card">
                <div class="chart-title"><i class="fas fa-chart-pie"></i> User Distribution</div>
                <canvas id="userChart"></canvas>
            </div>
            <div class="chart-card">
                <div class="chart-title"><i class="fas fa-chart-bar"></i> Donations by Category</div>
                <canvas id="categoryChart"></canvas>
            </div>
        </div>

        <!-- Pending Users -->
        <div class="card">
            <div class="card-title">⏳ Users Awaiting Approval <span class="badge-pending" style="margin-left:0.5rem;">${pendingCount}</span></div>
            <c:choose>
                <c:when test="${empty pendingUsers}">
                    <div class="alert-success">✅ No pending approvals — you're all caught up!</div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead><tr><th>#</th><th>Full Name</th><th>Email</th><th>Role</th><th>Institution</th><th>Registered</th><th>Action</th></tr></thead>
                            <tbody>
                            <c:forEach var="user" items="${pendingUsers}" varStatus="s">
                                <tr>
                                    <td>${s.count}</td>
                                    <td>${user.fullName}</td>
                                    <td>${user.email}</td>
                                    <td><span class="badge-pending">${user.role}</span></td>
                                    <td>${user.institution}</td>
                                    <td>${user.createdAt}</td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="approve">
                                            <input type="hidden" name="userId" value="${user.userId}">
                                            <button type="submit" class="btn btn-primary btn-sm">Approve</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Donation Management -->
        <div class="card">
            <div class="card-title"><i class="fas fa-boxes"></i> Donation Management</div>
            <div id="resourcesContainer">Loading donations...</div>
        </div>
    </div>
</main>

<!-- File Viewer Modal -->
<div id="fileViewerModal" class="file-viewer-modal" style="display:none;">
    <div class="file-viewer-content">
        <h3 id="fileViewerTitle"><i class="fas fa-file"></i> Resource Viewer</h3>
        <div id="fileViewerContent" class="file-viewer"><p>Loading...</p></div>
        <div style="display:flex; gap:1rem; margin-top:1rem; justify-content:flex-end;">
            <button onclick="downloadCurrentFile()" class="btn btn-primary">Download</button>
            <button onclick="closeFileViewer()" class="btn btn-outline">Close</button>
        </div>
    </div>
</div>

<footer><p>&copy; 2026 EduAid Admin Panel. Logged in as <strong>${sessionScope.userName}</strong>.</p></footer>

<script>
    let currentFilePath = '', currentFileName = '';

    $(document).ready(function() {
        loadResources();
        loadCharts();
    });

    function loadCharts() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/admin/chart-data',
            method: 'GET',
            success: function(data) {
                // User Distribution Chart
                const userCtx = document.getElementById('userChart').getContext('2d');
                new Chart(userCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ['Admins', 'Donors', 'Recipients'],
                        datasets: [{
                            data: [data.adminCount || 0, data.donorCount || 0, data.recipientCount || 0],
                            backgroundColor: ['#1a6b4a', '#f4a226', '#134d35'],
                            borderWidth: 0
                        }]
                    },
                    options: { responsive: true, maintainAspectRatio: true }
                });

                // Category Distribution Chart
                const catCtx = document.getElementById('categoryChart').getContext('2d');
                if (data.categoryLabels && data.categoryCounts) {
                    new Chart(catCtx, {
                        type: 'bar',
                        data: {
                            labels: data.categoryLabels,
                            datasets: [{
                                label: 'Number of Donations',
                                data: data.categoryCounts,
                                backgroundColor: '#1a6b4a',
                                borderRadius: 5
                            }]
                        },
                        options: { responsive: true, maintainAspectRatio: true, scales: { y: { beginAtZero: true } } }
                    });
                }
            }
        });
    }

    function viewFile(filePath, title) {
        currentFilePath = filePath; currentFileName = title;
        document.getElementById('fileViewerTitle').innerHTML = '<i class="fas fa-file"></i> ' + escapeHtml(title);
        let ext = filePath.split('.').pop().toLowerCase();
        let viewerHtml = '';
        if (['jpg','jpeg','png','gif','webp'].includes(ext)) {
            viewerHtml = '<img src="${pageContext.request.contextPath}/' + filePath + '">';
        } else if (ext === 'pdf') {
            viewerHtml = '<iframe src="${pageContext.request.contextPath}/' + filePath + '"></iframe>';
        } else {
            viewerHtml = '<div style="text-align:center; padding:3rem;"><i class="fas fa-file-alt" style="font-size:3rem;"></i><p>Preview not available. Click Download.</p></div>';
        }
        document.getElementById('fileViewerContent').innerHTML = viewerHtml;
        document.getElementById('fileViewerModal').style.display = 'flex';
    }

    function downloadCurrentFile() {
        if (currentFilePath) {
            var link = document.createElement('a');
            link.href = '${pageContext.request.contextPath}/' + currentFilePath;
            link.download = currentFileName;
            document.body.appendChild(link); link.click(); document.body.removeChild(link);
        }
    }

    function closeFileViewer() {
        document.getElementById('fileViewerModal').style.display = 'none';
        document.getElementById('fileViewerContent').innerHTML = '<p>Loading...</p>';
        currentFilePath = ''; currentFileName = '';
    }

    function loadResources() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/admin/resources',
            method: 'GET',
            success: function(data) {
                if (!data || data.length === 0) {
                    $('#resourcesContainer').html('<div class="alert-success">📦 No donations yet.</div>');
                    return;
                }
                var pending = data.filter(function(r) { return r.status === 'PENDING'; });
                var available = data.filter(function(r) { return r.status === 'AVAILABLE'; });
                var rejected = data.filter(function(r) { return r.status === 'REJECTED'; });
                var claimed = data.filter(function(r) { return r.status === 'CLAIMED'; });
                var html = '';
                if (pending.length > 0) {
                    html += '<div class="section-title"><i class="fas fa-clock" style="color:#b7680d;"></i> Pending Approval (' + pending.length + ')</div>';
                    html += '<div class="table-wrapper"><table class="data-table"><thead><tr><th>ID</th><th>Title</th><th>Donor</th><th>Category</th><th>Condition</th><th>Date</th><th>File</th><th>Actions</th></tr></thead><tbody>';
                    for (var i = 0; i < pending.length; i++) {
                        var r = pending[i];
                        var fileBtn = (r.imagePath && r.imagePath !== 'null') ? '<button onclick="viewFile(\'' + r.imagePath + '\', \'' + escapeHtml(r.title) + '\')" class="btn btn-outline btn-sm"><i class="fas fa-eye"></i> View</button>' : '<span class="badge-disabled">No file</span>';
                        html += '<tr><td>' + r.resourceId + '</td><td><strong>' + escapeHtml(r.title) + '</strong></td><td>' + escapeHtml(r.donorName) + '</td><td>' + escapeHtml(r.categoryName || 'General') + '</td><td>' + r.conditionType + '</td><td>' + r.createdAt + '</td><td>' + fileBtn + '</td><td><button onclick="approveDonation(' + r.resourceId + ')" class="btn btn-primary btn-sm">Approve</button> <button onclick="rejectDonation(' + r.resourceId + ')" class="btn btn-danger btn-sm">Reject</button></td></tr>';
                    }
                    html += '</tbody></table></div>';
                }
                if (available.length > 0) {
                    html += '<div class="section-title"><i class="fas fa-check-circle" style="color:#1a6b4a;"></i> Available Resources (' + available.length + ')</div>';
                    html += '<div class="table-wrapper"><table class="data-table"><thead><tr><th>ID</th><th>Title</th><th>Donor</th><th>Category</th><th>Condition</th><th>Date</th><th>File</th><th>Action</th></tr></thead><tbody>';
                    for (var i = 0; i < available.length; i++) {
                        var r = available[i];
                        var fileBtn = (r.imagePath && r.imagePath !== 'null') ? '<button onclick="viewFile(\'' + r.imagePath + '\', \'' + escapeHtml(r.title) + '\')" class="btn btn-outline btn-sm"><i class="fas fa-eye"></i> View</button>' : '<span class="badge-disabled">No file</span>';
                        html += '<tr><td>' + r.resourceId + '</td><td>' + escapeHtml(r.title) + '</td><td>' + escapeHtml(r.donorName) + '</td><td>' + escapeHtml(r.categoryName || 'General') + '</td><td>' + r.conditionType + '</td><td>' + r.createdAt + '</td><td>' + fileBtn + '</td><td><button onclick="deleteResource(' + r.resourceId + ')" class="btn btn-danger btn-sm">Delete</button></td></tr>';
                    }
                    html += '</tbody></table></div>';
                }
                if (rejected.length > 0) {
                    html += '<div class="section-title"><i class="fas fa-times-circle" style="color:#c0392b;"></i> Rejected Donations (' + rejected.length + ')</div><div class="table-wrapper"><table class="data-table"><thead><tr><th>ID</th><th>Title</th><th>Donor</th><th>Category</th><th>Condition</th><th>Date</th><th>File</th><th>Action</th></tr></thead><tbody>';
                    for (var i = 0; i < rejected.length; i++) {
                        var r = rejected[i];
                        var fileBtn = (r.imagePath && r.imagePath !== 'null') ? '<button onclick="viewFile(\'' + r.imagePath + '\', \'' + escapeHtml(r.title) + '\')" class="btn btn-outline btn-sm"><i class="fas fa-eye"></i> View</button>' : '<span class="badge-disabled">No file</span>';
                        html += '<tr><td>' + r.resourceId + '</td><td>' + escapeHtml(r.title) + '</td><td>' + escapeHtml(r.donorName) + '</td><td>' + escapeHtml(r.categoryName || 'General') + '</td><td>' + r.conditionType + '</td><td>' + r.createdAt + '</td><td>' + fileBtn + '</td><td><button onclick="deleteResource(' + r.resourceId + ')" class="btn btn-danger btn-sm">Delete</button></td></tr>';
                    }
                    html += '</tbody></table></div>';
                }
                if (claimed.length > 0) {
                    html += '<div class="section-title"><i class="fas fa-gift" style="color:#666;"></i> Claimed Resources (' + claimed.length + ')</div><div class="table-wrapper"><table class="data-table"><thead><tr><th>ID</th><th>Title</th><th>Donor</th><th>Category</th><th>Condition</th><th>Date</th><th>File</th><th>Status</th></tr></thead><tbody>';
                    for (var i = 0; i < claimed.length; i++) {
                        var r = claimed[i];
                        var fileBtn = (r.imagePath && r.imagePath !== 'null') ? '<button onclick="viewFile(\'' + r.imagePath + '\', \'' + escapeHtml(r.title) + '\')" class="btn btn-outline btn-sm"><i class="fas fa-eye"></i> View</button>' : '<span class="badge-disabled">No file</span>';
                        html += '<tr><td>' + r.resourceId + '</td><td>' + escapeHtml(r.title) + '</td><td>' + escapeHtml(r.donorName) + '</td><td>' + escapeHtml(r.categoryName || 'General') + '</td><td>' + r.conditionType + '</td><td>' + r.createdAt + '</td><td>' + fileBtn + '</td><td><span class="badge-disabled">CLAIMED</span></td></tr>';
                    }
                    html += '</tbody></table></div>';
                }
                if (pending.length === 0 && available.length === 0 && rejected.length === 0 && claimed.length === 0) html = '<div class="alert-success">📦 No donations yet.</div>';
                $('#resourcesContainer').html(html);
            }
        });
    }

    function approveDonation(resourceId) {
        if (confirm('Approve this donation?')) {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/admin/resource/approve',
                method: 'POST',
                data: { resourceId: resourceId },
                success: function() { alert('Approved!'); loadResources(); loadCharts(); }
            });
        }
    }

    function rejectDonation(resourceId) {
        if (confirm('Reject this donation?')) {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/admin/resource/reject',
                method: 'POST',
                data: { resourceId: resourceId },
                success: function() { alert('Rejected!'); loadResources(); loadCharts(); }
            });
        }
    }

    function deleteResource(resourceId) {
        if (confirm('Delete this resource?')) {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/donor/delete/' + resourceId,
                method: 'DELETE',
                success: function() { alert('Deleted!'); loadResources(); loadCharts(); }
            });
        }
    }

    function escapeHtml(str) {
        if (!str) return '';
        return str.replace(/[&<>]/g, function(m) {
            if (m === '&') return '&amp;';
            if (m === '<') return '&lt;';
            if (m === '>') return '&gt;';
            return m;
        });
    }
</script>
</body>
</html>