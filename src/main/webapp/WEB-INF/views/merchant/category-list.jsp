<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../fragments/layout.jsp">
        <jsp:param name="title" value="Quản lý Danh mục - Menu Online"/>
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
            <li><a href="${pageContext.request.contextPath}/manage/categories?restaurantId=${restaurant.id}" class="active">
                <span class="icon">📂</span>
                <span>Danh mục</span>
            </a></li>
            <li><a href="${pageContext.request.contextPath}/orders/manage?restaurantId=${restaurant.id}">
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
                <h1>📂 Quản lý Danh mục</h1>
                <p>Tổ chức món ăn theo danh mục (Khai vị, Món chính, Tráng miệng...)</p>
            </div>
            <button onclick="openAddModal()" class="btn btn-primary">
                ➕ Thêm danh mục
            </button>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <!-- Restaurant Info Card -->
        <div class="info-card">
            <span class="info-icon">🏪</span>
            <div>
                <strong>${restaurant.name}</strong>
                <p>${restaurant.address}</p>
            </div>
        </div>

        <!-- Empty State -->
        <c:if test="${empty categories}">
            <div class="empty-state">
                <div class="empty-icon">📂</div>
                <h3>Chưa có danh mục nào</h3>
                <p>Hãy tạo danh mục để phân loại món ăn (Khai vị, Món chính, Tráng miệng...)</p>
                <button onclick="openAddModal()" class="btn btn-primary">
                    Tạo danh mục đầu tiên
                </button>
            </div>
        </c:if>

        <!-- Categories Grid -->
        <c:if test="${not empty categories}">
            <div class="categories-grid">
                <c:forEach var="category" items="${categories}">
                    <div class="category-card">
                        <div class="category-icon">🍽️</div>
                        <h3 class="category-name">${category.name}</h3>
                        <div class="category-actions">
                            <button data-id="${category.id}" 
                                    data-name="${category.name}" 
                                    onclick="editCategory(this.dataset.id, this.dataset.name)" 
                                    class="btn-action btn-warning">
                                ✏️ Sửa
                            </button>
                            <form action="${pageContext.request.contextPath}/manage/categories/delete/${category.id}"
                                  method="post"
                                  style="display: inline;"
                                  onsubmit="return confirm('Xóa danh mục này? Tất cả món ăn trong danh mục sẽ bị ảnh hưởng!');">
                                <c:if test="${not empty _csrf}">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                </c:if>
                                <input type="hidden" name="restaurantId" value="${restaurant.id}">
                                <button type="submit" class="btn-action btn-danger">
                                    🗑️ Xóa
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </main>
</div>

