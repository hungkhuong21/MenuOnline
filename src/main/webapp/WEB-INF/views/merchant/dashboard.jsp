<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../fragments/layout.jsp">
        <jsp:param name="title" value="Dashboard - Menu Online"/>
    </jsp:include>
</head>
<body>
<%@ include file="../fragments/navbar.jsp" %>

<div class="main-layout">
    <!-- Sidebar for ADMIN -->
    <c:if test="${user.role == 'ADMIN'}">
        <aside class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/dashboard" class="active">
                    <span class="icon">📊</span>
                    <span>Dashboard</span>
                </a></li>
                <li><a href="${pageContext.request.contextPath}/manage/restaurants">
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
    </c:if>

    <!-- Sidebar for MERCHANT -->
    <c:if test="${user.role == 'MERCHANT' && not empty restaurants}">
        <aside class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/dashboard" class="active">
                    <span class="icon">📊</span>
                    <span>Dashboard</span>
                </a></li>
                <li><a href="${pageContext.request.contextPath}/manage/products?restaurantId=${restaurants[0].id}">
                    <span class="icon">🍔</span>
                    <span>Món ăn</span>
                </a></li>
                <li><a href="${pageContext.request.contextPath}/manage/categories?restaurantId=${restaurants[0].id}">
                    <span class="icon">📂</span>
                    <span>Danh mục</span>
                </a></li>
                <li><a href="${pageContext.request.contextPath}/orders/manage?restaurantId=${restaurants[0].id}">
                    <span class="icon">🛒</span>
                    <span>Đơn hàng</span>
                </a></li>
                <li><a href="${pageContext.request.contextPath}/manage/statistics?restaurantId=${restaurants[0].id}">
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
    <main class="content">
        <div class="page-header">
            <h1>${user.role == 'ADMIN' ? '📊 Dashboard - Quản trị hệ thống' : '📊 Dashboard'}</h1>
            <p>${user.role == 'ADMIN' ? 'Tổng quan toàn bộ hệ thống' : 'Tổng quan nhà hàng của bạn'}</p>
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
            <!-- Admin: Hiện thống kê nhà hàng -->
            <c:if test="${user.role == 'ADMIN'}">
                <div class="stat-card">
                    <div class="stat-icon">🏪</div>
                    <div class="stat-value">${totalRestaurants}</div>
                    <div class="stat-label">Tổng nhà hàng</div>
                </div>
            </c:if>

            <!-- Món ăn -->
            <div class="stat-card">
                <div class="stat-icon">🍔</div>
                <div class="stat-value">${totalProducts}</div>
                <div class="stat-label">${user.role == 'ADMIN' ? 'Tổng món ăn' : 'Món ăn'}</div>
            </div>

            <!-- Lượt xem -->
            <div class="stat-card">
                <div class="stat-icon">👁️</div>
                <div class="stat-value">${totalViews}</div>
                <div class="stat-label">${user.role == 'ADMIN' ? 'Tổng lượt xem' : 'Lượt xem menu'}</div>
            </div>

            <!-- Merchant: Hiện danh mục -->
            <c:if test="${user.role == 'MERCHANT'}">
                <div class="stat-card">
                    <div class="stat-icon">📂</div>
                    <div class="stat-value">${totalCategories}</div>
                    <div class="stat-label">Danh mục</div>
                </div>
            </c:if>
        </div>

        <!-- Restaurants Section -->
        <div class="card">
            <div class="card-header">
                <div>
                    <h2>${user.role == 'ADMIN' ? '🏪 Danh sách nhà hàng' : '🏪 Nhà hàng của tôi'}</h2>
                    <c:if test="${user.role == 'ADMIN'}">
                        <p>Quản lý tất cả nhà hàng trong hệ thống</p>
                    </c:if>
                </div>
                <c:if test="${user.role == 'ADMIN' || (user.role == 'MERCHANT' && empty restaurants)}">
                    <a href="${pageContext.request.contextPath}/manage/restaurants/new" class="btn btn-primary">
                        ➕ Thêm nhà hàng
                    </a>
                </c:if>
            </div>

            <div class="card-body">
                <!-- Empty State -->
                <c:if test="${empty restaurants}">
                    <div class="empty-state">
                        <div class="empty-state-icon">🏪</div>
                        <h3>Chưa có nhà hàng nào</h3>
                        <c:choose>
                            <c:when test="${user.role == 'MERCHANT'}">
                                <p>Hãy tạo nhà hàng của bạn ngay!</p>
                            </c:when>
                            <c:otherwise>
                                <p>Chưa có nhà hàng nào trong hệ thống.</p>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/manage/restaurants/new" class="btn btn-primary">Tạo nhà hàng đầu tiên</a>
                    </div>
                </c:if>

                <!-- Restaurant Grid -->
                <c:if test="${not empty restaurants}">
                    <div class="restaurant-grid">
                        <c:forEach var="restaurant" items="${restaurants}">
                            <div class="restaurant-card">
                                <div class="restaurant-header">
                                    <c:if test="${not empty restaurant.logo}">
                                        <img src="${pageContext.request.contextPath}${restaurant.logo}"
                                             alt="Logo"
                                             class="restaurant-logo"
                                             onerror="this.style.display='none'">
                                    </c:if>
                                    <c:if test="${empty restaurant.logo}">
                                        <div class="restaurant-logo-placeholder">🏪</div>
                                    </c:if>
                                </div>
                                <div class="restaurant-body">
                                    <h3 class="restaurant-name">${restaurant.name}</h3>
                                    <p class="restaurant-address">${restaurant.address}</p>
                                    <span class="restaurant-status ${restaurant.isActive ? 'status-active' : 'status-inactive'}">
                                        ${restaurant.isActive ? '● Hoạt động' : '● Tạm ngừng'}
                                    </span>
                                </div>
                                <div class="restaurant-actions">
                                    <a href="${pageContext.request.contextPath}/manage/products?restaurantId=${restaurant.id}"
                                       class="btn-action btn-success" title="Quản lý món ăn">
                                        🍔 Món ăn
                                    </a>
                                    <a href="${pageContext.request.contextPath}/manage/categories?restaurantId=${restaurant.id}"
                                       class="btn-action btn-info" title="Quản lý danh mục">
                                        📂 Danh mục
                                    </a>
                                    <a href="${pageContext.request.contextPath}/orders/manage?restaurantId=${restaurant.id}"
                                       class="btn-action btn-warning" title="Xem đơn hàng">
                                        🛒 Đơn hàng
                                    </a>
                                    <a href="${pageContext.request.contextPath}/manage/statistics?restaurantId=${restaurant.id}"
                                       class="btn-action btn-secondary" title="Xem thống kê">
                                        📊 Thống kê
                                    </a>
                                    <a href="${pageContext.request.contextPath}/restaurant/${restaurant.id}/qr"
                                       class="btn-action btn-primary" target="_blank" title="Xem QR Code">
                                        📱 QR Code
                                    </a>
                                    <!-- Nút toggle status cho ADMIN và MERCHANT -->
                                    <button type="button" 
                                            class="btn-action toggle-status-btn ${restaurant.isActive ? 'btn-warning' : 'btn-success'}" 
                                            data-restaurant-id="${restaurant.id}"
                                            title="${restaurant.isActive ? 'Tạm ngừng hoạt động' : 'Kích hoạt nhà hàng'}">
                                        <span class="toggle-status-text">${restaurant.isActive ? '⏸️ Tạm ngừng' : '▶️ Kích hoạt'}</span>
                                    </button>
                                    <!-- Nút sửa và xóa thông tin cho MERCHANT -->
                                    <c:if test="${user.role == 'MERCHANT'}">
                                        <div class="edit-delete-buttons" style="grid-column: span 3; display: grid; grid-template-columns: 1fr 1fr; gap: 8px;">
                                            <a href="${pageContext.request.contextPath}/manage/restaurants/edit/${restaurant.id}"
                                               class="btn-action btn-edit" title="Sửa thông tin nhà hàng">
                                                ✏️ Sửa thông tin
                                            </a>
                                            <form action="${pageContext.request.contextPath}/manage/restaurants/delete/${restaurant.id}"
                                                  method="post"
                                                  style="display: inline;"
                                                  onsubmit="return confirm('Bạn có chắc muốn xóa nhà hàng \"${restaurant.name}\"? Hành động này không thể hoàn tác!');">
                                                <button type="submit" class="btn-action btn-delete" title="Xóa nhà hàng">
                                                    🗑️ Xóa nhà hàng
                                                </button>
                                            </form>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>
    </main>
