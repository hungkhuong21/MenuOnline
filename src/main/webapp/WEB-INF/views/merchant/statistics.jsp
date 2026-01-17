<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../fragments/layout.jsp">
        <jsp:param name="title" value="Thống kê - Menu Online"/>
    </jsp:include>
</head>
<body>
<c:catch var="navbarError">
    <%@ include file="../fragments/navbar.jsp" %>
</c:catch>
<c:if test="${not empty navbarError}">
    <!-- Navbar error, continue anyway -->
</c:if>

<div class="main-layout" style="display: flex; min-height: calc(100vh - 70px);">
    <!-- Sidebar -->
    <c:if test="${not empty restaurant}">
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
            <li><a href="${pageContext.request.contextPath}/orders/manage?restaurantId=${restaurant.id}">
                <span class="icon">🛒</span>
                <span>Đơn hàng</span>
            </a></li>
            <li><a href="${pageContext.request.contextPath}/manage/statistics?restaurantId=${restaurant.id}" class="active">
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
    </c:if>

    <!-- Main Content -->
    <main class="content" style="background: transparent; padding: 30px;">
        <div class="page-header">
            <div>
                <h1>📊 Thống kê & Phân tích</h1>
                <p>Theo dõi lượt xem menu và hành vi khách hàng</p>
            </div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                <strong>❌ Lỗi:</strong> ${errorMessage}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty restaurant}">
                <div class="alert alert-error" style="background: #fee; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <strong>⚠️ Lỗi:</strong> Không tìm thấy thông tin nhà hàng với ID được yêu cầu. 
                    <br><br>
                    <p>Vui lòng kiểm tra lại ID nhà hàng hoặc quay về Dashboard để chọn nhà hàng khác.</p>
                    <br>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">Quay về Dashboard</a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Restaurant Info Card -->
                <div class="info-card" style="background: white; padding: 20px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); display: flex; align-items: center; gap: 15px; margin-bottom: 30px;">
                    <span class="info-icon" style="font-size: 40px;">🏪</span>
                    <div>
                        <strong style="font-size: 18px; color: var(--text-primary); font-weight: 700;">${restaurant.name}</strong>
                        <p style="color: var(--text-secondary); font-size: 14px; margin-top: 4px; font-weight: 500;">${restaurant.address}</p>
                    </div>
                </div>

                <!-- Stats Summary -->
                <div class="stats-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 30px;">
                    <div class="stat-card" style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); text-align: center;">
                        <div class="stat-icon" style="font-size: 48px; margin-bottom: 15px;">👁️</div>
                        <div class="stat-value" style="font-size: 36px; font-weight: bold; color: var(--text-primary); margin-bottom: 5px;">${not empty totalViews ? totalViews : 0}</div>
                        <div class="stat-label" style="color: var(--text-secondary); font-size: 14px; font-weight: 600;">Tổng lượt xem menu</div>
                    </div>

                    <div class="stat-card" style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); text-align: center;">
                        <div class="stat-icon" style="font-size: 48px; margin-bottom: 15px;">📅</div>
                        <div class="stat-value" style="font-size: 24px; font-weight: bold; color: var(--text-primary); margin-bottom: 5px;">
                            <c:set var="firstLogDate" value="" />
                            <c:if test="${not empty logs && logs.size() > 0}">
                                <c:forEach var="logItem" items="${logs}">
                                    <c:if test="${empty firstLogDate && not empty logItem && not empty logItem.viewTime}">
                                        <c:catch var="dateError">
                                            <fmt:formatDate value="${logItem.viewTime}" pattern="dd/MM/yyyy" var="firstLogDate"/>
                                        </c:catch>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                            <c:choose>
                                <c:when test="${not empty firstLogDate}">${firstLogDate}</c:when>
                                <c:otherwise>Chưa có</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="stat-label" style="color: var(--text-secondary); font-size: 14px; font-weight: 600;">Lượt xem gần nhất</div>
                    </div>

                    <div class="stat-card" style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); text-align: center;">
                        <div class="stat-icon" style="font-size: 48px; margin-bottom: 15px;">📱</div>
                        <div class="stat-value" style="font-size: 36px; font-weight: bold; color: var(--text-primary); margin-bottom: 5px;">${not empty logs ? logs.size() : 0}</div>
                        <div class="stat-label" style="color: var(--text-secondary); font-size: 14px; font-weight: 600;">Tổng số lần quét QR</div>
                    </div>
                </div>

                <!-- View Logs Table -->
                <div class="card" style="background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); overflow: hidden;">
                    <div class="card-header" style="padding: 25px 30px; background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%); color: white; font-weight: 600;">
                        <h2 style="font-size: 22px; font-weight: 700; margin: 0;">📋 Lịch sử xem menu</h2>
                    </div>
                    <div class="card-body" style="padding: 30px;">
                        <c:if test="${empty logs}">
                            <div class="empty-state">
                                <div class="empty-icon">📊</div>
                                <h3>Chưa có dữ liệu</h3>
                                <p>Chưa có khách hàng nào xem menu của bạn. Hãy chia sẻ mã QR để khách hàng quét và xem menu!</p>
                            </div>
                        </c:if>

                        <c:if test="${not empty logs}">
                            <div class="table-responsive">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>Thời gian</th>
                                            <th>IP Address</th>
                                            <th>Thiết bị</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="log" items="${logs}" varStatus="status">
                                            <tr>
                                                <td>${status.count}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty log && not empty log.viewTime}">
                                                            <c:catch var="dateError1">
                                                                <strong><fmt:formatDate value="${log.viewTime}" pattern="dd/MM/yyyy"/></strong>
                                                                <br>
                                                                <small><fmt:formatDate value="${log.viewTime}" pattern="HH:mm:ss"/></small>
                                                            </c:catch>
                                                            <c:if test="${not empty dateError1}">
                                                                <strong>N/A</strong>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <strong>N/A</strong>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="ip-badge">${not empty log && not empty log.ipAddress ? log.ipAddress : 'N/A'}</span>
                                                </td>
                                                <td>
                                                    <span class="device-badge">
                                                        <c:choose>
                                                            <c:when test="${not empty log && not empty log.userAgent}">
                                                                <c:set var="userAgentLength" value="${fn:length(log.userAgent)}" />
                                                                <c:choose>
                                                                    <c:when test="${userAgentLength > 50}">
                                                                        ${fn:substring(log.userAgent, 0, 50)}...
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${log.userAgent}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>N/A</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>


