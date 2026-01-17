<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../fragments/layout.jsp">
        <jsp:param name="title" value="Quản lý Người dùng - Menu Online"/>
    </jsp:include>
</head>
<body>
<%@ include file="../fragments/navbar.jsp" %>

<div class="main-layout">
    <!-- Sidebar -->
    <aside class="sidebar">
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/dashboard">
                <span class="icon">📊</span>
                <span>Dashboard</span>
            </a></li>
            <li><a href="${pageContext.request.contextPath}/manage/restaurants">
                <span class="icon">🏪</span>
                <span>Nhà hàng</span>
            </a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users" class="active">
                <span class="icon">👥</span>
                <span>Người dùng</span>
            </a></li>
            <div class="sidebar-divider"></div>
            <li><a href="${pageContext.request.contextPath}/">
                <span class="icon">🌐</span>
                <span>Trang chủ</span>
            </a></li>
        </ul>
    </aside>

    <!-- Main Content -->
    <main class="content">
        <div class="page-header">
            <h1>👥 Quản lý Người dùng</h1>
            <p>Quản lý tất cả người dùng trong hệ thống</p>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div class="stat-value">${totalUsers}</div>
                <div class="stat-label">Tổng người dùng</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">👑</div>
                <div class="stat-value">${totalAdmins}</div>
                <div class="stat-label">Quản trị viên</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🏪</div>
                <div class="stat-value">${totalMerchants}</div>
                <div class="stat-label">Nhà hàng</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">✅</div>
                <div class="stat-value">${activeUsers}</div>
                <div class="stat-label">Đang hoạt động</div>
            </div>
        </div>

        <!-- Actions Bar -->
        <div class="card">
            <div class="card-header">
                <div>
                    <h2>Danh sách người dùng</h2>
                </div>
                <button class="btn btn-primary" onclick="openAddModal()">➕ Thêm người dùng</button>
            </div>

            <div class="card-body">
                <!-- Search and Filter -->
                <div style="margin-bottom: 24px; display: flex; gap: 16px; flex-wrap: wrap;">
                    <input type="text" id="searchInput" placeholder="🔍 Tìm kiếm theo tên, username, email..." 
                           style="flex: 1; min-width: 250px; padding: 14px 18px; border: 2px solid rgba(0,0,0,0.1); border-radius: 12px; font-size: 15px; transition: all 0.3s; background: rgba(255,255,255,0.8);"
                           onkeyup="filterUsers()"
                           onfocus="this.style.borderColor='#87CEEB'; this.style.boxShadow='0 0 0 4px rgba(135, 206, 235, 0.2)'; this.style.background='white';"
                           onblur="this.style.borderColor='rgba(0,0,0,0.1)'; this.style.boxShadow='none'; this.style.background='rgba(255,255,255,0.8)';">
                    <select id="roleFilter" onchange="filterUsers()" 
                            style="padding: 14px 18px; border: 2px solid rgba(0,0,0,0.1); border-radius: 12px; font-size: 15px; background: rgba(255,255,255,0.8); cursor: pointer; transition: all 0.3s;"
                            onfocus="this.style.borderColor='#87CEEB'; this.style.boxShadow='0 0 0 4px rgba(135, 206, 235, 0.2)'; this.style.background='white';"
                            onblur="this.style.borderColor='rgba(0,0,0,0.1)'; this.style.boxShadow='none'; this.style.background='rgba(255,255,255,0.8)';">
                        <option value="">Tất cả vai trò</option>
                        <option value="ADMIN">Admin</option>
                        <option value="MERCHANT">Merchant</option>
                    </select>
                    <select id="statusFilter" onchange="filterUsers()" 
                            style="padding: 14px 18px; border: 2px solid rgba(0,0,0,0.1); border-radius: 12px; font-size: 15px; background: rgba(255,255,255,0.8); cursor: pointer; transition: all 0.3s;"
                            onfocus="this.style.borderColor='#87CEEB'; this.style.boxShadow='0 0 0 4px rgba(135, 206, 235, 0.2)'; this.style.background='white';"
                            onblur="this.style.borderColor='rgba(0,0,0,0.1)'; this.style.boxShadow='none'; this.style.background='rgba(255,255,255,0.8)';">
                        <option value="">Tất cả trạng thái</option>
                        <option value="true">Đang hoạt động</option>
                        <option value="false">Tạm khóa</option>
                    </select>
                </div>

                <!-- Users Table -->
                <div style="overflow-x: auto;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Username</th>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>SĐT</th>
                                <th>Vai trò</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="usersTableBody">
                            <c:forEach var="u" items="${users}">
                                <tr data-username="${u.username}"
                                    data-fullname="${u.fullName}"
                                    data-email="${u.email}"
                                    data-role="${u.role}"
                                    data-status="${u.status}">
                                    <td>${u.id}</td>
                                    <td>${u.username}</td>
                                    <td>${u.fullName}</td>
                                    <td>${not empty u.email ? u.email : '-'}</td>
                                    <td>${not empty u.phone ? u.phone : '-'}</td>
                                    <td>
                                        <span class="badge ${u.role == 'ADMIN' ? 'badge-primary' : 'badge-info'}">
                                            ${u.role == 'ADMIN' ? '👑 Admin' : '🏪 Merchant'}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge ${u.status ? 'badge-success' : 'badge-danger'}">
                                            ${u.status ? '✅ Hoạt động' : '❌ Khóa'}
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 5px;">
                                            <button class="btn-action btn-edit" 
                                                    data-id="${u.id}"
                                                    data-username="${u.username}"
                                                    data-fullname="${u.fullName}"
                                                    data-email="${not empty u.email ? u.email : ''}"
                                                    data-phone="${not empty u.phone ? u.phone : ''}"
                                                    data-role="${u.role}"
                                                    onclick="openEditModal(this)">
                                                ✏️
                                            </button>
                                            <form action="${pageContext.request.contextPath}/admin/users/toggle-status/${u.id}" 
                                                  method="post" style="display: inline;">
                                                <c:if test="${not empty _csrf}">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                </c:if>
                                                <button type="submit" class="btn-action btn-toggle" 
                                                        title="${u.status ? 'Khóa tài khoản' : 'Kích hoạt tài khoản'}">
                                                    <span>${u.status ? '🔒' : '🔓'}</span>
                                                </button>
                                            </form>
                                            <c:if test="${u.id != user.id}">
                                                <form action="${pageContext.request.contextPath}/admin/users/delete/${u.id}" 
                                                      method="post" 
                                                      style="display: inline;"
                                                      onsubmit="return confirm('Bạn có chắc muốn xóa user này?')">
                                                    <c:if test="${not empty _csrf}">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    </c:if>
                                                    <button type="submit" class="btn-action btn-delete" title="Xóa">
                                                        🗑️
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Add User Modal -->
<div id="addModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>➕ Thêm người dùng mới</h2>
            <button class="modal-close" onclick="closeAddModal()">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/admin/users/add" method="post" accept-charset="UTF-8">
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </c:if>
            <div class="form-group">
                <label>Username <span style="color: red;">*</span></label>
                <input type="text" name="username" required minlength="3" maxlength="50">
            </div>
            <div class="form-group">
                <label>Mật khẩu <span style="color: red;">*</span></label>
                <input type="password" name="password" required minlength="6">
            </div>
            <div class="form-group">
                <label>Họ và tên <span style="color: red;">*</span></label>
                <input type="text" name="fullName" required>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email">
            </div>
            <div class="form-group">
                <label>Số điện thoại</label>
                <input type="tel" name="phone">
            </div>
            <div class="form-group">
                <label>Vai trò <span style="color: red;">*</span></label>
                <select name="role" required>
                    <option value="MERCHANT">Merchant</option>
                    <option value="ADMIN">Admin</option>
                </select>
            </div>
            <div class="form-actions">
                <button type="button" class="btn btn-secondary" onclick="closeAddModal()">Hủy</button>
                <button type="submit" class="btn btn-primary">Thêm</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit User Modal -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>✏️ Sửa thông tin người dùng</h2>
            <button class="modal-close" onclick="closeEditModal()">&times;</button>
        </div>
        <form id="editForm" method="post" accept-charset="UTF-8" onsubmit="return validateEditForm()">
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </c:if>
            <input type="hidden" name="id" id="editId">
            <div class="form-group">
                <label>Username</label>
                <input type="text" id="editUsername" readonly style="background: #f5f5f5; font-weight: 600; color: #1A1F2E;">
            </div>
            <div class="form-group">
                <label>Mật khẩu mới (để trống nếu không đổi)</label>
                <input type="password" name="password" id="editPassword" minlength="6" placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)" style="font-weight: 600; color: #1A1F2E;">
                <small style="color: #6B7280; font-size: 12px; display: block; margin-top: 4px;">Để trống nếu không muốn đổi mật khẩu</small>
            </div>
            <div class="form-group">
                <label>Họ và tên <span style="color: #FF6B6B;">*</span></label>
                <input type="text" name="fullName" id="editFullName" required style="font-weight: 600; color: #1A1F2E;" placeholder="Nhập họ và tên đầy đủ">
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" id="editEmail" style="font-weight: 600; color: #1A1F2E;" placeholder="email@example.com">
            </div>
            <div class="form-group">
                <label>Số điện thoại</label>
                <input type="tel" name="phone" id="editPhone" style="font-weight: 600; color: #1A1F2E;" placeholder="0123456789">
            </div>
            <div class="form-group">
                <label>Vai trò <span style="color: #FF6B6B;">*</span></label>
                <select name="role" id="editRole" required style="font-weight: 600; color: #1A1F2E;">
                    <option value="">-- Chọn vai trò --</option>
                    <option value="MERCHANT">Merchant</option>
                    <option value="ADMIN">Admin</option>
                </select>
            </div>
            <div class="form-actions">
                <button type="button" class="btn btn-secondary" onclick="closeEditModal()">Hủy</button>
                <button type="submit" class="btn btn-primary">Cập nhật</button>
            </div>
        </form>
    </div>