<!-- Modal Add/Edit -->
<div id="categoryModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2 id="modalTitle">Thêm danh mục</h2>
            <button type="button" class="close-btn" onclick="closeModal()">✕</button>
        </div>

        <form action="${pageContext.request.contextPath}/manage/categories/save" method="post" accept-charset="UTF-8">
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </c:if>
            <input type="hidden" name="id" id="categoryId">
            <input type="hidden" name="restaurant.id" value="${restaurant.id}">

            <div class="form-group">
                <label for="categoryName">Tên danh mục *</label>
                <input type="text"
                       id="categoryName"
                       name="name"
                       placeholder="Ví dụ: Khai vị, Món chính, Tráng miệng..."
                       required>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal()">Hủy</button>
                <button type="submit" class="btn btn-primary">💾 Lưu</button>
            </div>
        </form>
    </div>
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
        color: var(--dark);
        text-decoration: none;
        font-size: 15px;
    }

    .sidebar-menu a:hover {
        background: linear-gradient(90deg, rgba(135, 206, 235, 0.15) 0%, transparent 100%);
        color: var(--primary);
        border-left: 3px solid var(--primary);
        padding-left: 22px;
    }

    .sidebar-menu a.active {
        background: linear-gradient(90deg, rgba(135, 206, 235, 0.2) 0%, transparent 100%);
        color: var(--primary);
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

    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 30px;
    }

    .info-card {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        padding: 24px 28px;
        border-radius: 20px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
        display: flex;
        align-items: center;
        gap: 20px;
        margin-bottom: 32px;
        border: 1px solid rgba(255, 255, 255, 0.2);
    }

    .info-icon {
        font-size: 48px;
        filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.1));
    }

    .info-card strong {
        font-size: 20px;
        font-weight: 700;
        background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .info-card p {
        color: #4A5568;
        font-size: 15px;
        font-weight: 600;
        margin-top: 6px;
    }

    .categories-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 24px;
    }

    .category-card {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border-radius: 20px;
        padding: 36px 32px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
        border: 1px solid rgba(255, 255, 255, 0.2);
        text-align: center;
        position: relative;
        overflow: hidden;
    }

    .category-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background: linear-gradient(90deg, var(--primary) 0%, var(--primary-dark) 100%);
    }

    .category-icon {
        font-size: 64px;
        margin-bottom: 20px;
        filter: drop-shadow(0 4px 12px rgba(0, 0, 0, 0.15));
    }

    .category-name {
        font-size: 22px;
        font-weight: 700;
        background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        margin-bottom: 24px;
    }

    .category-actions {
        display: flex;
        gap: 12px;
        justify-content: center;
    }

    .btn-action {
        padding: 10px 20px;
        border: none;
        border-radius: 12px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        color: white;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }

    .btn-warning {
        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
    }

    .btn-danger {
        background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
    }

    /* Modal */
    .modal {
        display: none;
        position: fixed;
        z-index: 2000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.6);
        backdrop-filter: blur(4px);
    }

    .modal.active {
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .modal-content {
        background: rgba(255, 255, 255, 0.98);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border-radius: 24px;
        max-width: 520px;
        width: 90%;
        max-height: 90vh;
        overflow-y: auto;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        border: 1px solid rgba(255, 255, 255, 0.2);
    }

    .modal-header {
        padding: 28px 32px;
        background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
        color: white;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-radius: 24px 24px 0 0;
        box-shadow: 0 4px 16px rgba(135, 206, 235, 0.3);
    }

    .modal-header h2 {
        font-size: 24px;
        font-weight: 700;
        color: white;
    }

    .close-btn {
        background: none;
        border: none;
        font-size: 24px;
        cursor: pointer;
        color: #4A5568;
        font-weight: 600;
        width: 32px;
        height: 32px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
    }

    .close-btn:hover {
        background: var(--light);
        color: var(--dark);
    }

    .modal form {
        padding: 30px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        margin-bottom: 8px;
        color: var(--dark);
        font-weight: 500;
        font-size: 14px;
    }

    .form-group input {
        width: 100%;
        padding: 12px 16px;
        border: 2px solid var(--border);
        border-radius: 8px;
        font-size: 15px;
    }

    .form-group input:focus {
        outline: none;
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(135, 206, 235, 0.2);
    }

    .modal-footer {
        display: flex;
        gap: 10px;
        justify-content: flex-end;
        padding-top: 20px;
        border-top: 1px solid var(--border);
    }

    .btn-secondary {
        background: var(--gray);
        color: white;
    }

    /* Empty State */
    .empty-state {
        text-align: center;
        padding: 80px 20px;
        background: white;
        border-radius: 12px;
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
        color: #4A5568;
        font-weight: 600;
        margin-bottom: 25px;
        font-size: 16px;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .page-header {
            flex-direction: column;
            gap: 15px;
        }

        .categories-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<script>
    function openAddModal() {
        document.getElementById('modalTitle').textContent = 'Thêm danh mục';
        document.getElementById('categoryId').value = '';
        document.getElementById('categoryName').value = '';
        document.getElementById('categoryModal').classList.add('active');
    }

    function editCategory(id, name) {
        document.getElementById('modalTitle').textContent = 'Sửa danh mục';
        document.getElementById('categoryId').value = id;
        document.getElementById('categoryName').value = name;
        document.getElementById('categoryModal').classList.add('active');
    }

    function closeModal() {
        document.getElementById('categoryModal').classList.remove('active');
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('categoryModal');
        if (event.target == modal) {
            closeModal();
        }
    }

    // Close modal with ESC key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeModal();
        }
    });
</script>
</body>
</html>

