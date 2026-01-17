<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Nhà hàng - Menu Online</title>
    <jsp:include page="../fragments/layout.jsp">
        <jsp:param name="title" value="Quản lý Nhà hàng - Menu Online"/>
    </jsp:include>
</head>
<body>
<%@ include file="../fragments/navbar.jsp" %>

<div class="main-layout">
    <!-- Sidebar -->
    <c:if test="${user.role == 'ADMIN'}">
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
    </c:if>

    <!-- Sidebar for MERCHANT -->
    <c:if test="${user.role == 'MERCHANT'}">
        <aside class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/dashboard">
                    <span class="icon">📊</span>
                    <span>Dashboard</span>
                </a></li>
                <c:if test="${not empty restaurant}">
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
                    <li><a href="${pageContext.request.contextPath}/manage/statistics?restaurantId=${restaurant.id}">
                        <span class="icon">📈</span>
                        <span>Thống kê</span>
                    </a></li>
                </c:if>
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
            <div>
                <h1>${not empty restaurant.id ? '✏️ Sửa thông tin nhà hàng' : '➕ Thêm nhà hàng mới'}</h1>
                <p>${not empty restaurant.id ? 'Cập nhật thông tin nhà hàng của bạn' : 'Tạo nhà hàng mới trong hệ thống'}</p>
            </div>
            <c:choose>
                <c:when test="${user.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/manage/restaurants" class="btn btn-secondary">
                        ← Quay lại
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                        ← Quay lại
                    </a>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Form Card -->
        <div class="form-card">
            <form action="${pageContext.request.contextPath}/manage/restaurants/save" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
                <input type="hidden" name="id" value="${restaurant.id}">
                <c:if test="${not empty restaurant.logo}">
                    <input type="hidden" name="logo" value="${restaurant.logo}">
                </c:if>

                <div class="form-grid">
                    <!-- Logo Preview -->
                    <div class="form-section full-width">
                        <h3>🖼️ Logo nhà hàng</h3>
                        <div class="logo-upload-container">
                            <div class="logo-preview" id="logoPreview">
                                <c:if test="${not empty restaurant.logo}">
                                    <img src="${pageContext.request.contextPath}${restaurant.logo}" alt="Logo" id="logoImg">
                                </c:if>
                                <c:if test="${empty restaurant.logo}">
                                    <div class="logo-placeholder">
                                        <span>🏪</span>
                                        <p>Chưa có logo</p>
                                    </div>
                                </c:if>
                            </div>
                            <div class="upload-controls">
                                <label for="logoFile" class="btn btn-primary">
                                    📤 Chọn ảnh
                                </label>
                                <input type="file" 
                                       id="logoFile" 
                                       name="logoFile" 
                                       accept="image/*"
                                       onchange="previewLogo(this)"
                                       style="display: none;">
                                <p class="help-text">JPG, PNG hoặc GIF. Tối đa 10MB</p>
                            </div>
                        </div>
                    </div>

                    <!-- Basic Info -->
                    <div class="form-section full-width">
                        <h3>📝 Thông tin cơ bản</h3>
                        
                        <div class="form-group">
                            <label for="name">Tên nhà hàng *</label>
                            <input type="text" 
                                   id="name" 
                                   name="name" 
                                   value="${restaurant.name}"
                                   placeholder="Nhập tên nhà hàng"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="address">Địa chỉ *</label>
                            <input type="text" 
                                   id="address" 
                                   name="address" 
                                   value="${restaurant.address}"
                                   placeholder="Số nhà, đường, quận, thành phố"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="description">Mô tả</label>
                            <textarea id="description" 
                                      name="description" 
                                      rows="4"
                                      placeholder="Giới thiệu ngắn về nhà hàng của bạn...">${restaurant.description}</textarea>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <c:choose>
                        <c:when test="${user.role == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/manage/restaurants" 
                               class="btn btn-secondary">
                                Hủy
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/dashboard" 
                               class="btn btn-secondary">
                                Hủy
                            </a>
                        </c:otherwise>
                    </c:choose>
                    <button type="submit" class="btn btn-primary">
                        💾 Lưu thông tin
                    </button>
                </div>
            </form>
        </div>
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
    color: var(--dark);
    text-decoration: none;
    font-size: 15px;
}

