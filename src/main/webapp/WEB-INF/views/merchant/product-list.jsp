<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../fragments/layout.jsp">
        <jsp:param name="title" value="Quản lý Món ăn - Menu Online"/>
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
            <li><a href="${pageContext.request.contextPath}/manage/products?restaurantId=${restaurant.id}" class="active">
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
                <h1>🍔 Quản lý Món ăn</h1>
                <p>Thêm, sửa, xóa món ăn trong menu của bạn</p>
            </div>
            <button onclick="openAddModal()" class="btn btn-primary">
                ➕ Thêm món ăn
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

        <!-- Search and Filter Section -->
        <c:if test="${not empty products}">
            <div class="search-filter-section">
                <!-- Search Box -->
                <div class="search-box-container">
                    <div class="search-box">
                        <span class="search-icon">🔍</span>
                        <input type="text" 
                               id="searchInput" 
                               placeholder="Tìm kiếm món ăn theo tên..." 
                               autocomplete="off">
                        <button type="button" id="searchClear" class="search-clear-btn" style="display: none;">✕</button>
                    </div>
                </div>

                <!-- Category Filter -->
                <div class="category-filter-container">
                    <label class="filter-label">Lọc theo danh mục:</label>
                    <div class="category-tabs">
                        <button type="button" 
                                class="category-tab active" 
                                data-category="all"
                                onclick="filterByCategory('all')">
                            Tất cả
                        </button>
                        <c:forEach var="category" items="${categories}">
                            <button type="button" 
                                    class="category-tab" 
                                    data-category="${category.id}"
                                    onclick="filterByCategory('${category.id}')">
                                ${category.name}
                            </button>
                        </c:forEach>
                    </div>
                </div>

                <!-- Results Info -->
                <div id="resultsInfo" class="results-info">
                    <span id="resultsCount">${fn:length(products)}</span> món ăn
                </div>
            </div>
        </c:if>

        <!-- Empty State -->
        <c:if test="${empty products}">
            <div class="empty-state">
                <div class="empty-icon">🍽️</div>
                <h3>Chưa có món ăn nào</h3>
                <p>Hãy thêm món ăn đầu tiên vào menu của bạn</p>
                <button onclick="openAddModal()" class="btn btn-primary">
                    Thêm món ăn đầu tiên
                </button>
            </div>
        </c:if>

        <!-- Products Grid -->
        <c:if test="${not empty products}">
            <div class="products-grid" id="productsGrid">
                <c:forEach var="product" items="${products}">
                    <div class="product-card" 
                         data-product-name="${fn:toLowerCase(product.name)}"
                         data-product-description="${fn:toLowerCase(product.description)}"
                         data-category-id="${product.category.id}">
                        <div class="product-image">
                            <c:if test="${not empty product.image}">
                                <c:set var="imagePath" value="${product.image}"/>
                                <%-- Bước 1: Loại bỏ context path nếu có trong image path --%>
                                <c:if test="${fn:contains(imagePath, pageContext.request.contextPath)}">
                                    <c:set var="imagePath" value="${fn:substringAfter(imagePath, pageContext.request.contextPath)}"/>
                                </c:if>
                                <%-- Bước 2: Loại bỏ context path nếu có dạng /API_menu_online ở đầu --%>
                                <c:if test="${fn:startsWith(imagePath, '/API_menu_online')}">
                                    <c:set var="imagePath" value="${fn:substringAfter(imagePath, '/API_menu_online')}"/>
                                </c:if>
                                <%-- Bước 3: Loại bỏ context path nếu có dạng API_menu_online ở đầu (không có /) --%>
                                <c:if test="${fn:startsWith(imagePath, 'API_menu_online')}">
                                    <c:set var="imagePath" value="${fn:substringAfter(imagePath, 'API_menu_online')}"/>
                                </c:if>
                                <%-- Bước 4: Đảm bảo có /uploads/ prefix --%>
                                <c:choose>
                                    <c:when test="${imagePath.startsWith('/uploads/')}">
                                        <%-- Already has /uploads/ prefix, giữ nguyên --%>
                                    </c:when>
                                    <c:when test="${imagePath.startsWith('uploads/')}">
                                        <%-- Has uploads/ but missing leading slash --%>
                                        <c:set var="imagePath" value="/${imagePath}"/>
                                    </c:when>
                                    <c:when test="${imagePath.startsWith('/')}">
                                        <%-- Starts with / but not /uploads/, add /uploads --%>
                                        <c:set var="imagePath" value="/uploads${imagePath}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- No leading slash, add /uploads/ --%>
                                        <c:set var="imagePath" value="/uploads/${imagePath}"/>
                                    </c:otherwise>
                                </c:choose>
                                <c:set var="imageUrl" value="${pageContext.request.contextPath}${imagePath}"/>
                                <%-- Encode các ký tự đặc biệt quan trọng nhất (chỉ encode ký tự chưa được encode) --%>
                                <c:set var="encodedImageUrl" value="${imageUrl}"/>
                                <%-- Chỉ encode các ký tự đặc biệt nếu chúng chưa được encode (không có % phía trước) --%>
                                <c:set var="encodedImageUrl" value="${fn:replace(encodedImageUrl, ' ', '%20')}"/>
                                <c:set var="encodedImageUrl" value="${fn:replace(encodedImageUrl, '[', '%5B')}"/>
                                <c:set var="encodedImageUrl" value="${fn:replace(encodedImageUrl, ']', '%5D')}"/>
                                <c:set var="encodedImageUrl" value="${fn:replace(encodedImageUrl, '{', '%7B')}"/>
                                <c:set var="encodedImageUrl" value="${fn:replace(encodedImageUrl, '}', '%7D')}"/>
                                <c:set var="encodedImageUrl" value="${fn:replace(encodedImageUrl, '|', '%7C')}"/>
                                <%-- Backslash không cần encode trong URL, bỏ qua --%>
                                <c:set var="encodedImageUrl" value="${fn:replace(encodedImageUrl, '^', '%5E')}"/>
                                <c:set var="encodedImageUrl" value="${fn:replace(encodedImageUrl, '~', '%7E')}"/>
                                <c:set var="encodedImageUrl" value="${fn:replace(encodedImageUrl, '`', '%60')}"/>
                                <c:set var="encodedImageUrl" value="${fn:replace(encodedImageUrl, '<', '%3C')}"/>
                                <c:set var="encodedImageUrl" value="${fn:replace(encodedImageUrl, '>', '%3E')}"/>
                                <c:set var="encodedImageUrl" value="${fn:replace(encodedImageUrl, '#', '%23')}"/>
                                <c:set var="encodedImageUrl" value="${fn:replace(encodedImageUrl, '\"', '%22')}"/>
                                <%-- Sử dụng JavaScript để encode URL an toàn hơn nếu cần --%>
                                <img src="${encodedImageUrl}"
                                     alt="Product"
                                     data-original-path="${product.image}"
                                     data-raw-url="${imageUrl}"
                                     onload="this.onerror=null;"
                                     onerror="var img = this; var rawUrl = img.getAttribute('data-raw-url'); if (rawUrl && (rawUrl.indexOf(']') !== -1 || rawUrl.indexOf('[') !== -1 || rawUrl.indexOf(' ') !== -1)) { var encoded = encodeURI(rawUrl); if (encoded !== rawUrl) { img.src = encoded; return; } } console.error('Image load error:', img.src, 'Original:', img.getAttribute('data-original-path')); img.style.display='none'; img.nextElementSibling.style.display='flex';">
                            </c:if>
                            <div class="product-image-placeholder">🍴</div>
                            <form action="${pageContext.request.contextPath}/manage/products/toggle-status/${product.id}"
                                  method="post"
                                  class="status-toggle-form">
                                <c:if test="${not empty _csrf}">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                </c:if>
                                <input type="hidden" name="restaurantId" value="${restaurant.id}">
                                <button type="submit" 
                                        class="product-status-badge ${product.available ? 'badge-available' : 'badge-unavailable'}"
                                        title="Click để đổi trạng thái">
                                    <span>${product.available ? '✓ Có sẵn' : '✗ Hết hàng'}</span>
                                </button>
                            </form>
                        </div>
                        <div class="product-info">
                            <h3 class="product-name">${product.name}</h3>
                            <p class="product-category">${product.category.name}</p>
                            <p class="product-description">${product.description}</p>
                            <div class="product-price"><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0" groupingUsed="true"/> đ</div>
                        </div>
                        <div class="product-actions">
                            <button data-id="${product.id}" 
                                    data-name="${product.name}"
                                    data-description="${product.description}"
                                    data-price="${product.price}"
                                    data-category="${product.category.id}"
                                    data-available="${product.available}"
                                    data-image="${product.image}"
                                    onclick="editProduct(this.dataset)" 
                                    class="btn-action btn-warning">
                                ✏️ Sửa
                            </button>
                            <form action="${pageContext.request.contextPath}/manage/products/delete/${product.id}"
                                  method="post"
                                  style="display: inline;"
                                  onsubmit="return confirm('Xóa món ăn này?');">
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
<div id="productModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2 id="modalTitle">Thêm món ăn</h2>
            <button type="button" class="close-btn" onclick="closeModal()">✕</button>
        </div>

        <form action="${pageContext.request.contextPath}/manage/products/save" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </c:if>
            <input type="hidden" name="id" id="productId">
            <input type="hidden" name="restaurant.id" value="${restaurant.id}">
            <input type="hidden" name="image" id="productImage">

            <div class="form-group">
                <label for="productName">Tên món ăn *</label>
                <input type="text"
                       id="productName"
                       name="name"
                       placeholder="Ví dụ: Phở bò đặc biệt"
                       required>
            </div>

            <div class="form-group">
                <label for="productCategory">Danh mục *</label>
                <select id="productCategory" name="category.id" required>
                    <option value="">-- Chọn danh mục --</option>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.id}">${category.name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="productPrice">Giá (VNĐ) *</label>
                <input type="number"
                       id="productPrice"
                       name="price"
                       placeholder="50000"
                       min="0"
                       step="1000"
                       required>
            </div>

            <div class="form-group">
                <label for="productDescription">Mô tả</label>
                <textarea id="productDescription"
                          name="description"
                          rows="3"
                          placeholder="Mô tả ngắn về món ăn..."></textarea>
            </div>

            <div class="form-group">
                <label for="imageFile">Ảnh món ăn</label>
                <div class="image-upload">
                    <div class="image-preview" id="imagePreview">
                        <img id="previewImg" style="display: none;">
                        <div class="preview-placeholder">
                            <span>🖼️</span>
                            <p>Chưa có ảnh</p>
                        </div>
                    </div>
                    <label for="imageFile" class="btn btn-secondary btn-sm">
                        📤 Chọn ảnh
                    </label>
                    <input type="file"
                           id="imageFile"
                           name="imageFile"
                           accept="image/*"
                           autocomplete="off"
                           onchange="previewImage(this)"
                           style="display: none;"
                           aria-label="Chọn ảnh món ăn">
                    <p class="help-text">JPG, PNG. Tối đa 10MB</p>
                </div>
            </div>

            <div class="form-group">
                <label class="checkbox-label">
                    <input type="checkbox" 
                           id="productAvailable"
                           name="available"
                           checked>
                    <span class="checkbox-custom"></span>
                    <span class="checkbox-text">Món ăn có sẵn</span>
                </label>
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

    /* Page Header */
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
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
        color: var(--dark);
    }

    .info-card p {
        color: #4A5568;
        font-weight: 600;
        font-size: 14px;
        margin-top: 4px;
    }

    /* Search and Filter Section */
    .search-filter-section {
        background: white;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        margin-bottom: 30px;
    }

    .search-box-container {
        margin-bottom: 20px;
    }

    .search-box {
        position: relative;
        display: flex;
        align-items: center;
        background: #f8f9fa;
        border: 2px solid #e0e0e0;
        border-radius: 30px;
        padding: 12px 20px;
    }

    .search-icon {
        font-size: 18px;
        margin-right: 10px;
        color: #4A5568;
    }

    .search-box input {
        flex: 1;
        border: none;
        background: transparent;
        font-size: 15px;
        outline: none;
        color: var(--dark);
    }

    .search-box input::placeholder {
        color: #9CA3AF;
    }

    .search-box:focus-within {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(135, 206, 235, 0.15);
    }

    .search-clear-btn {
        background: none;
        border: none;
        font-size: 18px;
        color: #9CA3AF;
        cursor: pointer;
        padding: 0;
        width: 24px;
        height: 24px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
    }

    .search-clear-btn:hover {
        background: #e0e0e0;
        color: var(--dark);
    }

    .category-filter-container {
        margin-bottom: 15px;
    }

    .filter-label {
        display: block;
        font-weight: 600;
        color: var(--dark);
        font-size: 14px;
        margin-bottom: 10px;
    }

    .category-tabs {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
    }

    .category-tab {
        padding: 8px 16px;
        border: 2px solid #e0e0e0;
        background: white;
        border-radius: 20px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        color: #4A5568;
    }

    .category-tab:hover {
        border-color: var(--primary);
        color: var(--primary);
    }

    .category-tab.active {
        background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
        color: white;
        border-color: transparent;
        box-shadow: 0 2px 8px rgba(135, 206, 235, 0.3);
    }

    .results-info {
        color: #4A5568;
        font-size: 14px;
        font-weight: 600;
        text-align: right;
    }

    .product-card.hidden {
        display: none;
    }

    /* Products Grid */
    .products-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 20px;
    }

    .product-card {
        background: white;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }

    .product-image {
        height: 200px;
        position: relative;
        overflow: hidden;
        background: linear-gradient(135deg, #87CEEB 0%, #6BB6D6 100%);
    }

    .product-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .product-image-placeholder {
        width: 100%;
        height: 100%;
        display: none;
        align-items: center;
        justify-content: center;
        font-size: 80px;
        color: white;
    }

    .status-toggle-form {
        position: absolute;
        top: 10px;
        right: 10px;
        margin: 0;
    }

    .product-status-badge {
        padding: 8px 14px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: 600;
        border: none;
        cursor: pointer;
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    }

    .badge-available {
        background: rgba(40, 167, 69, 0.95);
        color: white;
    }

    .badge-available:hover {
        background: rgba(40, 167, 69, 1);
    }

    .badge-unavailable {
        background: rgba(220, 53, 69, 0.95);
        color: white;
    }

    .badge-unavailable:hover {
        background: rgba(220, 53, 69, 1);
    }

    .product-info {
        padding: 20px;
    }

    .product-name {
        font-size: 18px;
        font-weight: bold;
        color: var(--dark);
        margin-bottom: 8px;
    }

    .product-category {
        display: inline-block;
        padding: 4px 10px;
        background: #e3f2fd;
        color: #1565c0;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
        margin-bottom: 10px;
    }

    .product-description {
        color: #4A5568;
        font-weight: 600;
        font-size: 14px;
        margin-bottom: 15px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        min-height: 40px;
    }

    .product-price {
        font-size: 22px;
        font-weight: bold;
        color: #f5576c;
    }

    .product-actions {
        display: flex;
        gap: 10px;
        padding: 15px;
        background: var(--light);
        border-top: 1px solid var(--border);
    }

    .btn-action {
        flex: 1;
        padding: 10px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 13px;
        font-weight: 600;
        color: white;
    }

    .btn-warning {
        background: #ffc107;
        color: #000;
    }

    .btn-danger {
        background: #dc3545;
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
        background: white;
        border-radius: 16px;
        max-width: 600px;
        width: 90%;
        max-height: 90vh;
        overflow-y: auto;
    }

    .modal-header {
        padding: 25px 30px;
        border-bottom: 1px solid var(--border);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .modal-header h2 {
        font-size: 22px;
        color: var(--dark);
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
        font-weight: 600;
        font-size: 14px;
    }

    .form-group input[type="text"],
    .form-group input[type="number"],
    .form-group select,
    .form-group textarea {
        width: 100%;
        padding: 12px 16px;
        border: 2px solid var(--border);
        border-radius: 8px;
        font-size: 15px;
        font-family: inherit;
    }

    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
        outline: none;
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(135, 206, 235, 0.2);
    }

    .form-group textarea {
        resize: vertical;
    }

    /* Image Upload */
    .image-upload {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 15px;
    }

    .image-preview {
        width: 100%;
        height: 200px;
        border: 2px dashed var(--border);
        border-radius: 12px;
        overflow: hidden;
        background: var(--light);
    }

    .image-preview img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .preview-placeholder {
        width: 100%;
        height: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        color: #4A5568;
        font-weight: 600;
    }

    .preview-placeholder span {
        font-size: 50px;
        margin-bottom: 10px;
    }

    .help-text {
        color: #4A5568;
        font-weight: 600;
        font-size: 12px;
        text-align: center;
    }

    /* Checkbox */
    .checkbox-label {
        display: flex;
        align-items: center;
        gap: 12px;
        cursor: pointer;
    }

    .checkbox-label input[type="checkbox"] {
        display: none;
    }

    .checkbox-custom {
        width: 20px;
        height: 20px;
        border: 2px solid var(--border);
        border-radius: 4px;
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
        font-size: 14px;
        top: 50%;
        left: 50%;
        margin-left: -7px;
        margin-top: -10px;
    }

    .checkbox-text {
        color: var(--dark);
        font-size: 14px;
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

    .btn-sm {
        padding: 8px 16px;
        font-size: 13px;
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

        .products-grid {
            grid-template-columns: 1fr;
        }

        .product-actions {
            flex-direction: column;
        }
    }
</style>

<script>
    function openAddModal() {
        document.getElementById('modalTitle').textContent = 'Thêm món ăn';
        document.getElementById('productId').value = '';
        document.getElementById('productName').value = '';
        document.getElementById('productCategory').value = '';
        document.getElementById('productPrice').value = '';
        document.getElementById('productDescription').value = '';
        document.getElementById('productAvailable').checked = true;
        
        // Reset preview
        document.getElementById('previewImg').style.display = 'none';
        document.querySelector('.preview-placeholder').style.display = 'flex';
        
        document.getElementById('productModal').classList.add('active');
    }

    function editProduct(data) {
        document.getElementById('modalTitle').textContent = 'Sửa món ăn';
        document.getElementById('productId').value = data.id;
        document.getElementById('productName').value = data.name;
        document.getElementById('productCategory').value = data.category;
        document.getElementById('productPrice').value = data.price;
        document.getElementById('productDescription').value = data.description;
        document.getElementById('productAvailable').checked = data.available === 'true';
        
        // Lưu ảnh hiện tại vào hidden input để giữ nguyên khi không upload ảnh mới
        if (data.image) {
            document.getElementById('productImage').value = data.image;
            // Hiển thị ảnh hiện tại trong preview
            const previewImg = document.getElementById('previewImg');
            const previewPlaceholder = document.querySelector('.preview-placeholder');
            if (previewImg && data.image) {
                previewImg.src = '${pageContext.request.contextPath}' + data.image;
                previewImg.style.display = 'block';
                if (previewPlaceholder) {
                    previewPlaceholder.style.display = 'none';
                }
            }
        } else {
            document.getElementById('productImage').value = '';
            // Reset preview
            const previewImg = document.getElementById('previewImg');
            const previewPlaceholder = document.querySelector('.preview-placeholder');
            if (previewImg) {
                previewImg.style.display = 'none';
            }
            if (previewPlaceholder) {
                previewPlaceholder.style.display = 'flex';
            }
        }
        
        // Reset file input
        document.getElementById('imageFile').value = '';
        
        document.getElementById('productModal').classList.add('active');
    }

    function closeModal() {
        document.getElementById('productModal').classList.remove('active');
        // Reset form khi đóng modal
        document.getElementById('productId').value = '';
        document.getElementById('productImage').value = '';
        document.getElementById('imageFile').value = '';
        const previewImg = document.getElementById('previewImg');
        const previewPlaceholder = document.querySelector('.preview-placeholder');
        if (previewImg) {
            previewImg.style.display = 'none';
        }
        if (previewPlaceholder) {
            previewPlaceholder.style.display = 'flex';
        }
    }
    
    function openAddModal() {
        document.getElementById('modalTitle').textContent = 'Thêm món ăn';
        document.getElementById('productId').value = '';
        document.getElementById('productImage').value = '';
        document.getElementById('productName').value = '';
        document.getElementById('productCategory').value = '';
        document.getElementById('productPrice').value = '';
        document.getElementById('productDescription').value = '';
        document.getElementById('productAvailable').checked = true;
        document.getElementById('imageFile').value = '';
        const previewImg = document.getElementById('previewImg');
        const previewPlaceholder = document.querySelector('.preview-placeholder');
        if (previewImg) {
            previewImg.style.display = 'none';
        }
        if (previewPlaceholder) {
            previewPlaceholder.style.display = 'flex';
        }
        document.getElementById('productModal').classList.add('active');
    }

    function previewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                const img = document.getElementById('previewImg');
                img.src = e.target.result;
                img.style.display = 'block';
                document.querySelector('.preview-placeholder').style.display = 'none';
            }
            
            reader.readAsDataURL(input.files[0]);
        }
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('productModal');
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

    // ========== TÌM KIẾM VÀ LỌC MÓN ĂN ==========
    (function() {
        'use strict';
        
        const searchInput = document.getElementById('searchInput');
        const searchClear = document.getElementById('searchClear');
        const resultsInfo = document.getElementById('resultsInfo');
        const resultsCount = document.getElementById('resultsCount');
        const categoryTabs = document.querySelectorAll('.category-tab');
        
        let searchTerm = '';
        let selectedCategoryId = 'all';
        
        // Hàm lọc sản phẩm
        function filterProducts() {
            const allProducts = document.querySelectorAll('.product-card');
            let visibleCount = 0;
            
            allProducts.forEach(function(product) {
                const productName = (product.dataset.productName || '').toLowerCase();
                const productDescription = (product.dataset.productDescription || '').toLowerCase();
                const productCategoryId = String(product.dataset.categoryId || '');
                
                // Kiểm tra tìm kiếm
                const matchesSearch = searchTerm === '' || 
                                    productName.includes(searchTerm.toLowerCase()) || 
                                    productDescription.includes(searchTerm.toLowerCase());
                
                // Kiểm tra danh mục
                const matchesCategory = selectedCategoryId === 'all' || 
                                      productCategoryId === String(selectedCategoryId);
                
                // Hiển thị/ẩn sản phẩm
                if (matchesSearch && matchesCategory) {
                    product.classList.remove('hidden');
                    visibleCount++;
                } else {
                    product.classList.add('hidden');
                }
            });
            
            // Cập nhật số lượng kết quả
            if (resultsCount) {
                resultsCount.textContent = visibleCount;
            }
            
            // Hiển thị thông báo nếu không có kết quả
            const productsGrid = document.getElementById('productsGrid');
            if (productsGrid && visibleCount === 0) {
                if (!document.querySelector('.no-results-message')) {
                    const noResults = document.createElement('div');
                    noResults.className = 'no-results-message';
                    noResults.style.cssText = 'text-align: center; padding: 40px; color: #4A5568;';
                    noResults.innerHTML = '<div style="font-size: 48px; margin-bottom: 15px;">🔍</div><h3>Không tìm thấy món ăn nào</h3><p>Thử tìm kiếm với từ khóa khác hoặc chọn danh mục khác</p>';
                    productsGrid.parentNode.insertBefore(noResults, productsGrid.nextSibling);
                }
            } else {
                const noResults = document.querySelector('.no-results-message');
                if (noResults) {
                    noResults.remove();
                }
            }
        }
        
        // Xử lý tìm kiếm
        if (searchInput) {
            searchInput.addEventListener('input', function(e) {
                searchTerm = e.target.value.trim();
                
                // Hiển thị/ẩn nút xóa
                if (searchClear) {
                    searchClear.style.display = searchTerm ? 'flex' : 'none';
                }
                
                filterProducts();
            });
            
            // Xử lý phím Enter
            searchInput.addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                }
            });
        }
        
        // Xử lý nút xóa tìm kiếm
        if (searchClear) {
            searchClear.addEventListener('click', function() {
                if (searchInput) {
                    searchInput.value = '';
                    searchTerm = '';
                    searchClear.style.display = 'none';
                    filterProducts();
                    searchInput.focus();
                }
            });
        }
        
        // Hàm lọc theo danh mục
        window.filterByCategory = function(categoryId) {
            selectedCategoryId = categoryId;
            
            // Cập nhật active state cho các tab
            categoryTabs.forEach(function(tab) {
                if (tab.dataset.category === categoryId) {
                    tab.classList.add('active');
                } else {
                    tab.classList.remove('active');
                }
            });
            
            filterProducts();
        };
        
        // Khởi tạo
        filterProducts();
    })();
</script>
</body>
</html>