</div>

<style>
    /* Stats Grid */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
        gap: 24px;
        margin-bottom: 32px;
    }

    .stat-card {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        padding: 32px 28px;
        border-radius: 20px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        text-align: center;
        border: 1px solid rgba(255, 255, 255, 0.2);
        position: relative;
        overflow: hidden;
    }

    .stat-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background: linear-gradient(90deg, var(--primary) 0%, var(--primary-dark) 100%);
        transform: scaleX(0);
        transform-origin: left;
        transition: transform 0.4s ease;
    }

    .stat-card:hover {
        transform: translateY(-8px) scale(1.02);
        box-shadow: 0 20px 40px rgba(135, 206, 235, 0.25);
        border-color: rgba(135, 206, 235, 0.4);
    }

    .stat-card:hover::before {
        transform: scaleX(1);
    }

    .stat-icon {
        font-size: 56px;
        margin-bottom: 16px;
        filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.1));
        animation: float 3s ease-in-out infinite;
    }

    @keyframes float {
        0%, 100% { transform: translateY(0px); }
        50% { transform: translateY(-10px); }
    }

    .stat-value {
        font-size: 42px;
        font-weight: 700;
        background: linear-gradient(135deg, #6BB6D6 0%, #87CEEB 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        margin-bottom: 8px;
        line-height: 1;
    }

    .stat-label {
        color: var(--gray);
        font-size: 15px;
        font-weight: 600;
    }

    /* Card */
    .card {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border-radius: 24px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
        overflow: hidden;
        margin-bottom: 32px;
        border: 1px solid rgba(255, 255, 255, 0.2);
        animation: fadeInUp 0.5s ease;
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .card-header {
        padding: 28px 32px;
        background: linear-gradient(135deg, #87CEEB 0%, #6BB6D6 100%);
        color: white;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 4px 16px rgba(135, 206, 235, 0.3);
    }

    .card-header h2 {
        font-size: 24px;
        font-weight: 700;
        margin: 0;
    }

    .card-body {
        padding: 32px;
        background: rgba(255, 255, 255, 0.5);
    }

    /* Table */
    .data-table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
    }

    .data-table th {
        background: linear-gradient(135deg, rgba(135, 206, 235, 0.15) 0%, rgba(107, 182, 214, 0.1) 100%);
        padding: 16px;
        text-align: left;
        font-weight: 600;
        font-size: 14px;
        color: var(--dark);
        text-transform: uppercase;
        letter-spacing: 0.5px;
        border-bottom: 2px solid rgba(135, 206, 235, 0.3);
    }

    .data-table th:first-child {
        border-top-left-radius: 12px;
    }

    .data-table th:last-child {
        border-top-right-radius: 12px;
    }

    .data-table td {
        padding: 16px;
        border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        transition: all 0.2s ease;
    }

    .data-table tr {
        transition: all 0.2s ease;
    }

    .data-table tr:hover {
        background: linear-gradient(90deg, rgba(135, 206, 235, 0.1) 0%, transparent 100%);
        transform: scale(1.01);
    }

    .data-table tr:last-child td:first-child {
        border-bottom-left-radius: 12px;
    }

    .data-table tr:last-child td:last-child {
        border-bottom-right-radius: 12px;
    }

    /* Badge */
    .badge {
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        display: inline-block;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        transition: all 0.3s ease;
    }

    .badge:hover {
        transform: scale(1.05);
    }

    .badge-primary {
        background: linear-gradient(135deg, #87CEEB 0%, #6BB6D6 100%);
        color: white;
        box-shadow: 0 2px 8px rgba(135, 206, 235, 0.3);
    }

    .badge-info {
        background: linear-gradient(135deg, #6BCAE2 0%, #5FB3D3 100%);
        color: white;
        box-shadow: 0 2px 8px rgba(107, 202, 226, 0.3);
    }

    .badge-success {
        background: linear-gradient(135deg, #4ECDC4 0%, #44A08D 100%);
        color: white;
        box-shadow: 0 2px 8px rgba(78, 205, 196, 0.3);
    }

    .badge-danger {
        background: linear-gradient(135deg, #FF6B6B 0%, #E55555 100%);
        color: white;
        box-shadow: 0 2px 8px rgba(255, 107, 107, 0.3);
    }

    /* Buttons */
    .btn-action {
        padding: 8px 16px;
        border: none;
        border-radius: 10px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }

    .btn-edit {
        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
        color: white;
    }

    .btn-toggle {
        background: linear-gradient(135deg, #6BCAE2 0%, #5FB3D3 100%);
        color: white;
    }

    .btn-delete {
        background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
        color: white;
    }

    .btn-action:hover {
        transform: translateY(-3px) scale(1.05);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
    }

    .btn-action:active {
        transform: translateY(-1px) scale(1.02);
    }

    /* Modal */
    .modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.6);
        backdrop-filter: blur(8px);
        -webkit-backdrop-filter: blur(8px);
        z-index: 2000;
        align-items: center;
        justify-content: center;
        animation: fadeIn 0.3s ease;
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    .modal.active {
        display: flex;
    }

    .modal-content {
        background: rgba(255, 255, 255, 0.98);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border-radius: 24px;
        width: 90%;
        max-width: 520px;
        max-height: 90vh;
        overflow-y: auto;
        animation: slideUp 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        border: 1px solid rgba(255, 255, 255, 0.2);
    }

    @keyframes slideUp {
        from {
            opacity: 0;
            transform: translateY(60px) scale(0.9);
        }
        to {
            opacity: 1;
            transform: translateY(0) scale(1);
        }
    }

    .modal-header {
        padding: 24px 28px;
        background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
        color: white;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-radius: 24px 24px 0 0;
        box-shadow: 0 4px 16px rgba(135, 206, 235, 0.3);
    }

    .modal-header h2 {
        margin: 0;
        font-size: 22px;
        font-weight: 700;
    }

    .modal-close {
        background: rgba(255, 255, 255, 0.2);
        border: none;
        color: white;
        font-size: 24px;
        cursor: pointer;
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        transition: all 0.3s ease;
    }

    .modal-close:hover {
        background: rgba(255, 255, 255, 0.3);
        transform: rotate(90deg) scale(1.1);
    }

    .form-group {
        margin-bottom: 20px;
        padding: 0 25px;
    }

    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #1A1F2E;
    }

    .form-group input,
    .form-group select {
        width: 100%;
        padding: 14px 16px;
        border: 2px solid rgba(0, 0, 0, 0.1);
        border-radius: 12px;
        font-size: 15px;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        background: rgba(255, 255, 255, 0.8);
    }

    .form-group input:focus,
    .form-group select:focus {
        outline: none;
        border-color: var(--primary);
        box-shadow: 0 0 0 4px rgba(135, 206, 235, 0.2);
        background: white;
        transform: translateY(-2px);
    }

    .form-actions {
        padding: 20px 25px;
        border-top: 1px solid #e0e0e0;
        display: flex;
        gap: 10px;
        justify-content: flex-end;
    }

    .btn {
        padding: 10px 20px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: 600;
        transition: all 0.3s;
    }

    .btn-primary {
        background: linear-gradient(135deg, #87CEEB 0%, #6BB6D6 100%);
        color: white;
    }

    .btn-secondary {
        background: #6c757d;
        color: white;
    }

    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }
</style>

<script>
    // Modal functions
    function openAddModal() {
        document.getElementById('addModal').classList.add('active');
    }

    function closeAddModal() {
        document.getElementById('addModal').classList.remove('active');
    }

    function openEditModal(btn) {
        const id = btn.dataset.id;
        const username = btn.dataset.username || '';
        const fullname = btn.dataset.fullname || '';
        const email = btn.dataset.email || '';
        const phone = btn.dataset.phone || '';
        const role = btn.dataset.role || 'MERCHANT';
        
        if (!id) {
            alert('Không tìm thấy ID người dùng!');
            return;
        }
        
        // Set form values
        document.getElementById('editId').value = id;
        document.getElementById('editUsername').value = username;
        document.getElementById('editFullName').value = fullname;
        document.getElementById('editEmail').value = email;
        document.getElementById('editPhone').value = phone;
        document.getElementById('editRole').value = role;
        document.getElementById('editPassword').value = ''; // Clear password field
        
        // Update form action
        const form = document.getElementById('editForm');
        const contextPath = '${pageContext.request.contextPath}';
        form.action = contextPath + '/admin/users/edit/' + id;
        
        console.log('Edit form action set to:', form.action);
        
        document.getElementById('editModal').classList.add('active');
    }

    function closeEditModal() {
        document.getElementById('editModal').classList.remove('active');
        // Reset form
        document.getElementById('editForm').reset();
    }
    
    function validateEditForm() {
        const fullName = document.getElementById('editFullName').value.trim();
        const role = document.getElementById('editRole').value;
        const password = document.getElementById('editPassword').value;
        
        if (!fullName) {
            alert('Vui lòng nhập họ và tên!');
            document.getElementById('editFullName').focus();
            return false;
        }
        
        if (!role) {
            alert('Vui lòng chọn vai trò!');
            document.getElementById('editRole').focus();
            return false;
        }
        
        if (password && password.length < 6) {
            alert('Mật khẩu phải có ít nhất 6 ký tự!');
            document.getElementById('editPassword').focus();
            return false;
        }
        
        return true;
    }

    // Filter users
    function filterUsers() {
        const search = document.getElementById('searchInput').value.toLowerCase();
        const roleFilter = document.getElementById('roleFilter').value;
        const statusFilter = document.getElementById('statusFilter').value;
        const rows = document.querySelectorAll('#usersTableBody tr');

        rows.forEach(row => {
            const username = row.dataset.username.toLowerCase();
            const fullname = row.dataset.fullname.toLowerCase();
            const email = (row.dataset.email || '').toLowerCase();
            const role = row.dataset.role;
            const status = row.dataset.status;

            const matchSearch = !search || 
                username.includes(search) || 
                fullname.includes(search) || 
                email.includes(search);
            const matchRole = !roleFilter || role === roleFilter;
            const matchStatus = !statusFilter || status === statusFilter;

            row.style.display = (matchSearch && matchRole && matchStatus) ? '' : 'none';
        });
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        const addModal = document.getElementById('addModal');
        const editModal = document.getElementById('editModal');
        if (event.target === addModal) {
            closeAddModal();
        }
        if (event.target === editModal) {
            closeEditModal();
        }
    }
</script>
</body>
</html>

