<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile – EduAid</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .profile-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .profile-card {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border: 1px solid #e2e8e6;
        }
        .profile-header {
            text-align: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #e8f5ee;
        }
        .profile-avatar {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #1a6b4a, #0d4d33);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 3rem;
            color: white;
        }
        .profile-field {
            margin-bottom: 1.5rem;
        }
        .profile-label {
            font-size: 0.8rem;
            font-weight: 600;
            color: #718096;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.25rem;
        }
        .profile-value {
            font-size: 1rem;
            color: #1a1e23;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e2e8e6;
        }
        .profile-value.editable {
            background: #f8faf9;
            padding: 0.5rem;
            border-radius: 8px;
            border: 1px solid #e2e8e6;
        }
        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1.5px solid #e2e8e6;
            border-radius: 10px;
            font-size: 0.95rem;
        }
        .form-control:focus {
            border-color: #1a6b4a;
            outline: none;
            box-shadow: 0 0 0 3px rgba(26,107,74,0.1);
        }
        .readonly-field {
            background: #f0f0f0;
            color: #666;
            padding: 0.75rem;
            border-radius: 10px;
            border: 1px solid #e2e8e6;
        }
        .btn-group {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
            justify-content: flex-end;
        }
        .btn-edit {
            background: #f4a226;
            color: #1a1a1a;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-edit:hover {
            background: #e09520;
            transform: translateY(-2px);
        }
        .btn-save {
            background: #1a6b4a;
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-save:hover {
            background: #134d35;
            transform: translateY(-2px);
        }
        .btn-cancel {
            background: #e2e8e6;
            color: #4a5568;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-cancel:hover {
            background: #cbd5e0;
        }
        .alert-success {
            background: #e8f5ee;
            color: #1a6b4a;
            padding: 0.75rem 1rem;
            border-radius: 10px;
            margin-bottom: 1rem;
        }
        .alert-error {
            background: #fdf0ef;
            color: #c0392b;
            padding: 0.75rem 1rem;
            border-radius: 10px;
            margin-bottom: 1rem;
        }
        .info-note {
            background: #e8f4fd;
            color: #0c5460;
            padding: 0.75rem 1rem;
            border-radius: 10px;
            margin-bottom: 1rem;
            font-size: 0.85rem;
        }
        @media (max-width: 768px) {
            .profile-card { padding: 1.5rem; }
            .btn-group { flex-direction: column; }
            .btn-group button { width: 100%; }
        }
    </style>
</head>
<body>

<jsp:include page="/views/common/navbar.jsp" />

<main>
    <div class="container profile-container">

        <div class="page-header">
            <h1><i class="fas fa-user-circle"></i> My Profile</h1>
            <p>View and manage your account information</p>
        </div>

        <div class="profile-card">
            <div class="profile-header">
                <div class="profile-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <h2>${sessionScope.userName}</h2>
                <p class="profile-role" style="color: #1a6b4a; font-weight: 600;">
                    <i class="fas fa-tag"></i> ${sessionScope.userRole}
                </p>
            </div>

            <div id="messageArea"></div>

            <div class="info-note">
                <i class="fas fa-info-circle"></i> Email address cannot be changed. Contact admin for email updates.
            </div>

            <!-- View Mode -->
            <div id="viewMode">
                <div class="profile-field">
                    <div class="profile-label"><i class="fas fa-user"></i> Full Name</div>
                    <div class="profile-value" id="displayFullName">${sessionScope.loggedInUser.fullName}</div>
                </div>
                <div class="profile-field">
                    <div class="profile-label"><i class="fas fa-envelope"></i> Email Address</div>
                    <div class="readonly-field">${sessionScope.loggedInUser.email} <span style="font-size:0.75rem; color:#999;">(cannot be changed)</span></div>
                </div>
                <div class="profile-field">
                    <div class="profile-label"><i class="fas fa-phone"></i> Phone Number</div>
                    <div class="profile-value" id="displayPhone">${sessionScope.loggedInUser.phone}</div>
                </div>
                <div class="profile-field">
                    <div class="profile-label"><i class="fas fa-building"></i> Institution</div>
                    <div class="profile-value" id="displayInstitution">${sessionScope.loggedInUser.institution}</div>
                </div>
                <div class="profile-field">
                    <div class="profile-label"><i class="fas fa-map-marker-alt"></i> Address</div>
                    <div class="profile-value" id="displayAddress">${sessionScope.loggedInUser.address}</div>
                </div>
                <div class="profile-field">
                    <div class="profile-label"><i class="fas fa-calendar-alt"></i> Member Since</div>
                    <div class="profile-value">${sessionScope.loggedInUser.createdAt}</div>
                </div>
                <div class="btn-group">
                    <button class="btn-edit" onclick="enableEditMode()">
                        <i class="fas fa-edit"></i> Edit Profile
                    </button>
                </div>
            </div>

            <!-- Edit Mode (Hidden by default) -->
            <div id="editMode" style="display: none;">
                <form id="profileForm">
                    <div class="profile-field">
                        <label class="profile-label"><i class="fas fa-user"></i> Full Name *</label>
                        <input type="text" id="editFullName" class="form-control" value="${sessionScope.loggedInUser.fullName}" required>
                    </div>
                    <div class="profile-field">
                        <label class="profile-label"><i class="fas fa-envelope"></i> Email Address</label>
                        <div class="readonly-field">${sessionScope.loggedInUser.email} <span style="font-size:0.75rem; color:#999;">(cannot be changed)</span></div>
                    </div>
                    <div class="profile-field">
                        <label class="profile-label"><i class="fas fa-phone"></i> Phone Number *</label>
                        <input type="tel" id="editPhone" class="form-control" value="${sessionScope.loggedInUser.phone}" required pattern="[0-9]{10}" title="10 digit number">
                    </div>
                    <div class="profile-field">
                        <label class="profile-label"><i class="fas fa-building"></i> Institution</label>
                        <input type="text" id="editInstitution" class="form-control" value="${sessionScope.loggedInUser.institution}">
                    </div>
                    <div class="profile-field">
                        <label class="profile-label"><i class="fas fa-map-marker-alt"></i> Address</label>
                        <textarea id="editAddress" class="form-control" rows="2">${sessionScope.loggedInUser.address}</textarea>
                    </div>
                    <div class="btn-group">
                        <button type="submit" class="btn-save"><i class="fas fa-save"></i> Save Changes</button>
                        <button type="button" class="btn-cancel" onclick="disableEditMode()"><i class="fas fa-times"></i> Cancel</button>
                    </div>
                </form>
            </div>

            <!-- Change Password Section -->
            <div style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #e2e8e6;">
                <h3><i class="fas fa-key"></i> Change Password</h3>
                <p style="font-size: 0.85rem; color: #666; margin-bottom: 1rem;">Update your password regularly to keep your account secure.</p>

                <div id="passwordMessage"></div>

                <form id="passwordForm">
                    <div class="profile-field">
                        <label class="profile-label">Current Password *</label>
                        <input type="password" id="currentPassword" class="form-control" required>
                    </div>
                    <div class="profile-field">
                        <label class="profile-label">New Password *</label>
                        <input type="password" id="newPassword" class="form-control" required>
                        <small style="color: #666;">Min 8 chars, 1 uppercase, 1 lowercase, 1 number, 1 special character</small>
                    </div>
                    <div class="profile-field">
                        <label class="profile-label">Confirm New Password *</label>
                        <input type="password" id="confirmPassword" class="form-control" required>
                    </div>
                    <button type="submit" class="btn-save" style="background: #f4a226; color:#1a1a1a;">
                        <i class="fas fa-key"></i> Update Password
                    </button>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function enableEditMode() {
        document.getElementById('viewMode').style.display = 'none';
        document.getElementById('editMode').style.display = 'block';
    }

    function disableEditMode() {
        document.getElementById('viewMode').style.display = 'block';
        document.getElementById('editMode').style.display = 'none';
        document.getElementById('messageArea').innerHTML = '';
    }

    function showMessage(type, message) {
        var msgDiv = document.getElementById('messageArea');
        msgDiv.innerHTML = '<div class="alert-' + type + '"><i class="fas ' +
            (type === 'success' ? 'fa-check-circle' : 'fa-exclamation-triangle') + '"></i> ' + message + '</div>';
        if (type === 'success') {
            setTimeout(function() {
                msgDiv.innerHTML = '';
            }, 3000);
        }
    }

    function showPasswordMessage(type, message) {
        var msgDiv = document.getElementById('passwordMessage');
        msgDiv.innerHTML = '<div class="alert-' + type + '"><i class="fas ' +
            (type === 'success' ? 'fa-check-circle' : 'fa-exclamation-triangle') + '"></i> ' + message + '</div>';
        if (type === 'success') {
            setTimeout(function() {
                msgDiv.innerHTML = '';
                document.getElementById('passwordForm').reset();
            }, 3000);
        }
    }

    // Update Profile
    $('#profileForm').on('submit', function(e) {
        e.preventDefault();

        var phone = $('#editPhone').val();
        if (!/^[0-9]{10}$/.test(phone)) {
            showMessage('error', 'Phone number must be exactly 10 digits');
            return;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/api/user/profile/update',
            method: 'POST',
            data: {
                fullName: $('#editFullName').val(),
                phone: phone,
                address: $('#editAddress').val(),
                institution: $('#editInstitution').val()
            },
            success: function(response) {
                if (response.success) {
                    // Update displayed values
                    document.getElementById('displayFullName').innerText = $('#editFullName').val();
                    document.getElementById('displayPhone').innerText = phone;
                    document.getElementById('displayInstitution').innerText = $('#editInstitution').val();
                    document.getElementById('displayAddress').innerText = $('#editAddress').val();

                    // Update session username in navbar (will reflect on next page load)
                    showMessage('success', 'Profile updated successfully!');
                    disableEditMode();

                    // Reload page after 1 second to refresh navbar
                    setTimeout(function() {
                        location.reload();
                    }, 1500);
                } else {
                    showMessage('error', response.error || 'Error updating profile');
                }
            },
            error: function() {
                showMessage('error', 'Server error. Please try again.');
            }
        });
    });

    // Change Password
    $('#passwordForm').on('submit', function(e) {
        e.preventDefault();

        var currentPwd = $('#currentPassword').val();
        var newPwd = $('#newPassword').val();
        var confirmPwd = $('#confirmPassword').val();

        if (!currentPwd || !newPwd || !confirmPwd) {
            showPasswordMessage('error', 'All password fields are required');
            return;
        }

        if (newPwd !== confirmPwd) {
            showPasswordMessage('error', 'New passwords do not match');
            return;
        }

        // Password strength validation
        var strongRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$/;
        if (!strongRegex.test(newPwd)) {
            showPasswordMessage('error', 'Password must have 8+ chars, uppercase, lowercase, number, and special character');
            return;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/api/user/password/change',
            method: 'POST',
            data: {
                currentPassword: currentPwd,
                newPassword: newPwd
            },
            success: function(response) {
                if (response.success) {
                    showPasswordMessage('success', 'Password changed successfully!');
                    $('#passwordForm')[0].reset();
                } else {
                    showPasswordMessage('error', response.error || 'Error changing password');
                }
            },
            error: function(xhr) {
                var errorMsg = 'Error changing password';
                try {
                    var resp = JSON.parse(xhr.responseText);
                    if (resp.error) errorMsg = resp.error;
                } catch(e) {}
                showPasswordMessage('error', errorMsg);
            }
        });
    });
</script>
</body>
</html>