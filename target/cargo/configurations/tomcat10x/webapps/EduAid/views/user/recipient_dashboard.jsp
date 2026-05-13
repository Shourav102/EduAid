<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recipient Dashboard – EduAid</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .dashboard-stats {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
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
            cursor: pointer;
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

        .resource-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-top: 1rem;
        }
        .resource-card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }
        .resource-card:hover { transform: translateY(-5px); box-shadow: 0 12px 28px rgba(0,0,0,0.12); }
        .resource-title { font-size: 1.1rem; font-weight: 700; color: #1a6b4a; margin-bottom: 0.5rem; }

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
            max-width: 700px;
            width: 90%;
            border-radius: 20px;
            padding: 2rem;
            max-height: 85vh;
            overflow-y: auto;
        }
        .empty-state { text-align: center; padding: 3rem; background: #f8faf9; border-radius: 16px; color: #666; }
        .empty-state i { font-size: 3rem; color: #1a6b4a; margin-bottom: 1rem; display: block; }
        .badge-approved { background: #e8f5ee; color: #1a6b4a; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.8rem; display: inline-block; }
        .btn-sm { padding: 0.3rem 0.8rem; font-size: 0.75rem; border-radius: 6px; }
        .btn-primary { background: #1a6b4a; color: white; border: none; cursor: pointer; }
        .btn-primary:hover { background: #134d35; }
        .btn-outline { background: transparent; border: 1.5px solid #1a6b4a; color: #1a6b4a; cursor: pointer; }
        .btn-outline:hover { background: #e8f5ee; }
        .btn-danger { background: #c0392b; color: white; border: none; cursor: pointer; }
        .wishlist-item { border-bottom: 1px solid #e2e8e6; padding: 1rem; }
        .file-viewer-modal .modal-content { max-width: 900px; width: 95%; }
        .file-viewer { text-align: center; }
        .file-viewer img { max-width: 100%; max-height: 70vh; border-radius: 8px; }
        .file-viewer iframe { width: 100%; height: 70vh; border: none; border-radius: 8px; }

        @media (max-width: 768px) {
            .dashboard-stats { grid-template-columns: 1fr; }
            .action-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<jsp:include page="/views/common/navbar.jsp" />

<main>
    <div class="container">
        <div class="page-header">
            <h1><i class="fas fa-graduation-cap"></i> Recipient Dashboard</h1>
            <p>Welcome back, ${sessionScope.userName}! Find resources or request what you need.</p>
        </div>

        <!-- Stats Cards -->
        <div class="dashboard-stats">
            <div class="stat-card" onclick="showMyWishlist()">
                <div class="stat-number" id="wishlistCount">0</div>
                <div class="stat-label"><i class="fas fa-heart"></i> My Wishlist Items</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" id="totalResources">0</div>
                <div class="stat-label"><i class="fas fa-box-open"></i> Available Resources</div>
            </div>
        </div>

        <!-- Quick Action Cards -->
        <div class="action-grid">
            <div class="action-card" onclick="location.href='${pageContext.request.contextPath}/user/browse'">
                <i class="fas fa-search action-icon"></i>
                <h3>Browse Resources</h3>
                <p>Find and download</p>
            </div>
            <div class="action-card" onclick="openCreateWishlistModal()">
                <i class="fas fa-plus-circle action-icon"></i>
                <h3>Create Wishlist Item</h3>
                <p>Request specific resources</p>
            </div>
            <div class="action-card" onclick="location.href='${pageContext.request.contextPath}/user/profile'">
                <i class="fas fa-user-circle action-icon"></i>
                <h3>My Profile</h3>
                <p>Update your info</p>
            </div>
        </div>

        <!-- Available Resources Preview -->
        <h3><i class="fas fa-box-open"></i> Available Resources for You</h3>
        <div id="resourcesContainer"><div style="text-align:center; padding:2rem;"><i class="fas fa-spinner fa-spin"></i> Loading...</div></div>
    </div>
</main>

<!-- Create Wishlist Modal -->
<div id="createWishlistModal" class="modal">
    <div class="modal-content">
        <h3><i class="fas fa-plus-circle"></i> Request a Resource</h3>
        <form id="createWishlistForm">
            <div class="form-group"><label>Resource Title *</label><input type="text" id="wishlistTitle" class="form-control" required></div>
            <div class="form-group"><label>Description</label><textarea id="wishlistDescription" class="form-control" rows="3"></textarea></div>
            <div class="form-group">
                <label>Category</label>
                <select id="wishlistCategoryId" class="form-control">
                    <option value="">Select Category</option>
                    <c:forEach var="cat" items="${categories}"><option value="${cat.categoryId}">${cat.name}</option></c:forEach>
                </select>
            </div>
            <div style="display:flex; gap:1rem;"><button type="submit" class="btn btn-primary">Add</button><button type="button" onclick="closeCreateWishlistModal()" class="btn btn-outline">Cancel</button></div>
        </form>
    </div>
</div>

<!-- My Wishlist Modal -->
<div id="myWishlistModal" class="modal">
    <div class="modal-content">
        <h3><i class="fas fa-heart"></i> My Wishlist</h3>
        <div id="myWishlistList" style="max-height:400px; overflow-y:auto;"><p>Loading...</p></div>
        <button class="btn btn-outline" onclick="closeMyWishlistModal()">Close</button>
    </div>
</div>

<!-- File Viewer Modal -->
<div id="fileViewerModal" class="modal file-viewer-modal">
    <div class="modal-content">
        <h3 id="fileViewerTitle"><i class="fas fa-file"></i> Resource Viewer</h3>
        <div id="fileViewerContent" class="file-viewer"><p>Loading...</p></div>
        <div style="display:flex; gap:1rem; justify-content:flex-end;"><button class="btn btn-primary" onclick="downloadCurrentFile()">Download</button><button class="btn btn-outline" onclick="closeFileViewer()">Close</button></div>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    let currentFilePath='',currentFileName='';
    function loadRecipientData(){
        $.ajax({url:'${pageContext.request.contextPath}/api/recipient/stats',success:function(d){$('#wishlistCount').text(d.wishlistCount||0);}});
        $.ajax({url:'${pageContext.request.contextPath}/api/resources/available',success:function(d){
                $('#totalResources').text(d?d.length:0);
                let h='';
                if(!d||d.length===0) h='<div class="empty-state"><i class="fas fa-box-open"></i><h3>No Resources Available</h3><p>Please check back later.</p></div>';
                else{h='<div class="resource-grid">';
                    d.forEach(function(r){
                        let vb=(r.imagePath&&r.imagePath!=='null')?'<button onclick="viewFile(\''+r.imagePath+'\',\''+escapeHtml(r.title)+'\')" class="btn btn-outline btn-sm"><i class="fas fa-eye"></i> View</button>':'';
                        h+='<div class="resource-card"><div class="resource-title">'+escapeHtml(r.title)+'</div><p>'+escapeHtml(r.description||'')+'</p><div class="badge-approved">'+r.conditionType+'</div><div style="margin-top:1rem; display:flex; gap:0.5rem;"><button onclick="downloadResource('+r.resourceId+')" class="btn btn-primary btn-sm">Download</button>'+vb+'</div></div>';
                    });h+='</div>';
                }$('#resourcesContainer').html(h);
            }});
    }
    function viewFile(p,t){currentFilePath=p;currentFileName=t;$('#fileViewerTitle').html('<i class="fas fa-file"></i> '+escapeHtml(t));let ext=p.split('.').pop().toLowerCase();let v='';if(['jpg','jpeg','png','gif','webp'].includes(ext)) v='<img src="${pageContext.request.contextPath}/'+p+'">';else if(ext==='pdf') v='<iframe src="${pageContext.request.contextPath}/'+p+'"></iframe>';else v='<div style="padding:3rem;"><i class="fas fa-file-alt"></i><p>Preview not available.</p></div>';$('#fileViewerContent').html(v);$('#fileViewerModal').css('display','flex');}
    function downloadCurrentFile(){if(currentFilePath){var a=document.createElement('a');a.href='${pageContext.request.contextPath}/'+currentFilePath;a.download=currentFileName;document.body.appendChild(a);a.click();document.body.removeChild(a);}}
    function closeFileViewer(){$('#fileViewerModal').css('display','none');$('#fileViewerContent').html('<p>Loading...</p>');currentFilePath='';currentFileName='';}
    function downloadResource(id){$.ajax({url:'${pageContext.request.contextPath}/api/resources/download/'+id,success:function(r){if(r.success&&r.filePath){var a=document.createElement('a');a.href='${pageContext.request.contextPath}/'+r.filePath;a.download=r.title;document.body.appendChild(a);a.click();document.body.removeChild(a);alert('Download started!');}else alert(r.error||'No file');}});}
    function showMyWishlist(){$('#myWishlistModal').css('display','flex');$.ajax({url:'${pageContext.request.contextPath}/api/wishlist/my',success:function(d){let h='';if(!d||d.length===0) h='<div class="empty-state"><i class="fas fa-heart"></i><p>Your wishlist is empty.</p></div>';else{h='<div>';d.forEach(function(i){h+='<div class="wishlist-item"><strong style="color:#1a6b4a;">'+escapeHtml(i.title)+'</strong><br>'+escapeHtml(i.description||'')+'<br><button onclick="deleteWishlistItem('+i.wishlistId+')" class="btn btn-danger btn-sm">Remove</button></div>';});h+='</div>';}$('#myWishlistList').html(h);}});}
    function openCreateWishlistModal(){$('#createWishlistModal').css('display','flex');}
    function closeCreateWishlistModal(){$('#createWishlistModal').css('display','none');}
    function closeMyWishlistModal(){$('#myWishlistModal').css('display','none');}
    function deleteWishlistItem(id){if(confirm('Remove?')){$.ajax({url:'${pageContext.request.contextPath}/api/wishlist/delete',method:'POST',data:{wishlistId:id},success:function(){showMyWishlist();loadRecipientData();alert('Removed');}});}}
    $('#createWishlistForm').on('submit',function(e){e.preventDefault();$.ajax({url:'${pageContext.request.contextPath}/api/wishlist/create',method:'POST',data:{title:$('#wishlistTitle').val(),description:$('#wishlistDescription').val(),categoryId:$('#wishlistCategoryId').val()},success:function(){closeCreateWishlistModal();$('#createWishlistForm')[0].reset();loadRecipientData();alert('Added to wishlist!');},error:function(){alert('Error');}});});
    function escapeHtml(s){if(!s)return '';return s.replace(/[&<>]/g,function(m){if(m==='&')return '&amp;';if(m==='<')return '&lt;';if(m==='>')return '&gt;';return m;});}
    $(document).ready(loadRecipientData);
    $('.modal').click(function(e){if(e.target===this)$(this).hide();});
</script>
</body>
</html>