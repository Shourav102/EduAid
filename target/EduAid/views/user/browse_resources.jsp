<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Browse Resources – EduAid</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .search-bar { margin-bottom: 2rem; }
    .search-bar input {
      width: 100%;
      padding: 1rem;
      font-size: 1rem;
      border: 2px solid #e2e8e6;
      border-radius: 12px;
    }
    .resource-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 1.5rem;
    }
    .resource-card {
      background: white;
      border-radius: 16px;
      padding: 1.5rem;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      transition: all 0.3s ease;
    }
    .resource-card:hover { transform: translateY(-5px); box-shadow: 0 12px 28px rgba(0,0,0,0.15); }
    .resource-title { font-size: 1.2rem; font-weight: 700; color: #1a6b4a; margin-bottom: 0.5rem; }
    .resource-category { display: inline-block; background: #e8f5ee; padding: 0.2rem 0.8rem; border-radius: 20px; font-size: 0.75rem; margin: 0.5rem 0; }
    .button-group { display: flex; gap: 0.5rem; margin-top: 1rem; }
    .empty-state {
      text-align: center;
      padding: 3rem;
      background: #f8faf9;
      border-radius: 16px;
      color: #666;
    }
    .empty-state i { font-size: 3rem; color: #1a6b4a; margin-bottom: 1rem; display: block; }
    .error-state {
      text-align: center;
      padding: 3rem;
      background: #fdf0ef;
      border-radius: 16px;
      color: #c0392b;
    }
    .error-state i { font-size: 3rem; color: #c0392b; margin-bottom: 1rem; display: block; }
  </style>
</head>
<body>

<jsp:include page="/views/common/navbar.jsp" />

<main>
  <div class="container">

    <div class="page-header">
      <h1><i class="fas fa-search"></i> Browse Resources</h1>
      <p>Find educational materials donated by the community</p>
    </div>

    <div class="search-bar">
      <input type="text" id="searchInput" placeholder="🔍 Search by title, description, or category..." onkeyup="filterResources()">
    </div>

    <div id="resourcesContainer">
      <div style="text-align:center; padding:2rem;">
        <i class="fas fa-spinner fa-spin"></i> Loading resources...
      </div>
    </div>

  </div>
</main>

<jsp:include page="/views/common/footer.jsp" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
  let allResources = [];

  function loadResources() {
    $('#resourcesContainer').html('<div style="text-align:center; padding:2rem;"><i class="fas fa-spinner fa-spin"></i> Loading resources...</div>');

    $.ajax({
      url: '${pageContext.request.contextPath}/api/resources/available',
      method: 'GET',
      dataType: 'json',
      success: function(data) {
        console.log('API Response:', data);

        // Check if data is an array
        if (Array.isArray(data)) {
          allResources = data;
          displayResources(data);
        }
        // Check if data has an error
        else if (data && data.error) {
          showError('API Error: ' + data.error);
        }
        // Check if data is empty or null
        else if (!data) {
          showEmptyState();
        }
        // Handle case where data is an object with resources property
        else if (data.resources && Array.isArray(data.resources)) {
          allResources = data.resources;
          displayResources(data.resources);
        }
        else {
          console.error('Unexpected data format:', data);
          showError('Received unexpected data format from server');
        }
      },
      error: function(xhr, status, error) {
        console.error('AJAX Error:', status, error);
        console.error('Response:', xhr.responseText);
        showError('Unable to load resources. Please try again later.');
      }
    });
  }

  function displayResources(resources) {
    if (!resources || resources.length === 0) {
      showEmptyState();
      return;
    }

    let html = '<div class="resource-grid">';
    for (let i = 0; i < resources.length; i++) {
      let r = resources[i];
      html += '<div class="resource-card">' +
              '<div class="resource-title">' + escapeHtml(r.title) + '</div>' +
              '<div class="resource-category"><i class="fas fa-tag"></i> ' + escapeHtml(r.categoryName || 'General') + '</div>' +
              '<p style="color:#666; font-size:0.9rem; margin:0.5rem 0;">' + (escapeHtml(r.description) || 'No description provided') + '</p>' +
              '<div style="display:flex; justify-content:space-between; align-items:center;">' +
              '<span class="badge-approved">' + escapeHtml(r.conditionType) + '</span>' +
              '<span style="font-size:0.8rem; color:#888;"><i class="fas fa-user"></i> ' + escapeHtml(r.donorName) + '</span>' +
              '</div>' +
              '<div class="button-group">' +
              '<button onclick="downloadResource(' + r.resourceId + ')" class="btn btn-primary btn-sm"><i class="fas fa-download"></i> Download</button>' +
              '<button onclick="addToWishlist(' + r.resourceId + ')" class="btn btn-outline btn-sm"><i class="fas fa-heart"></i> Wishlist</button>' +
              '</div>' +
              '</div>';
    }
    html += '</div>';
    $('#resourcesContainer').html(html);
  }

  function showEmptyState() {
    $('#resourcesContainer').html('<div class="empty-state">' +
            '<i class="fas fa-box-open"></i>' +
            '<h3>No Resources Available</h3>' +
            '<p>There are currently no resources available for donation.</p>' +
            '<p>Please check back later or contact donors directly.</p>' +
            '</div>');
  }

  function showError(message) {
    $('#resourcesContainer').html('<div class="error-state">' +
            '<i class="fas fa-exclamation-triangle"></i>' +
            '<h3>Error Loading Resources</h3>' +
            '<p>' + escapeHtml(message) + '</p>' +
            '<button onclick="loadResources()" class="btn btn-primary" style="margin-top:1rem;">Try Again</button>' +
            '</div>');
  }

  function filterResources() {
    let query = $('#searchInput').val().toLowerCase();
    if (!allResources || allResources.length === 0) {
      return;
    }
    let filtered = allResources.filter(function(r) {
      return (r.title && r.title.toLowerCase().includes(query)) ||
              (r.description && r.description.toLowerCase().includes(query)) ||
              (r.categoryName && r.categoryName.toLowerCase().includes(query));
    });
    displayResources(filtered);
  }

  function downloadResource(id) {
    $.ajax({
      url: '${pageContext.request.contextPath}/api/resources/download/' + id,
      method: 'GET',
      success: function(response) {
        if (response.success && response.filePath) {
          // Create a download link
          var link = document.createElement('a');
          link.href = '${pageContext.request.contextPath}/' + response.filePath;
          link.download = response.title || 'resource';
          document.body.appendChild(link);
          link.click();
          document.body.removeChild(link);
          alert('Download started!');
        } else {
          alert('No file available for this resource.');
        }
      },
      error: function() {
        alert('Error downloading resource');
      }
    });
  }

  function addToWishlist(id) {
    $.ajax({
      url: '${pageContext.request.contextPath}/api/wishlist/add',
      method: 'POST',
      data: { resourceId: id },
      success: function(response) {
        console.log('Wishlist add success:', response);
        alert('Added to your wishlist!');
      },
      error: function(xhr, status, error) {
        console.error('Wishlist error:', error);
        alert('Error adding to wishlist');
      }
    });
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

  $(document).ready(function() {
    loadResources();
  });
</script>
</body>
</html>