<style>
    /* Sidebar */
    .sidebar {
        width: 260px;
        background: white;
        box-shadow: 2px 0 10px rgba(0,0,0,0.05);
        padding: 20px 0;
    }

    .sidebar-menu {
        list-style: none;
    }

    .sidebar-menu li {
        margin-bottom: 5px;
    }

    .sidebar-menu a {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px 25px;
        color: var(--text-primary);
        text-decoration: none;
        font-size: 15px;
        font-weight: 500;
    }

    .sidebar-menu a:hover {
        background: linear-gradient(90deg, rgba(37, 99, 235, 0.12) 0%, transparent 100%);
        color: var(--primary);
        border-left: 3px solid var(--primary);
        padding-left: 22px;
        font-weight: 600;
    }

    .sidebar-menu a.active {
        background: linear-gradient(90deg, rgba(37, 99, 235, 0.18) 0%, transparent 100%);
        color: var(--primary);
        border-left: 3px solid var(--primary);
        padding-left: 22px;
        font-weight: 700;
    }

    .sidebar-menu .icon {
        font-size: 20px;
        width: 24px;
        text-align: center;
    }

    .sidebar-divider {
        height: 1px;
        background: var(--border);
        margin: 15px 25px;
    }

    /* Page Header */
    .page-header {
        margin-bottom: 30px;
    }

    /* Info Card */
    .info-card {
        background: white;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        display: flex;
        align-items: center;
        gap: 15px;
        margin-bottom: 30px;
    }

    .info-icon {
        font-size: 40px;
    }

    .info-card strong {
        font-size: 18px;
        color: var(--text-primary);
        font-weight: 700;
    }

    .info-card p {
        color: var(--text-secondary);
        font-size: 14px;
        margin-top: 4px;
        font-weight: 500;
    }

    /* Stats Grid */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }

    .stat-card {
        background: white;
        padding: 25px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        text-align: center;
    }

    .stat-icon {
        font-size: 48px;
        margin-bottom: 15px;
    }

    .stat-value {
        font-size: 36px;
        font-weight: bold;
        color: var(--text-primary);
        margin-bottom: 5px;
    }

    .stat-label {
        color: var(--text-secondary);
        font-size: 14px;
        font-weight: 600;
    }

    /* Card */
    .card {
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        overflow: hidden;
    }

    .card-header {
        padding: 25px 30px;
        background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
        color: white;
        font-weight: 600;
    }

    .card-header h2 {
        font-size: 22px;
        font-weight: 700;
    }

    .card-body {
        padding: 30px;
    }

    /* Table */
    .table-responsive {
        overflow-x: auto;
    }

    .data-table {
        width: 100%;
        border-collapse: collapse;
    }

    .data-table thead {
        background: var(--light);
    }

    .data-table th {
        padding: 15px;
        text-align: left;
        font-weight: 600;
        color: var(--text-primary);
        font-size: 14px;
        border-bottom: 2px solid var(--border);
    }

    .data-table td {
        padding: 15px;
        border-bottom: 1px solid var(--border);
        color: var(--text-primary);
        font-size: 14px;
        font-weight: 500;
    }

    .data-table tbody tr {
    }

    .data-table tbody tr:hover {
        background: var(--light);
    }

    .data-table tbody tr:last-child td {
        border-bottom: none;
    }

    /* Badges */
    .ip-badge {
        display: inline-block;
        padding: 6px 12px;
        background: #dbeafe;
        color: #1e40af;
        border-radius: 6px;
        font-size: 13px;
        font-family: monospace;
        font-weight: 600;
    }

    .device-badge {
        display: inline-block;
        padding: 6px 12px;
        background: #ede9fe;
        color: #6d28d9;
        border-radius: 6px;
        font-size: 12px;
        max-width: 300px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        font-weight: 500;
    }

    /* Empty State */
    .empty-state {
        text-align: center;
        padding: 80px 20px;
    }

    .empty-icon {
        font-size: 100px;
        margin-bottom: 25px;
        opacity: 0.5;
    }

    .empty-state h3 {
        font-size: 24px;
        color: var(--text-primary);
        margin-bottom: 10px;
        font-weight: 700;
    }

    .empty-state p {
        color: var(--text-secondary);
        font-size: 16px;
        font-weight: 500;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .stats-grid {
            grid-template-columns: 1fr;
        }

        .data-table {
            font-size: 12px;
        }

        .data-table th,
        .data-table td {
            padding: 10px;
        }

        .device-badge {
            max-width: 150px;
        }
    }
</style>
</body>
</html>

