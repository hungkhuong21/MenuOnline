<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../fragments/layout.jsp">
        <jsp:param name="title" value="Quản lý Đơn hàng - Menu Online"/>
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
            <li><a href="${pageContext.request.contextPath}/manage/products?restaurantId=${restaurant.id}">
                <span class="icon">🍔</span>
                <span>Món ăn</span>
            </a></li>
            <li><a href="${pageContext.request.contextPath}/manage/categories?restaurantId=${restaurant.id}">
                <span class="icon">📂</span>
                <span>Danh mục</span>
            </a></li>
            <li><a href="${pageContext.request.contextPath}/orders/manage?restaurantId=${restaurant.id}" class="active">
                <span class="icon">🛒</span>
                <span>Đơn hàng</span>
            </a></li>
            <li><a href="${pageContext.request.contextPath}/manage/statistics?restaurantId=${restaurant.id}">
                <span class="icon">📈</span>
                <span>Thống kê</span>
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
                <h1>🛒 Quản lý Đơn hàng</h1>
                <p>Xem và quản lý tất cả đơn hàng của nhà hàng</p>
            </div>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <!-- Restaurant Info -->
        <div class="info-card" style="margin-bottom: 20px;">
            <span class="info-icon">🏪</span>
            <div>
                <strong>${restaurant.name}</strong>
                <p>${restaurant.address}</p>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">📦</div>
                <div class="stat-value">${totalOrders}</div>
                <div class="stat-label">Tổng đơn</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">⏳</div>
                <div class="stat-value">${pendingOrders}</div>
                <div class="stat-label">Chờ xử lý</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">💰</div>
                <div class="stat-value"><fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0" groupingUsed="true"/></div>
                <div class="stat-label">Doanh thu (đ)</div>
            </div>
        </div>

        <!-- Filter -->
        <div class="card" style="margin-bottom: 20px;">
            <div style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
                <label style="font-weight: 600;">Lọc theo trạng thái:</label>
                <a href="${pageContext.request.contextPath}/orders/manage?restaurantId=${restaurant.id}" 
                   class="btn-filter ${empty selectedStatus ? 'active' : ''}"
                   style="text-decoration: none;">Tất cả</a>
                <a href="${pageContext.request.contextPath}/orders/manage?restaurantId=${restaurant.id}&status=PENDING" 
                   class="btn-filter ${selectedStatus == 'PENDING' ? 'active' : ''}"
                   style="text-decoration: none;">Chờ xác nhận</a>
                <a href="${pageContext.request.contextPath}/orders/manage?restaurantId=${restaurant.id}&status=CONFIRMED" 
                   class="btn-filter ${selectedStatus == 'CONFIRMED' ? 'active' : ''}"
                   style="text-decoration: none;">Đã xác nhận</a>
                <a href="${pageContext.request.contextPath}/orders/manage?restaurantId=${restaurant.id}&status=PREPARING" 
                   class="btn-filter ${selectedStatus == 'PREPARING' ? 'active' : ''}"
                   style="text-decoration: none;">Đang chuẩn bị</a>
                <a href="${pageContext.request.contextPath}/orders/manage?restaurantId=${restaurant.id}&status=READY" 
                   class="btn-filter ${selectedStatus == 'READY' ? 'active' : ''}"
                   style="text-decoration: none;">Sẵn sàng</a>
                <a href="${pageContext.request.contextPath}/orders/manage?restaurantId=${restaurant.id}&status=COMPLETED" 
                   class="btn-filter ${selectedStatus == 'COMPLETED' ? 'active' : ''}"
                   style="text-decoration: none;">Hoàn thành</a>
            </div>
        </div>

        <!-- Orders Table -->
        <div class="card">
            <c:if test="${empty orders}">
                <div class="empty-state">
                    <div class="empty-icon">🛒</div>
                    <h3>Chưa có đơn hàng nào</h3>
                    <p>Đơn hàng sẽ hiển thị ở đây khi khách đặt món</p>
                </div>
            </c:if>

            <c:if test="${not empty orders}">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Khách hàng</th>
                                <th>SĐT</th>
                                <th>Món đã đặt</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Thời gian</th>
                                <th style="text-align: center;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>
                                        <strong>${order.customerName}</strong>
                                    </td>
                                    <td>${order.customerPhone}</td>
                                    <td class="order-items-cell">
                                        <c:if test="${not empty order.items}">
                                            <div class="order-items-list">
                                                <c:forEach var="item" items="${order.items}">
                                                    <div class="order-item-tag">
                                                        <span class="item-name">${not empty item.product ? item.product.name : 'Món không xác định'}</span>
                                                        <span class="item-quantity">x${item.quantity}</span>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                        <c:if test="${empty order.items}">
                                            <span class="no-items">Chưa có món</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <strong style="color: #f5576c;">
                                            <fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0" groupingUsed="true"/> đ
                                        </strong>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.status == 'PENDING'}">
                                                <span class="badge badge-warning">⏳ Chờ xác nhận</span>
                                            </c:when>
                                            <c:when test="${order.status == 'CONFIRMED'}">
                                                <span class="badge badge-info">✅ Đã xác nhận</span>
                                            </c:when>
                                            <c:when test="${order.status == 'PREPARING'}">
                                                <span class="badge badge-primary">👨‍🍳 Đang chuẩn bị</span>
                                            </c:when>
                                            <c:when test="${order.status == 'READY'}">
                                                <span class="badge badge-success">🎉 Sẵn sàng</span>
                                            </c:when>
                                            <c:when test="${order.status == 'COMPLETED'}">
                                                <span class="badge badge-success">✓ Hoàn thành</span>
                                            </c:when>
                                            <c:when test="${order.status == 'CANCELLED'}">
                                                <span class="badge badge-danger">✗ Đã hủy</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty order.createdAt}">
                                                <%
                                                    com.example.API_menu_online.entity.Order order = (com.example.API_menu_online.entity.Order) pageContext.getAttribute("order");
                                                    if (order != null && order.getCreatedAt() != null) {
                                                        java.time.LocalDateTime createdAt = order.getCreatedAt();
                                                        String formatted = String.format("%02d/%02d/%04d %02d:%02d", 
                                                            createdAt.getDayOfMonth(), 
                                                            createdAt.getMonthValue(), 
                                                            createdAt.getYear(),
                                                            createdAt.getHour(),
                                                            createdAt.getMinute());
                                                        out.print(formatted);
                                                    } else {
                                                        out.print("N/A");
                                                    }
                                                %>
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: center; white-space: nowrap;">
                                        <a href="${pageContext.request.contextPath}/orders/${order.id}" 
                                           class="btn btn-sm btn-secondary" style="margin-right: 5px;">
                                            👁️ Xem
                                        </a>
                                        <c:if test="${order.status != 'COMPLETED' && order.status != 'CANCELLED'}">
                                            <select data-order-id="${order.id}" 
                                                    onchange="updateOrderStatus(${order.id}, this.value)"
                                                    class="status-select"
                                                    value="${order.status}">
                                                <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
                                                <option value="CONFIRMED" ${order.status == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                                                <option value="PREPARING" ${order.status == 'PREPARING' ? 'selected' : ''}>Đang chuẩn bị</option>
                                                <option value="READY" ${order.status == 'READY' ? 'selected' : ''}>Sẵn sàng</option>
                                                <option value="COMPLETED" ${order.status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                                                <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Hủy</option>
                                            </select>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>
    </main>
</div>

<script>
    function updateOrderStatus(orderId, status) {
        if (!confirm('Xác nhận thay đổi trạng thái đơn hàng?')) {
            return;
        }

        const form = document.createElement('form');
        form.method = 'POST';
        const contextPath = '${pageContext.request.contextPath}';
        form.action = contextPath + '/orders/' + orderId + '/update-status';
        
        const statusInput = document.createElement('input');
        statusInput.type = 'hidden';
        statusInput.name = 'status';
        statusInput.value = status;
        form.appendChild(statusInput);

        const csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = '_csrf';
        csrfInput.value = document.querySelector('meta[name="_csrf"]')?.content || '';
        form.appendChild(csrfInput);

        document.body.appendChild(form);
        form.submit();
    }

    // Auto-hide alerts
    setTimeout(() => {
        document.querySelectorAll('.alert').forEach(alert => {
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 300);
        });
    }, 5000);
</script>

<style>
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }

    .stat-card {
        background: white;
        padding: 25px;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        text-align: center;
    }

    .stat-icon {
        font-size: 48px;
        margin-bottom: 15px;
    }

    .stat-value {
        font-size: 36px;
        font-weight: bold;
        color: #2c3e50;
        margin-bottom: 8px;
    }

    .stat-label {
        color: #6c757d;
        font-size: 14px;
        text-transform: uppercase;
    }

    .btn-filter {
        padding: 8px 16px;
        background: #f8f9fa;
        border: 2px solid #e0e0e0;
        border-radius: 20px;
        color: #1A1F2E;
        font-size: 14px;
        font-weight: 600;
    }

    .btn-filter:hover {
        border-color: #87CEEB;
        color: #87CEEB;
    }

    .btn-filter.active {
        background: linear-gradient(135deg, #87CEEB 0%, #6BB6D6 100%);
        color: white;
        border-color: transparent;
    }

    .status-select {
        padding: 6px 12px;
        border: 2px solid #e0e0e0;
        border-radius: 8px;
        font-size: 13px;
        cursor: pointer;
    }

    .status-select:focus {
        outline: none;
        border-color: #87CEEB;
    }

    .badge {
        padding: 6px 12px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
    }

    .badge-warning {
        background: #fff3cd;
        color: #856404;
    }

    .badge-info {
        background: #d1ecf1;
        color: #0c5460;
    }

    .badge-primary {
        background: #cfe2ff;
        color: #084298;
    }

    .badge-success {
        background: #d4edda;
        color: #155724;
    }

    .badge-danger {
        background: #f8d7da;
        color: #721c24;
    }

    /* Table Styles */
    .table-responsive {
        overflow-x: auto;
        width: 100%;
    }

    .data-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
    }

    .data-table thead {
        background: linear-gradient(135deg, #87CEEB 0%, #6BB6D6 100%);
        color: white;
    }

    .data-table th {
        padding: 16px 20px;
        text-align: left;
        font-weight: 600;
        font-size: 14px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        border-bottom: 3px solid rgba(255,255,255,0.2);
    }

    .data-table tbody tr {
        border-bottom: 1px solid #e9ecef;
    }

    .data-table tbody tr:hover {
        background: #f8f9fa;
    }

    .data-table td {
        padding: 16px 20px;
        font-size: 14px;
        color: #495057;
        vertical-align: middle;
    }

    .data-table td strong {
        color: #2c3e50;
        font-weight: 600;
    }

    /* Order Items Styles */
    .order-items-cell {
        max-width: 350px;
        min-width: 250px;
    }

    .order-items-list {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .order-item-tag {
        display: inline-flex;
        align-items: center;
        justify-content: space-between;
        gap: 10px;
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        padding: 8px 12px;
        border-radius: 8px;
        font-size: 13px;
        border: 1px solid #dee2e6;
        width: 100%;
    }

    .item-name {
        flex: 1;
        color: #495057;
        font-weight: 600;
        word-break: break-word;
    }

    .item-quantity {
        background: linear-gradient(135deg, #87CEEB 0%, #6BB6D6 100%);
        color: white;
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        min-width: 35px;
        text-align: center;
        white-space: nowrap;
        box-shadow: 0 2px 4px rgba(135, 206, 235, 0.3);
    }

    .no-items {
        color: #6c757d;
        font-style: italic;
        font-size: 13px;
    }

    /* Badge Improvements */
    .badge {
        padding: 8px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        display: inline-block;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    /* Status Select */
    .status-select {
        padding: 8px 14px;
        border: 2px solid #e0e0e0;
        border-radius: 8px;
        font-size: 13px;
        cursor: pointer;
        background: white;
        font-weight: 600;
    }

    .status-select:hover {
        border-color: #87CEEB;
        box-shadow: 0 2px 4px rgba(135, 206, 235, 0.2);
    }

    .status-select:focus {
        outline: none;
        border-color: #87CEEB;
        box-shadow: 0 0 0 3px rgba(135, 206, 235, 0.1);
    }

    /* Action Buttons */
    .data-table .btn {
        padding: 8px 16px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 600;
        text-decoration: none;
        display: inline-block;
    }

    /* Empty State */
    .empty-state {
        text-align: center;
        padding: 60px 20px;
    }

    .empty-icon {
        font-size: 80px;
        opacity: 0.3;
        margin-bottom: 20px;
    }

    .empty-state h3 {
        font-size: 24px;
        color: #495057;
        margin-bottom: 10px;
    }

    .empty-state p {
        color: #6c757d;
        font-size: 16px;
    }
</style>
</body>
</html>

