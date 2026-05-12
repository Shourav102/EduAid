<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Donor Dashboard – EduAid</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .dashboard-stats {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 1.5rem;
      margin-bottom: 2rem;
    }
    .stat-card {
      background: white;
      padding: 1.5rem;
      border-radius: 16px;
      text-align: center;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      transition: all 0.3s ease;
    }
    .stat-card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0,0,0,0.12); }
    .stat-number { font-size: 2rem; font-weight: 800; color: #1a6b4a; }
    .stat-label { color: #666; margin-top: 0.5rem; }

    /* Quick Action Cards */
    .action-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 1.5rem;
      margin-bottom: 2rem;
    }
    .action-card {
      background: linear-gradient(135deg, #1a6b4a, #0d4d33);
      color: white;
      padding: 1.5rem;
      border-radius: 16px;
      text-align: center;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: block;
    }
    .action-card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0,0,0,0.2); text-decoration: none; color: white; }
    .action-icon { font-size: 2rem; margin-bottom: 0.5rem; display: block; }
    .action-card h3 { margin-bottom: 0.3rem; color: white; font-size: 1rem; }
    .action-card p { font-size: 0.75rem; opacity: 0.9; }

    .resources-table {
      width: 100%;
      border-collapse: collapse;
      background: white;
      border-radius: 16px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }
    .resources-table th, .resources-table td {
      padding: 1rem;
      text-align: left;
      border-bottom: 1px solid #e2e8e6;
    }
    .resources-table th { background: #e8f5ee; color: #1a6b4a; font-weight: 600; }
    .badge-pending { background: #fef3e2; color: #b7680d; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.8rem; }
    .badge-available { background: #e8f5ee; color: #1a6b4a; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.8rem; }
    .badge-rejected { background: #fdf0ef; color: #c0392b; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.8rem; }

    .modal {
      display: none;
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
    .modal-content {
      background: white;
      max-width: 500px;
      width: 90%;
      border-radius: 20px;
      padding: 2rem;
      max-height: 85vh;
      overflow-y: auto;
    }

    .file-viewer-modal .modal-content { max-width: 900px; width: 95%; }
    .file-viewer { text-align: center; }
    .file-viewer img { max-width: 100%; max-height: 70vh; border-radius: 8px; }
    .file-viewer iframe { width: 100%; height: 70vh; border: none; border-radius: 8px; }

    @media (max-width: 768px) {
      .dashboard-stats, .action-grid { grid-template-columns: repeat(2, 1fr); }
    }
  </style>
</head>
<body>

<jsp:include page="/views/common/navbar.jsp" />

<main>
  <div class="container">
    <div class="page-header">
      <h1><i class="fas fa-hand-holding-heart"></i> Donor Dashboard</h1>
      <p>Welcome back, ${sessionScope.userName}! Track your donations and see what recipients need.</p>
    </div>

    <!-- Stats Cards -->
    <div class="dashboard-stats">
      <div class="stat-card">
        <div class="stat-number" id="totalDonations">0</div>
        <div class="stat-label"><i class="fas fa-box"></i> Total Donations</div>
      </div>
      <div class="stat-card">
        <div class="stat-number" id="pendingCount">0</div>
        <div class="stat-label"><i class="fas fa-clock"></i> Pending</div>
      </div>
      <div class="stat-card">
        <div class="stat-number" id="availableCount">0</div>
        <div class="stat-label"><i class="fas fa-check-circle"></i> Available</div>
      </div>
      <div class="stat-card">
        <div class="stat-number" id="rejectedCount">0</div>
        <div class="stat-label"><i class="fas fa-times-circle"></i> Rejected</div>
      </div>
    </div>

    <!-- Quick Action Cards -->
    <div class="action-grid">
      <div class="action-card" onclick="openDonateModal()">
        <i class="fas fa-plus-circle action-icon"></i>
        <h3>Donate Resource</h3>
        <p>Share digital materials</p>
      </div>
      <div class="action-card" onclick="showWishlistsModal()">
        <i class="fas fa-list action-icon"></i>
        <h3>View Wishlists</h3>
        <p>See what recipients need</p>
      </div>
      <div class="action-card" onclick="location.reload()">
        <i class="fas fa-chart-line action-icon"></i>
        <h3>Refresh Stats</h3>
        <p>Update dashboard data</p>
      </div>
    </div>

    <!-- My Donations Table -->
    <h3><i class="fas fa-boxes"></i> My Donations</h3>
    <div style="overflow-x: auto;">
      <table class="resources-table" id="donationsTable">
        <thead><tr><th>Title</th><th>Category</th><th>Condition</th><th>Status</th><th>Date</th><th>File</th><th>Action</th></tr></thead>
        <tbody id="donationsBody"><tr><td colspan="7" style="text-align: center;">Loading...</td></tr></tbody>
      </table>
    </div>
  </div>
</main>

<!-- Donate Modal -->
<div id="donateModal" class="modal">
  <div class="modal-content">
    <h3><i class="fas fa-plus-circle"></i> Donate a Resource</h3>
    <form id="donateForm" enctype="multipart/form-data">
      <div class="form-group"><label>Title *</label><input type="text" id="title" class="form-control" required></div>
      <div class="form-group"><label>Description</label><textarea id="description" class="form-control" rows="3"></textarea></div>
      <div class="form-group">
        <label>Category *</label>
        <select id="categoryId" class="form-control" required>
          <option value="">Select Category</option>
          <c:forEach var="cat" items="${categories}"><option value="${cat.categoryId}">${cat.name}</option></c:forEach>
        </select>
      </div>
      <div class="form-group">
        <label>Condition *</label>
        <select id="condition" class="form-control" required>
          <option value="NEW">🆕 New</option><option value="GOOD">👍 Good</option>
          <option value="FAIR">📖 Fair</option><option value="POOR">📚 Poor</option>
        </select>
      </div>
      <div class="form-group"><label>File</label><input type="file" id="image" accept=".pdf,.jpg,.png,.doc"></div>
      <div style="display:flex; gap:1rem;"><button type="submit" class="btn btn-primary">Submit</button><button type="button" onclick="closeDonateModal()" class="btn btn-outline">Cancel</button></div>
    </form>
  </div>
</div>

<!-- Wishlists Modal -->
<div id="wishlistsModal" class="modal">
  <div class="modal-content" style="max-width:700px;">
    <h3><i class="fas fa-list"></i> Recipients' Wishlists</h3>
    <div id="wishlistsList" style="max-height:400px; overflow-y:auto;"><p>Loading...</p></div>
    <button class="btn btn-outline" onclick="closeWishlistsModal()" style="margin-top:1rem;">Close</button>
  </div>
</div>

<!-- File Viewer Modal -->
<div id="fileViewerModal" class="modal file-viewer-modal">
  <div class="modal-content">
    <h3 id="fileViewerTitle"><i class="fas fa-file"></i> Resource Viewer</h3>
    <div id="fileViewerContent" class="file-viewer"><p>Loading...</p></div>
    <div style="display:flex; gap:1rem; justify-content:flex-end;"><button onclick="downloadCurrentFile()" class="btn btn-primary">Download</button><button onclick="closeFileViewer()" class="btn btn-outline">Close</button></div>
  </div>
</div>

<jsp:include page="/views/common/footer.jsp" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
  let currentFilePath='',currentFileName='';
  function loadDonorData(){
    $.ajax({url:'${pageContext.request.contextPath}/api/donor/stats',success:function(d){
        $('#totalDonations').text(d.total||0);$('#pendingCount').text(d.pending||0);
        $('#availableCount').text(d.available||0);$('#rejectedCount').text(d.rejected||0);
      }});
    $.ajax({url:'${pageContext.request.contextPath}/api/donor/donations',success:function(d){
        let h='';
        if(d.length===0) h='<tr><td colspan="7">No donations yet.</td></tr>';
        else d.forEach(function(r){
          let sc=r.status==='PENDING'?'badge-pending':(r.status==='AVAILABLE'?'badge-available':'badge-rejected');
          let fb=(r.imagePath&&r.imagePath!=='null')?'<button onclick="viewFile(\''+r.imagePath+'\',\''+escapeHtml(r.title)+'\')" class="btn btn-outline btn-sm"><i class="fas fa-eye"></i> View</button>':'<span class="badge-disabled">No file</span>';
          h+='<tr><td><strong>'+escapeHtml(r.title)+'</strong></td><td>'+(r.categoryName||'General')+'</td><td>'+r.conditionType+'</td><td><span class="'+sc+'">'+r.status+'</span></td><td>'+r.createdAt+'</td><td>'+fb+'</td><td><button onclick="deleteResource('+r.resourceId+')" class="btn btn-danger btn-sm">Delete</button></td></tr>';
        });
        $('#donationsBody').html(h);
      }});
  }
  function viewFile(p,t){currentFilePath=p;currentFileName=t;$('#fileViewerTitle').html('<i class="fas fa-file"></i> '+escapeHtml(t));let ext=p.split('.').pop().toLowerCase();let v='';if(['jpg','jpeg','png','gif','webp'].includes(ext)) v='<img src="${pageContext.request.contextPath}/'+p+'">';else if(ext==='pdf') v='<iframe src="${pageContext.request.contextPath}/'+p+'"></iframe>';else v='<div style="padding:3rem;"><i class="fas fa-file-alt" style="font-size:3rem;"></i><p>Preview not available.</p></div>';$('#fileViewerContent').html(v);$('#fileViewerModal').css('display','flex');}
  function downloadCurrentFile(){if(currentFilePath){var a=document.createElement('a');a.href='${pageContext.request.contextPath}/'+currentFilePath;a.download=currentFileName;document.body.appendChild(a);a.click();document.body.removeChild(a);}}
  function closeFileViewer(){$('#fileViewerModal').css('display','none');$('#fileViewerContent').html('<p>Loading...</p>');currentFilePath='';currentFileName='';}
  function showWishlistsModal(){$('#wishlistsModal').css('display','flex');$.ajax({url:'${pageContext.request.contextPath}/api/wishlist/all',success:function(d){let h='';if(d.length===0) h='<div style="padding:2rem;">No wishlist items yet.</div>';else{d.forEach(function(i){h+='<div style="border-bottom:1px solid #eee; padding:1rem;"><strong><i class="fas fa-user"></i> '+escapeHtml(i.recipientName)+'</strong> wants:<br><strong style="color:#1a6b4a;">'+escapeHtml(i.title)+'</strong><br>'+escapeHtml(i.description||'')+'<br><small>Category: '+(i.categoryName||'General')+'</small></div>';});}$('#wishlistsList').html(h);}});}
  function openDonateModal(){$('#donateModal').css('display','flex');}
  function closeDonateModal(){$('#donateModal').css('display','none');}
  function closeWishlistsModal(){$('#wishlistsModal').css('display','none');}
  function escapeHtml(s){if(!s)return '';return s.replace(/[&<>]/g,function(m){if(m==='&')return '&amp;';if(m==='<')return '&lt;';if(m==='>')return '&gt;';return m;});}
  $('#donateForm').on('submit',function(e){e.preventDefault();var fd=new FormData();fd.append('title',$('#title').val());fd.append('description',$('#description').val());fd.append('categoryId',$('#categoryId').val());fd.append('condition',$('#condition').val());if($('#image')[0].files[0])fd.append('image',$('#image')[0].files[0]);$.ajax({url:'${pageContext.request.contextPath}/api/donor/add',method:'POST',data:fd,processData:false,contentType:false,success:function(){closeDonateModal();$('#donateForm')[0].reset();loadDonorData();alert('Donated! Pending approval.');},error:function(){alert('Error');}});});
  function deleteResource(id){if(confirm('Delete?')){$.ajax({url:'${pageContext.request.contextPath}/api/donor/delete/'+id,method:'DELETE',success:function(){loadDonorData();alert('Deleted');}});}}
  $(document).ready(loadDonorData);
  $('.modal').click(function(e){if(e.target===this)$(this).hide();});
</script>
</body>
</html>