.sidebar-menu a:hover {
    background: linear-gradient(90deg, rgba(135, 206, 235, 0.1) 0%, transparent 100%);
    color: var(--primary);
    border-left: 3px solid var(--primary);
    padding-left: 22px;
}

.sidebar-menu a.active {
    background: linear-gradient(90deg, rgba(135, 206, 235, 0.15) 0%, transparent 100%);
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

/* Page Header */
.page-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 30px;
}

.btn-secondary {
    background: var(--gray);
    color: white;
}

/* Form Card */
.form-card {
    background: white;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    padding: 40px;
}

.form-grid {
    display: grid;
    gap: 30px;
}

.form-section {
    border-bottom: 1px solid var(--border);
    padding-bottom: 30px;
}

.form-section:last-child {
    border-bottom: none;
    padding-bottom: 0;
}

.form-section h3 {
    font-size: 18px;
    color: var(--dark);
    margin-bottom: 20px;
}

.full-width {
    grid-column: span 2;
}

/* Logo Upload */
.logo-upload-container {
    display: flex;
    gap: 30px;
    align-items: center;
}

.logo-preview {
    width: 200px;
    height: 200px;
    border-radius: 12px;
    overflow: hidden;
    border: 2px solid var(--border);
    background: var(--light);
}

.logo-preview img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.logo-placeholder {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    color: var(--gray);
}

.logo-placeholder span {
    font-size: 60px;
    margin-bottom: 10px;
}

.upload-controls {
    flex: 1;
}

.help-text {
    color: var(--gray);
    font-size: 13px;
    margin-top: 10px;
}

/* Form Group */
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

.form-group input[type="text"],
.form-group textarea {
    width: 100%;
    padding: 12px 16px;
    border: 2px solid var(--border);
    border-radius: 8px;
    font-size: 15px;
    font-family: inherit;
}

.form-group input:focus,
.form-group textarea:focus {
    outline: none;
    border-color: var(--primary);
    box-shadow: 0 0 0 3px rgba(135, 206, 235, 0.1);
}

.form-group textarea {
    resize: vertical;
    min-height: 100px;
}

/* Checkbox */
.checkbox-label {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    cursor: pointer;
    padding: 15px;
    border: 2px solid var(--border);
    border-radius: 8px;
}

.checkbox-label:hover {
    border-color: var(--primary);
    background: rgba(135, 206, 235, 0.05);
}

.checkbox-label input[type="checkbox"] {
    display: none;
}

.checkbox-custom {
    width: 24px;
    height: 24px;
    border: 2px solid var(--border);
    border-radius: 6px;
    flex-shrink: 0;
    position: relative;
}

.checkbox-label input[type="checkbox"]:checked + .checkbox-custom {
    background: var(--primary);
    border-color: var(--primary);
}

.checkbox-label input[type="checkbox"]:checked + .checkbox-custom::after {
    content: '✓';
    position: absolute;
    color: white;
    font-size: 16px;
    top: 50%;
    left: 50%;
    margin-left: -7px;
    margin-top: -10px;
}

.checkbox-text {
    flex: 1;
}

.checkbox-text strong {
    display: block;
    color: var(--dark);
    margin-bottom: 4px;
}

.checkbox-text small {
    color: var(--gray);
    font-size: 13px;
}

/* Form Actions */
.form-actions {
    display: flex;
    gap: 15px;
    justify-content: flex-end;
    padding-top: 30px;
    border-top: 1px solid var(--border);
    margin-top: 30px;
}

/* Responsive */
@media (max-width: 768px) {
    .page-header {
        flex-direction: column;
        gap: 15px;
    }

    .form-card {
        padding: 25px;
    }

    .logo-upload-container {
        flex-direction: column;
        text-align: center;
    }

    .form-actions {
        flex-direction: column-reverse;
    }

    .form-actions .btn {
        width: 100%;
    }
}
</style>

<script>
function previewLogo(input) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        
        reader.onload = function(e) {
            const preview = document.getElementById('logoPreview');
            preview.innerHTML = '<img id="logoImg" src="' + e.target.result + '" alt="Logo preview">';
        }
        
        reader.readAsDataURL(input.files[0]);
    }
}
</script>
</body>
</html>