</div>

<style>
    /* Sidebar - Override for consistency */
    .sidebar {
        width: 260px;
        background: rgba(255, 255, 255, 0.9);
        backdrop-filter: blur(20px);
        box-shadow: 4px 0 20px rgba(135, 206, 235, 0.15);
        padding: 20px 0;
        border-right: 2px solid rgba(135, 206, 235, 0.2);
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
        color: var(--dark);
        text-decoration: none;
        font-size: 15px;
    }

    .sidebar-menu a:hover {
        background: linear-gradient(90deg, rgba(135, 206, 235, 0.15) 0%, transparent 100%);
        color: var(--primary-dark);
        border-left: 3px solid var(--primary);
        padding-left: 22px;
    }

    .sidebar-menu a.active {
        background: linear-gradient(90deg, rgba(135, 206, 235, 0.2) 0%, transparent 100%);
        color: var(--primary-dark);
        border-left: 3px solid var(--primary);
        padding-left: 22px;
        font-weight: 600;
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

    /* Stats Grid */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }

    .stat-card {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        padding: 25px;
        border-radius: 16px;
        box-shadow: 0 4px 16px rgba(135, 206, 235, 0.15);
        text-align: center;
        border: 1px solid rgba(135, 206, 235, 0.2);
    }

    .stat-icon {
        font-size: 48px;
        margin-bottom: 15px;
    }

    .stat-value {
        font-size: 36px;
        font-weight: bold;
        background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary) 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        margin-bottom: 5px;
    }

    .stat-label {
        color: #4A5568;
        font-size: 14px;
        font-weight: 600;
    }

    /* Card */
    .card {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        border-radius: 16px;
        box-shadow: 0 4px 20px rgba(135, 206, 235, 0.15);
        overflow: hidden;
        margin-bottom: 30px;
        border: 1px solid rgba(135, 206, 235, 0.2);
    }

    .card-header {
        padding: 25px 30px;
        background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
        color: white;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 4px 12px rgba(135, 206, 235, 0.3);
    }

    .card-header h2 {
        font-size: 22px;
        margin-bottom: 5px;
    }

    .card-header p {
        font-size: 14px;
        opacity: 0.9;
    }

    .card-body {
        padding: 30px;
    }

    /* Restaurant Grid */
    .restaurant-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 20px;
    }

    .restaurant-card {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(135, 206, 235, 0.3);
        border-radius: 16px;
        overflow: hidden;
        box-shadow: 0 4px 12px rgba(135, 206, 235, 0.1);
    }

    .restaurant-header {
        height: 160px;
        background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
        box-shadow: 0 4px 12px rgba(135, 206, 235, 0.3);
    }

    .restaurant-logo {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .restaurant-logo-placeholder {
        font-size: 80px;
    }

    .restaurant-body {
        padding: 20px;
    }

    .restaurant-name {
        font-size: 20px;
        font-weight: bold;
        color: var(--dark);
        margin-bottom: 8px;
    }

    .restaurant-address {
        color: #4A5568;
        font-weight: 600;
        font-size: 14px;
        margin-bottom: 12px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    .restaurant-status {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
    }

    .status-active {
        background: rgba(78, 205, 196, 0.2);
        color: #0F766E;
        border: 1px solid rgba(78, 205, 196, 0.3);
    }

    .status-inactive {
        background: rgba(255, 107, 107, 0.2);
        color: #B91C1C;
        border: 1px solid rgba(255, 107, 107, 0.3);
    }

    .restaurant-actions {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 8px;
        padding: 15px;
        background: linear-gradient(135deg, rgba(224, 246, 255, 0.5) 0%, rgba(176, 224, 230, 0.3) 100%);
    }

    .btn-action {
        padding: 10px;
        border: none;
        border-radius: 10px;
        cursor: pointer;
        font-size: 13px;
        font-weight: 600;
        text-align: center;
        text-decoration: none;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }

    .btn-success {
        background: linear-gradient(135deg, #4ECDC4 0%, #44A08D 100%);
        color: white;
    }

    .btn-info {
        background: linear-gradient(135deg, var(--info) 0%, var(--primary-dark) 100%);
        color: white;
    }

    .btn-secondary {
        background: linear-gradient(135deg, var(--gray) 0%, #5A6B7A 100%);
        color: white;
    }

    .btn-warning {
        background: linear-gradient(135deg, var(--warning) 0%, #FFB800 100%);
        color: #000;
    }

    .btn-primary {
        background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
        color: white;
    }

    .btn-edit {
        background: linear-gradient(135deg, var(--warning) 0%, #FFB800 100%);
        color: #000;
    }

    .btn-delete {
        background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
        color: white;
    }


    /* Empty State */
    .empty-state {
        text-align: center;
        padding: 80px 20px;
    }

    .empty-state-icon {
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
        color: #4A5568;
        font-weight: 600;
        margin-bottom: 25px;
        font-size: 16px;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .stats-grid {
            grid-template-columns: repeat(2, 1fr);
        }

        .restaurant-grid {
            grid-template-columns: 1fr;
        }

        .restaurant-actions {
            grid-template-columns: 1fr;
        }
    }
</style>

<script>
    // Toggle restaurant status without page reload
    document.addEventListener('DOMContentLoaded', function() {
        const toggleButtons = document.querySelectorAll('.toggle-status-btn');
        
        toggleButtons.forEach(button => {
            button.addEventListener('click', function() {
                const restaurantId = this.getAttribute('data-restaurant-id');
                const contextPath = '${pageContext.request.contextPath}';
                const csrfToken = document.querySelector('meta[name="_csrf"]')?.content || '';
                
                // Disable button during request
                this.disabled = true;
                const originalText = this.querySelector('.toggle-status-text').textContent;
                this.querySelector('.toggle-status-text').textContent = '⏳ Đang xử lý...';
                
                // Create form data
                const formData = new FormData();
                formData.append('_csrf', csrfToken);
                
                // Send AJAX request
                fetch(contextPath + '/api/restaurants/toggle-status/' + restaurantId, {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'X-CSRF-TOKEN': csrfToken
                    }
                })
                .then(response => {
                    // Check if response is OK
                    if (!response.ok) {
                        throw new Error('HTTP error! status: ' + response.status);
                    }
                    // Check content type
                    const contentType = response.headers.get('content-type');
                    if (!contentType || !contentType.includes('application/json')) {
                        return response.text().then(text => {
                            console.error('Expected JSON but got:', text.substring(0, 200));
                            throw new Error('Server returned non-JSON response');
                        });
                    }
                    return response.json();
                })
                .then(data => {
                    if (data && data.success) {
                        // Update button appearance
                        const isActive = data.isActive;
                        this.className = 'btn-action toggle-status-btn ' + (isActive ? 'btn-warning' : 'btn-success');
                        this.querySelector('.toggle-status-text').textContent = isActive ? '⏸️ Tạm ngừng' : '▶️ Kích hoạt';
                        this.setAttribute('title', isActive ? 'Tạm ngừng hoạt động' : 'Kích hoạt nhà hàng');
                        
                        // Update status badge in the same card
                        const card = this.closest('.restaurant-card');
                        if (card) {
                            const statusBadge = card.querySelector('.restaurant-status');
                            if (statusBadge) {
                                statusBadge.className = 'restaurant-status ' + (isActive ? 'status-active' : 'status-inactive');
                                statusBadge.textContent = isActive ? '● Hoạt động' : '● Tạm ngừng';
                            }
                        }
                        
                        // Show success message
                        showNotification(data.message || 'Cập nhật thành công', 'success');
                    } else {
                        showNotification(data?.message || 'Có lỗi xảy ra', 'error');
                        this.querySelector('.toggle-status-text').textContent = originalText;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Có lỗi xảy ra khi cập nhật trạng thái: ' + error.message, 'error');
                    this.querySelector('.toggle-status-text').textContent = originalText;
                })
                .finally(() => {
                    this.disabled = false;
                });
            });
        });
    });
    
    // Show notification
    function showNotification(message, type) {
        const notification = document.createElement('div');
        notification.className = 'alert alert-' + (type === 'success' ? 'success' : 'error');
        notification.style.cssText = 'position: fixed; top: 80px; right: 20px; z-index: 9999; padding: 15px 20px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);';
        notification.textContent = message;
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.remove();
        }, 3000);
    }
</script>

<style>
    .toggle-status-btn:disabled {
        opacity: 0.6;
        cursor: not-allowed;
    }
</style>
</body>
</html>

