<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../fragments/layout.jsp">
        <jsp:param name="title" value="Quản lý Nhà hàng - Menu Online"/>
    </jsp:include>
</head>
<body>
<%@ include file="../fragments/navbar.jsp" %>

<div class="main-layout">
    <!-- Sidebar - Chỉ ADMIN mới có trang này -->
    <aside class="sidebar">
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/dashboard">
                <span class="icon">📊</span>
                <span>Dashboard</span>
            </a></li>
            <li><a href="${pageContext.request.contextPath}/manage/restaurants" class="active">
                <span class="icon">🏪</span>
                <span>Nhà hàng</span>
            </a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">
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
            <div>
                <h1>🏪 Quản lý Nhà hàng</h1>
                <p>Quản lý tất cả nhà hàng trong hệ thống</p>
            </div>
            <a href="${pageContext.request.contextPath}/manage/restaurants/new" class="btn btn-primary">
                ➕ Thêm nhà hàng mới
            </a>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <!-- Empty State -->
        <c:if test="${empty restaurants}">
            <div class="empty-state">
                <div class="empty-icon">🏪</div>
                <h3>Chưa có nhà hàng nào</h3>
                <p>Hãy thêm nhà hàng đầu tiên vào hệ thống</p>
                <a href="${pageContext.request.contextPath}/manage/restaurants/new" class="btn btn-primary">Thêm nhà hàng</a>
            </div>
        </c:if>

        <!-- Restaurants Table -->
        <c:if test="${not empty restaurants}">
            <div class="table-card">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Logo</th>
                            <th>Tên nhà hàng</th>
                            <th>Địa chỉ</th>
                            <th>Chủ nhà hàng</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="restaurant" items="${restaurants}">
                            <tr>
                                <td>
                                    <c:if test="${not empty restaurant.logo}">
                                        <img src="${pageContext.request.contextPath}${restaurant.logo}"
                                             alt="Logo"
                                             class="table-logo"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                    </c:if>
                                    <div class="table-logo-placeholder">🏪</div>
                                </td>
                                <td>
                                    <strong>${restaurant.name}</strong>
                                </td>
                                <td>${restaurant.address}</td>
                                <td>
                                    <span class="owner-badge">${restaurant.owner.fullName}</span>
                                </td>
                                <td>
                                    <span class="status-badge ${restaurant.isActive ? 'status-active' : 'status-inactive'}">
                                        ${restaurant.isActive ? '● Hoạt động' : '● Tạm ngừng'}
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <form action="${pageContext.request.contextPath}/manage/restaurants/toggle-status/${restaurant.id}"
                                              method="post"
                                              style="display: inline;">
                                            <c:if test="${not empty _csrf}">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            </c:if>
                                            <button type="submit" 
                                                    class="btn-action ${restaurant.isActive ? 'btn-warning' : 'btn-success'}" 
                                                    title="${restaurant.isActive ? 'Tạm ngừng' : 'Kích hoạt'}">
                                                ${restaurant.isActive ? '⏸️ Tạm ngừng' : '▶️ Kích hoạt'}
                                            </button>
                                        </form>
                                        <a href="${pageContext.request.contextPath}/manage/restaurants/edit/${restaurant.id}"
                                           class="btn-action btn-edit" title="Chỉnh sửa">
                                            ✏️ Sửa
                                        </a>
                                        <form action="${pageContext.request.contextPath}/manage/restaurants/delete/${restaurant.id}"
                                              method="post"
                                              style="display: inline;"
                                              onsubmit="return confirm('Bạn có chắc muốn xóa nhà hàng này?');">
                                            <c:if test="${not empty _csrf}">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            </c:if>
                                            <button type="submit" class="btn-action btn-delete" title="Xóa">
                                                🗑️ Xóa
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </main>
</div>

<style>
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 30px;
    }

    /* Empty State */
    .empty-state {
        text-align: center;
        padding: 80px 20px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }

    .empty-icon {
        font-size: 100px;
        margin-bottom: 25px;
        opacity: 0.5;
    }

    .empty-state h3 {
        font-size: 24px;
        color: var(--dark);
        margin-bottom: 10px;
    }

    .empty-state p {
        color: var(--gray);
        margin-bottom: 25px;
        font-size: 16px;
    }

    /* Table Card */
    .table-card {
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        overflow: hidden;
    }

    .data-table {
        width: 100%;
        border-collapse: collapse;
    }

    .data-table thead {
        background: linear-gradient(135deg, #87CEEB 0%, #6BB6D6 100%);
        color: white;
    }

    .data-table th,
    .data-table td {
        padding: 16px;
        text-align: left;
    }

    .data-table th {
        font-weight: 600;
        font-size: 14px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .data-table td {
        border-bottom: 1px solid var(--border);
        color: var(--dark);
        font-size: 14px;
    }

    .data-table tbody tr {
    }

    .data-table tbody tr:hover {
        background: var(--light);
    }

    .data-table tbody tr:last-child td {
        border-bottom: none;
    }

    /* Table Logo */
    .table-logo {
        width: 50px;
        height: 50px;
        border-radius: 8px;
        object-fit: cover;
    }

    .table-logo-placeholder {
        width: 50px;
        height: 50px;
        border-radius: 8px;
        background: linear-gradient(135deg, #87CEEB 0%, #6BB6D6 100%);
        display: none;
        align-items: center;
        justify-content: center;
        font-size: 24px;
    }

    /* Badges */
    .owner-badge {
        display: inline-block;
        padding: 4px 12px;
        background: #e3f2fd;
        color: #1565c0;
        border-radius: 12px;
        font-size: 13px;
        font-weight: 500;
    }

    .status-badge {
        display: inline-block;
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
    }

    .status-active {
        background: #d4edda;
        color: #155724;
    }

    .status-inactive {
        background: #f8d7da;
        color: #721c24;
    }

    /* Action Buttons */
    .action-buttons {
        display: flex;
        gap: 8px;
    }

    .btn-action {
        padding: 6px 14px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 12px;
        font-weight: 500;
        text-decoration: none;
        display: inline-block;
    }

    .btn-edit {
        background: #ffc107;
        color: #000;
    }

    .btn-edit:hover {
        background: #ffb300;
    }

    .btn-delete {
        background: #dc3545;
        color: white;
    }

    .btn-delete:hover {
        background: #c82333;
    }

    .btn-warning {
        background: #ff9800;
        color: white;
    }

    .btn-warning:hover {
        background: #f57c00;
    }

    .btn-success {
        background: #10b981;
        color: white;
    }

    .btn-success:hover {
        background: #059669;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .page-header {
            flex-direction: column;
            gap: 15px;
        }

        .data-table {
            font-size: 12px;
        }

        .data-table th,
        .data-table td {
            padding: 12px 8px;
        }

        .table-logo,
        .table-logo-placeholder {
            width: 40px;
            height: 40px;
        }

        .action-buttons {
            flex-direction: column;
        }
    }

    /* Scrollable table on mobile */
    @media (max-width: 600px) {
        .table-card {
            overflow-x: auto;
        }

        .data-table {
            min-width: 600px;
        }
    }
</style>
</body>
</html>

