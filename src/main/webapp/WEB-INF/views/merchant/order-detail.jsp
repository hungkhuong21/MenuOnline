<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../fragments/layout.jsp">
        <jsp:param name="title" value="Chi tiết Đơn hàng - Menu Online"/>
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
            <li><a href="${pageContext.request.contextPath}/orders/manage?restaurantId=${restaurant.id}" class="active">
                <span class="icon">🛒</span>
                <span>Đơn hàng</span>
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
                <h1>📋 Chi tiết Đơn hàng</h1>
                <p>Mã đơn: <strong>${order.orderCode}</strong></p>
            </div>
            <a href="${pageContext.request.contextPath}/orders/manage?restaurantId=${restaurant.id}" class="btn btn-secondary">
                ← Quay lại
            </a>
        </div>

        <!-- Order Info Card -->
        <div class="card" style="margin-bottom: 20px;">
            <div class="card-header">
                <h2>📝 Thông tin đơn hàng</h2>
            </div>
            <div class="card-body">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px;">
                    <div>
                        <strong style="color: #4A5568; display: block; margin-bottom: 5px;">Trạng thái:</strong>
                        <c:choose>
                            <c:when test="${order.status == 'PENDING'}">
                                <span class="badge badge-warning" style="font-size: 14px; padding: 8px 16px;">⏳ Chờ xác nhận</span>
                            </c:when>
                            <c:when test="${order.status == 'CONFIRMED'}">
                                <span class="badge badge-info" style="font-size: 14px; padding: 8px 16px;">✅ Đã xác nhận</span>
                            </c:when>
                            <c:when test="${order.status == 'PREPARING'}">
                                <span class="badge badge-primary" style="font-size: 14px; padding: 8px 16px;">👨‍🍳 Đang chuẩn bị</span>
                            </c:when>
                            <c:when test="${order.status == 'READY'}">
                                <span class="badge badge-success" style="font-size: 14px; padding: 8px 16px;">🎉 Sẵn sàng</span>
                            </c:when>
                            <c:when test="${order.status == 'COMPLETED'}">
                                <span class="badge badge-success" style="font-size: 14px; padding: 8px 16px;">✓ Hoàn thành</span>
                            </c:when>
                            <c:when test="${order.status == 'CANCELLED'}">
                                <span class="badge badge-danger" style="font-size: 14px; padding: 8px 16px;">✗ Đã hủy</span>
                            </c:when>
                        </c:choose>
                    </div>
                    <div>
                        <strong style="color: #4A5568; display: block; margin-bottom: 5px;">Thời gian đặt:</strong>
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
                    </div>
                    <div>
                        <strong style="color: #4A5568; display: block; margin-bottom: 5px;">Tổng tiền:</strong>
                        <span style="font-size: 24px; font-weight: bold; color: #f5576c;">
                            <fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0" groupingUsed="true"/> đ
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Customer Info -->
        <div class="card" style="margin-bottom: 20px;">
            <div class="card-header">
                <h2>👤 Thông tin khách hàng</h2>
            </div>
            <div class="card-body">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px;">
                    <div>
                        <strong style="color: #4A5568; display: block; margin-bottom: 5px;">Tên:</strong>
                        <span>${order.customerName}</span>
                    </div>
                    <div>
                        <strong style="color: #4A5568; display: block; margin-bottom: 5px;">Số điện thoại:</strong>
                        <span>${order.customerPhone}</span>
                    </div>
                    <c:if test="${not empty order.customerAddress}">
                        <div>
                            <strong style="color: #4A5568; display: block; margin-bottom: 5px;">Bàn số:</strong>
                            <span>${order.customerAddress}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty order.note}">
                        <div>
                            <strong style="color: #4A5568; display: block; margin-bottom: 5px;">Ghi chú:</strong>
                            <span>${order.note}</span>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Order Items -->
        <div class="card">
            <div class="card-header">
                <h2>🍽️ Danh sách món</h2>
            </div>
            <div class="card-body">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Món ăn</th>
                            <th>Giá</th>
                            <th>Số lượng</th>
                            <th style="text-align: right;">Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${order.items}">
                            <tr>
                                <td>
                                    <strong>${item.product.name}</strong>
                                </td>
                                <td><fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="0" groupingUsed="true"/> đ</td>
                                <td>${item.quantity}</td>
                                <td style="text-align: right; font-weight: bold; color: #f5576c;">
                                    <fmt:formatNumber value="${item.subtotal}" type="number" maxFractionDigits="0" groupingUsed="true"/> đ
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr style="background: #f8f9fa; font-weight: bold;">
                            <td colspan="3" style="text-align: right; padding: 15px;">Tổng cộng:</td>
                            <td style="text-align: right; padding: 15px; font-size: 20px; color: #f5576c;">
                                <fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0" groupingUsed="true"/> đ
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>

        <!-- Update Status -->
        <c:if test="${order.status != 'COMPLETED' && order.status != 'CANCELLED'}">
            <div class="card" style="margin-top: 20px;">
                <div class="card-header">
                    <h2>🔄 Cập nhật trạng thái</h2>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/orders/${order.id}/update-status" method="post" accept-charset="UTF-8">
                        <c:if test="${not empty _csrf}">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        </c:if>
                        <div style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
                            <select name="status" class="form-select" style="flex: 1; min-width: 200px;">
                                <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
                                <option value="CONFIRMED" ${order.status == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                                <option value="PREPARING" ${order.status == 'PREPARING' ? 'selected' : ''}>Đang chuẩn bị</option>
                                <option value="READY" ${order.status == 'READY' ? 'selected' : ''}>Sẵn sàng</option>
                                <option value="COMPLETED" ${order.status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                                <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Hủy</option>
                            </select>
                            <button type="submit" class="btn btn-primary">💾 Cập nhật</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>
    </main>
</div>

<style>
    .card {
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        overflow: hidden;
    }

    .card-header {
        padding: 20px 25px;
        background: linear-gradient(135deg, #87CEEB 0%, #6BB6D6 100%);
        color: white;
    }

    .card-header h2 {
        margin: 0;
        font-size: 20px;
    }

    .card-body {
        padding: 25px;
    }

    .data-table {
        width: 100%;
        border-collapse: collapse;
    }

    .data-table th {
        background: #f8f9fa;
        padding: 12px;
        text-align: left;
        font-weight: 600;
        color: #495057;
        border-bottom: 2px solid #dee2e6;
    }

    .data-table td {
        padding: 12px;
        border-bottom: 1px solid #e9ecef;
    }

    .data-table tr:hover {
        background: #f8f9fa;
    }

    .form-select {
        padding: 10px 15px;
        border: 2px solid #e0e0e0;
        border-radius: 8px;
        font-size: 14px;
        cursor: pointer;
    }

    .form-select:focus {
        outline: none;
        border-color: #87CEEB;
    }

    .badge {
        display: inline-block;
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
</style>
</body>
</html>

