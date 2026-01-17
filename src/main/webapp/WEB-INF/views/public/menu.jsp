<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <c:if test="${not empty _csrf}">
        <meta name="_csrf" content="${_csrf.token}"/>
        <meta name="_csrf_header" content="${_csrf.headerName}"/>
    </c:if>
    <title>${restaurant.name} - Thực đơn</title>
    <style>
        /* ========== RESET CSS ========== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* ========== BODY & BACKGROUND ========== */
        /* Nền gradient xanh dương đẹp mắt cho toàn bộ trang */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            min-height: 100vh;
            padding: 10px;
        }

        /* ========== CONTAINER CHÍNH ========== */
        /* Container chứa toàn bộ nội dung menu, có nền trắng và bo tròn */
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            margin-bottom: 20px;
        }

        /* ========== HEADER (PHẦN ĐẦU TRANG) ========== */
        /* Header hiển thị logo, tên và mô tả nhà hàng với gradient xanh dương */
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 20px;
            text-align: center;
            position: relative;
            box-shadow: 0 4px 16px rgba(102, 126, 234, 0.4);
        }

        /* Logo container - chứa logo nhà hàng */
        .logo-container {
            margin-bottom: 20px;
        }

        /* Logo nhà hàng - hình tròn với viền trắng */
        .logo {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            margin: 0 auto;
            border: 5px solid white;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            display: block;
        }

        /* Placeholder logo khi không có ảnh - hiển thị icon emoji */
        .logo-placeholder {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
            margin: 0 auto;
            border: 5px solid white;
        }

        /* Tiêu đề tên nhà hàng */
        .header h1 {
            font-size: 32px;
            margin-bottom: 10px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }

        /* Mô tả nhà hàng */
        .header p {
            font-size: 16px;
            opacity: 0.95;
        }

        /* ========== DANH MỤC (CATEGORY TABS) ========== */
        /* Thanh cuộn ngang chứa các tab danh mục món ăn */
        .category-tabs {
            display: flex;
            overflow-x: auto;
            background: #f8f9fa;
            padding: 15px 20px;
            gap: 10px;
            border-bottom: 2px solid #e0e0e0;
            -webkit-overflow-scrolling: touch;
        }

        /* Thanh cuộn ngang cho category tabs */
        .category-tabs::-webkit-scrollbar {
            height: 4px;
        }

        /* Màu thanh cuộn - gradient tím */
        .category-tabs::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 4px;
        }

        /* Tab danh mục - nút chọn danh mục món ăn */
        .category-tab {
            padding: 10px 20px;
            background: white;
            border: 2px solid #cbd5e1;
            border-radius: 25px;
            cursor: pointer;
            white-space: nowrap;
            font-weight: 600;
            font-size: 14px;
            color: #0f172a;
            -webkit-tap-highlight-color: transparent;
            touch-action: manipulation;
            user-select: none;
            -webkit-user-select: none;
        }

        /* Hiệu ứng hover cho tab danh mục */
        .category-tab:hover {
            border-color: #667eea;
            color: #667eea;
        }

        /* Tab danh mục đang được chọn - gradient tím */
        .category-tab.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.35);
        }

        /* ========== TÌM KIẾM (SEARCH) ========== */
        /* Container chứa ô tìm kiếm */
        .search-container {
            padding: 20px;
            background: white;
            border-bottom: 2px solid #e0e0e0;
        }

        /* Ô tìm kiếm - bo tròn với nền xám nhạt */
        .search-box {
            position: relative;
            display: flex;
            align-items: center;
            background: #f8f9fa;
            border: 2px solid #e0e0e0;
            border-radius: 30px;
            padding: 12px 20px;
        }

        /* Hiệu ứng khi focus vào ô tìm kiếm - đổi màu viền tím */
        .search-box:focus-within {
            border-color: #667eea;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.25);
            background: white;
        }

        /* Icon tìm kiếm - màu tím */
        .search-icon {
            font-size: 20px;
            margin-right: 12px;
            color: #667eea;
        }

        .search-input {
            flex: 1;
            border: none;
            outline: none;
            background: transparent;
            font-size: 16px;
            color: #0f172a;
            font-weight: 500;
        }

        .search-input::placeholder {
            color: #6B7280;
        }

        .search-clear {
            background: #e0e0e0;
            border: none;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            color: #4A5568;
            font-size: 14px;
            margin-left: 10px;
        }

        /* Hiệu ứng hover cho nút xóa tìm kiếm - đổi màu tím */
        .search-clear:hover {
            background: #667eea;
            color: white;
        }

        /* Thông báo kết quả tìm kiếm - nền xanh nhạt */
        .search-results-info {
            margin-top: 12px;
            padding: 8px 16px;
            background: #e0e7ff;
            border-radius: 20px;
            font-size: 14px;
            color: #6366f1;
            text-align: center;
        }

        .product-card.hidden {
            display: none !important;
        }

        .category-section {
            display: block;
        }

        .category-section.hidden {
            display: none !important;
        }

        /* Menu Content */
        .menu-content {
            padding: 25px 20px;
        }

        .category-section {
            margin-bottom: 40px;
        }

        /* Tiêu đề danh mục - có gạch chân màu tím */
        .category-title {
            font-size: 24px;
            color: #0f172a;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 3px solid #667eea;
            display: inline-block;
            font-weight: 700;
        }

        /* ========== SẢN PHẨM (PRODUCT) ========== */
        /* Lưới hiển thị các sản phẩm */
        .product-grid {
            display: grid;
            gap: 20px;
        }

        .product-card {
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 16px;
            overflow: hidden;
            display: flex;
            gap: 15px;
        }

        /* Container ảnh sản phẩm - gradient tím làm nền */
        .product-image-container {
            width: 140px;
            height: 140px;
            flex-shrink: 0;
            position: relative;
            overflow: hidden;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .product-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .product-image-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 50px;
        }

        .product-status-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }

        .status-available {
            background: rgba(40, 167, 69, 0.9);
        }

        .status-unavailable {
            background: rgba(220, 53, 69, 0.9);
        }

        .product-info {
            flex: 1;
            padding: 15px 15px 15px 0;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .product-name {
            font-size: 18px;
            font-weight: bold;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .product-description {
            font-size: 14px;
            color: #475569;
            line-height: 1.5;
            margin-bottom: 12px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            font-weight: 500;
        }

        .product-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Giá sản phẩm - màu đỏ cam nổi bật */
        .product-price {
            font-size: 22px;
            font-weight: bold;
            color: #f97316;
        }

        .product-availability {
            font-size: 12px;
            padding: 4px 12px;
            border-radius: 12px;
            font-weight: 600;
        }

        .available {
            background: #d1fae5;
            color: #065f46;
            font-weight: 600;
        }

        .unavailable {
            background: #fee2e2;
            color: #991b1b;
            font-weight: 600;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6B7280;
        }

        .empty-icon {
            font-size: 80px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 20px;
            color: #475569;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .empty-state p {
            color: #64748b;
            font-weight: 500;
        }

        /* Footer */
        .footer {
            background: #f8f9fa;
            padding: 25px 20px;
            text-align: center;
            color: #4A5568;
            border-top: 1px solid #e0e0e0;
        }

        .footer-icon {
            font-size: 24px;
            margin-bottom: 10px;
        }

        .footer p {
            font-size: 14px;
            margin-bottom: 5px;
        }

        .powered-by {
            font-size: 12px;
            color: #6B7280;
            margin-top: 15px;
        }

        .powered-by strong {
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 700;
        }

        /* Responsive */
        @media (max-width: 600px) {
            .header h1 {
                font-size: 26px;
            }

            .logo, .logo-placeholder {
                width: 100px;
                height: 100px;
            }

            .product-card {
                flex-direction: column;
            }

            .product-image-container {
                width: 100%;
                height: 200px;
            }

            .product-info {
                padding: 15px;
            }

            .category-title {
                font-size: 20px;
            }
        }


        /* ========== NÚT THÊM VÀO GIỎ HÀNG ========== */
        /* Nút thêm món vào giỏ hàng - gradient tím */
        .btn-add-cart {
            padding: 8px 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
        }

        /* ========== NÚT GIỎ HÀNG NỔI (FLOATING) ========== */
        /* Nút giỏ hàng cố định ở góc phải dưới - gradient tím */
        .cart-float-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            border: none;
            color: white;
            font-size: 28px;
            cursor: pointer;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Badge hiển thị số lượng món trong giỏ - màu cam đỏ */
        .cart-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #f97316;
            color: white;
            border-radius: 50%;
            width: 28px;
            height: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
        }

        /* Cart Modal */
        .cart-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 2000;
            align-items: center;
            justify-content: center;
        }

        .cart-modal.active {
            display: flex;
        }

        .cart-content {
            background: white;
            border-radius: 20px;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .cart-header {
            padding: 20px;
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 600;
        }

        .cart-header h2 {
            margin: 0;
            font-size: 22px;
        }

        .cart-close {
            background: none;
            border: none;
            color: white;
            font-size: 28px;
            cursor: pointer;
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }

        .cart-close:hover {
            background: rgba(255,255,255,0.2);
        }

        .cart-body {
            padding: 20px;
            overflow-y: auto;
            flex: 1;
        }

        .cart-item {
            display: flex;
            gap: 15px;
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
            align-items: center;
        }

        .cart-item:last-child {
            border-bottom: none;
        }

        .cart-item-info {
            flex: 1;
        }

        .cart-item-name {
            font-weight: 600;
            margin-bottom: 5px;
        }

        /* Giá món trong giỏ hàng - màu cam đỏ */
        .cart-item-price {
            color: #f97316;
            font-weight: 600;
        }

        .cart-item-quantity {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .quantity-btn {
            width: 30px;
            height: 30px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 6px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Hiệu ứng hover cho nút tăng/giảm số lượng - viền tím */
        .quantity-btn:hover {
            background: #f1f5f9;
            border-color: #667eea;
        }

        .quantity-value {
            min-width: 30px;
            text-align: center;
            font-weight: 600;
        }

        /* Nút xóa món khỏi giỏ hàng - màu cam đỏ */
        .cart-item-remove {
            background: none;
            border: none;
            color: #f97316;
            cursor: pointer;
            font-size: 20px;
            padding: 5px;
        }

        .cart-empty {
            text-align: center;
            padding: 40px 20px;
            color: #6B7280;
        }

        .cart-footer {
            padding: 20px;
            border-top: 2px solid #e0e0e0;
            background: #f8f9fa;
        }

        .cart-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            font-size: 20px;
            font-weight: bold;
        }

        .cart-total-label {
            color: #4A5568;
        }

        /* Tổng tiền trong giỏ hàng - màu cam đỏ */
        .cart-total-amount {
            color: #f97316;
            font-size: 24px;
        }

        /* Nút gọi món - gradient tím */
        .btn-checkout {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
        }

        .btn-checkout:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        /* ========== FORM ĐẶT MÓN (ORDER FORM) ========== */
        /* Modal form đặt món - overlay đen mờ */
        .order-form-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 3000;
            align-items: center;
            justify-content: center;
        }

        .order-form-modal.active {
            display: flex;
        }

        .order-form-content {
            background: white;
            border-radius: 20px;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
            padding: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #0f172a;
        }

        /* Dấu sao cho trường bắt buộc - màu cam đỏ */
        .form-label.required::after {
            content: " *";
            color: #f97316;
        }

        .form-input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            font-family: inherit;
        }

        /* Hiệu ứng focus cho input - viền tím */
        .form-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.15);
        }

        .form-textarea {
            min-height: 80px;
            resize: vertical;
        }

        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 25px;
        }

        .btn-cancel {
            flex: 1;
            padding: 12px;
            background: #f1f5f9;
            color: #0f172a;
            border: 2px solid #cbd5e1;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
        }

        .btn-cancel:hover {
            background: #e9ecef;
        }

        /* Nút xác nhận đặt món - gradient tím */
        .btn-submit {
            flex: 2;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
        }

        .btn-submit:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .alert {
            padding: 12px 15px;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 2px solid #10b981;
            font-weight: 600;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 2px solid #ef4444;
            font-weight: 600;
        }

        @media (max-width: 600px) {
            .cart-float-btn {
                bottom: 20px;
                right: 20px;
                width: 60px;
                height: 60px;
                font-size: 24px;
            }

            .cart-content {
                width: 95%;
                max-height: 95vh;
            }

            .order-form-content {
                width: 95%;
                padding: 20px;
            }
        }
    </style>
</head>
<body>
<!-- ========== JAVASCRIPT - CÁC HÀM TOÀN CỤC ========== -->
<!-- Các hàm này phải được định nghĩa trước khi HTML onclick handlers được parse -->
<script>
    // Định nghĩa tất cả các hàm toàn cục ngay lập tức để tránh lỗi "is not defined"
    (function() {
        'use strict';
        
        // ========== KHỞI TẠO DỮ LIỆU ==========
        // Lấy ID nhà hàng từ JSP
        const restaurantId = <c:choose><c:when test="${not empty restaurant.id}">${restaurant.id}</c:when><c:otherwise>0</c:otherwise></c:choose>;
        
        // Lấy giỏ hàng từ localStorage hoặc tạo mới nếu chưa có
        let cart = JSON.parse(localStorage.getItem('cart_' + restaurantId)) || [];
        
        // Chuẩn hóa dữ liệu giỏ hàng - đảm bảo tất cả số được parse đúng kiểu
        cart = cart.map(item => ({
            productId: parseInt(item.productId) || 0,
            productName: String(item.productName || ''),
            productPrice: parseFloat(item.productPrice) || 0,
            quantity: parseInt(item.quantity) || 1
        })).filter(item => item.productId > 0 && item.productName);
        
        // Expose giỏ hàng ra window để các script khác có thể truy cập
        window.__cart = cart;
        window.__restaurantId = restaurantId;
        
        // ========== HÀM HỖ TRỢ ==========
        // Lưu giỏ hàng vào localStorage
        function saveCart() {
            try {
                localStorage.setItem('cart_' + restaurantId, JSON.stringify(cart));
            } catch (e) {
                console.error('Lỗi khi lưu giỏ hàng:', e);
            }
        }
        
        // Định dạng giá tiền theo định dạng Việt Nam (ví dụ: 100.000)
        function formatPrice(price) {
            const num = parseFloat(price);
            if (isNaN(num) || num < 0) {
                return '0';
            }
            return Math.round(num).toLocaleString('vi-VN');
        }
        
        // ========== CÁC HÀM GIỎ HÀNG ==========
        // Hàm này phải là global để onclick handlers có thể gọi
        // Thêm món vào giỏ hàng
        window.addToCart = function(btn) {
            try {
                const productId = parseInt(btn.getAttribute('data-product-id') || btn.dataset.productId);
                const productName = btn.getAttribute('data-product-name') || btn.dataset.productName;
                const productPrice = parseFloat(btn.getAttribute('data-product-price') || btn.dataset.productPrice);
                
                if (!productId || !productName || isNaN(productPrice)) {
                    alert('Lỗi: Không thể lấy thông tin sản phẩm. Vui lòng thử lại!');
                    return;
                }
                
                const existingItem = cart.find(item => item.productId === productId);
                if (existingItem) {
                    existingItem.quantity += 1;
                } else {
                    cart.push({
                        productId: productId,
                        productName: productName,
                        productPrice: productPrice,
                        quantity: 1
                    });
                }
                
                saveCart();
                window.__cart = cart; // Update global reference
                if (window.updateCartUI) {
                    window.updateCartUI();
                }
                
                // Hiển thị phản hồi khi thêm thành công
                const originalText = btn.textContent;
                const originalBg = btn.style.background;
                btn.textContent = '✓ Đã thêm';
                btn.style.background = '#10b981'; // Màu xanh lá
                btn.disabled = true;
                setTimeout(() => {
                    btn.textContent = originalText;
                    btn.style.background = originalBg;
                    btn.disabled = false;
                }, 1000);
            } catch (error) {
                console.error('Lỗi khi thêm vào giỏ hàng:', error);
                alert('Lỗi khi thêm món vào giỏ hàng. Vui lòng thử lại!');
            }
        };
        
        // Mở modal giỏ hàng
        window.openCart = function() {
            // Đồng bộ giỏ hàng từ window trước khi mở
            cart = window.__cart || cart;
            window.__cart = cart;
            
            // Cập nhật UI trước khi mở modal
            if (window.updateCartUI) {
                window.updateCartUI();
            }
            
            const cartModal = document.getElementById('cartModal');
            if (cartModal) {
                cartModal.classList.add('active');
            }
        };
        
        // Đóng modal giỏ hàng
        window.closeCart = function() {
            const cartModal = document.getElementById('cartModal');
            if (cartModal) {
                cartModal.classList.remove('active');
            }
        };
        
        // Xóa món khỏi giỏ hàng
        window.removeFromCart = function(productId) {
            // Lấy giỏ hàng mới nhất từ window để đảm bảo đồng bộ
            cart = window.__cart || cart;
            
            // Chuẩn hóa productId thành số
            const productIdNum = parseInt(productId) || 0;
            if (productIdNum === 0) {
                console.error('ProductId không hợp lệ:', productId);
                return;
            }
            
            // Lọc bỏ món có productId trùng
            cart = cart.filter(item => parseInt(item.productId) !== productIdNum);
            
            // Chuẩn hóa giỏ hàng trước khi lưu
            cart = cart.map(item => ({
                productId: parseInt(item.productId) || 0,
                productName: String(item.productName || ''),
                productPrice: parseFloat(item.productPrice) || 0,
                quantity: parseInt(item.quantity) || 1
            })).filter(item => item.productId > 0 && item.productName);
            
            saveCart();
            window.__cart = cart; // Cập nhật tham chiếu toàn cục
            if (window.updateCartUI) {
                window.updateCartUI();
            }
        };
        
        // Cập nhật số lượng món trong giỏ hàng
        window.updateQuantity = function(productId, change) {
            // Lấy giỏ hàng mới nhất từ window để đảm bảo đồng bộ
            cart = window.__cart || cart;
            
            // Chuẩn hóa productId và change thành số
            const productIdNum = parseInt(productId) || 0;
            const changeNum = parseInt(change) || 0;
            
            if (productIdNum === 0 || changeNum === 0) {
                console.error('ProductId hoặc change không hợp lệ:', productId, change);
                return;
            }
            
            const item = cart.find(item => parseInt(item.productId) === productIdNum);
            if (item) {
                // Đảm bảo quantity là số
                item.quantity = parseInt(item.quantity) || 1;
                item.quantity += changeNum;
                
                // Nếu số lượng <= 0 thì xóa món khỏi giỏ
                if (item.quantity <= 0) {
                    window.removeFromCart(productIdNum);
                } else {
                    // Chuẩn hóa giỏ hàng trước khi lưu
                    cart = cart.map(i => ({
                        productId: parseInt(i.productId) || 0,
                        productName: String(i.productName || ''),
                        productPrice: parseFloat(i.productPrice) || 0,
                        quantity: parseInt(i.quantity) || 1
                    })).filter(i => i.productId > 0 && i.productName);
                    
                    saveCart();
                    window.__cart = cart; // Cập nhật tham chiếu toàn cục
                    if (window.updateCartUI) {
                        window.updateCartUI();
                    }
                }
            } else {
                console.error('Không tìm thấy món trong giỏ hàng:', productIdNum);
            }
        };
        
        // Mở form đặt món
        window.openOrderForm = function() {
            if (cart.length === 0) {
                alert('Giỏ hàng trống!');
                return;
            }
            window.closeCart();
            const orderFormModal = document.getElementById('orderFormModal');
            if (orderFormModal) {
                orderFormModal.classList.add('active');
            }
        };
        
        // Đóng form đặt món
        window.closeOrderForm = function() {
            const orderFormModal = document.getElementById('orderFormModal');
            if (orderFormModal) {
                orderFormModal.classList.remove('active');
            }
            const alertDiv = document.getElementById('orderAlert');
            if (alertDiv) {
                alertDiv.innerHTML = '';
            }
        };
        
        // Lưu giỏ hàng và restaurantId vào window để sử dụng sau
        window.__cart = cart;
        window.__restaurantId = restaurantId;
        window.__saveCart = saveCart;
        window.__formatPrice = formatPrice;
    })();
</script>

<!-- ========== CONTAINER CHÍNH ========== -->
<div class="container">
    <!-- ========== HEADER (PHẦN ĐẦU TRANG) ========== -->
    <!-- Hiển thị logo, tên và mô tả nhà hàng -->
    <div class="header">
        <div class="logo-container">
            <c:if test="${not empty restaurant.logo}">
                <img src="${pageContext.request.contextPath}${restaurant.logo}"
                     alt="Logo"
                     class="logo"
                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
            </c:if>
            <c:if test="${empty restaurant.logo}">
                <div class="logo-placeholder">🍽️</div>
            </c:if>
        </div>
        <h1>${restaurant.name}</h1>
        <p>${restaurant.description}</p>
    </div>

    <!-- ========== DANH MỤC (CATEGORY TABS) ========== -->
    <!-- Thanh cuộn ngang chứa các tab danh mục món ăn -->
    <c:if test="${not empty categories}">
        <div class="category-tabs">
            <button type="button" class="category-tab active" data-category="all">
                📋 Tất cả
            </button>
            <c:forEach var="category" items="${categories}">
                <button type="button" class="category-tab" data-category="${category.id}">
                    ${category.name}
                </button>
            </c:forEach>
        </div>
    </c:if>

    <!-- ========== TÌM KIẾM (SEARCH BOX) ========== -->
    <!-- Ô tìm kiếm món ăn theo tên -->
    <div class="search-container">
        <div class="search-box">
            <span class="search-icon">🔍</span>
            <input type="text" 
                   id="searchInput" 
                   class="search-input" 
                   placeholder="Tìm kiếm món ăn theo tên..."
                   autocomplete="off">
            <button type="button" class="search-clear" id="searchClear" style="display: none;">✕</button>
        </div>
        <div class="search-results-info" id="searchResultsInfo" style="display: none;"></div>
    </div>

    <!-- ========== NỘI DUNG MENU ========== -->
    <div class="menu-content">
        <!-- Trạng thái trống - khi chưa có sản phẩm nào -->
        <c:if test="${empty products}">
            <div class="empty-state">
                <div class="empty-icon">🍽️</div>
                <h3>Chưa có món ăn nào</h3>
                <p>Menu đang được cập nhật, vui lòng quay lại sau</p>
            </div>
        </c:if>

        <!-- Hiển thị sản phẩm theo danh mục -->
        <c:if test="${not empty products}">
            <c:forEach var="category" items="${categories}">
                <!-- Section cho từng danh mục -->
                <div class="category-section" id="category-${category.id}">
                    <h2 class="category-title">${category.name}</h2>
                    
                    <!-- Lưới hiển thị các sản phẩm -->
                    <div class="product-grid">
                        <c:forEach var="product" items="${products}">
                            <c:if test="${product.category.id == category.id}">
                                <!-- Card sản phẩm -->
                                <div class="product-card" 
                                     data-category="${category.id}"
                                     data-product-name="${product.name}"
                                     data-product-description="${product.description}">
                                    <div class="product-image-container">
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
                                            <%-- Encode URL để xử lý ký tự đặc biệt --%>
                                            <c:set var="imageUrl" value="${pageContext.request.contextPath}${imagePath}"/>
                                            <%-- Encode các ký tự đặc biệt quan trọng nhất (chỉ encode ký tự chưa được encode) --%>
                                            <c:set var="encodedImageUrl" value="${imageUrl}"/>
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
                                                 alt="${product.name}"
                                                 class="product-image"
                                                 loading="lazy"
                                                 data-original-path="${product.image}"
                                                 data-raw-url="${imageUrl}"
                                                 onload="this.onerror=null;"
                                                 onerror="var img = this; var rawUrl = img.getAttribute('data-raw-url'); if (rawUrl && (rawUrl.indexOf(']') !== -1 || rawUrl.indexOf('[') !== -1 || rawUrl.indexOf(' ') !== -1)) { var encoded = encodeURI(rawUrl); if (encoded !== rawUrl) { img.src = encoded; return; } } console.error('Image load error:', img.src, 'Original:', img.getAttribute('data-original-path')); img.onerror = null; img.style.display = 'none'; var placeholder = img.nextElementSibling; if (placeholder && placeholder.classList.contains('product-image-placeholder')) { placeholder.style.display = 'flex'; }">
                                            <div class="product-image-placeholder" style="display: none;">🍴</div>
                                        </c:if>
                                        <c:if test="${empty product.image}">
                                            <div class="product-image-placeholder">🍴</div>
                                        </c:if>
                                        <span class="product-status-badge ${product.available ? 'status-available' : 'status-unavailable'}">
                                            ${product.available ? 'Còn hàng' : 'Hết hàng'}
                                        </span>
                                    </div>
                                    <div class="product-info">
                                        <div>
                                            <h3 class="product-name">${product.name}</h3>
                                            <p class="product-description">${product.description}</p>
                                        </div>
                                        <div class="product-footer">
                                            <span class="product-price"><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0" groupingUsed="true"/> đ</span>
                                            <div style="display: flex; align-items: center; gap: 10px;">
                                                <span class="product-availability ${product.available ? 'available' : 'unavailable'}">
                                                    ${product.available ? '✓ Có sẵn' : '✗ Hết'}
                                                </span>
                                                <c:if test="${product.available}">
                                                    <button data-product-id="${product.id}"
                                                            data-product-name="${product.name}"
                                                            data-product-price="${product.price}"
                                                            onclick="addToCart(this)"
                                                            class="btn-add-cart">
                                                        ➕ Thêm
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
        </c:if>
    </div>

    <!-- ========== FOOTER (CHÂN TRANG) ========== -->
    <!-- Hiển thị thông tin nhà hàng và powered by -->
    <div class="footer">
        <div class="footer-icon">🍽️</div>
        <p><strong>${restaurant.name}</strong></p>
        <p>${restaurant.address}</p>
        <p class="powered-by">Powered by <strong>Menu Online</strong></p>
    </div>
</div>

<!-- ========== NÚT GIỎ HÀNG NỔI (FLOATING) ========== -->
<!-- Nút giỏ hàng cố định ở góc phải dưới màn hình -->
<button class="cart-float-btn" onclick="openCart()">
    🛒
    <span class="cart-badge" id="cartBadge" style="display: none;">0</span>
</button>

<!-- ========== MODAL GIỎ HÀNG ========== -->
<!-- Popup hiển thị danh sách món đã thêm vào giỏ -->
<div class="cart-modal" id="cartModal">
    <div class="cart-content">
        <div class="cart-header">
            <h2>🛒 Giỏ hàng</h2>
            <button class="cart-close" onclick="closeCart()">&times;</button>
        </div>
        <div class="cart-body" id="cartBody">
            <div class="cart-empty">
                <div style="font-size: 60px; margin-bottom: 15px;">🛒</div>
                <h3>Giỏ hàng trống</h3>
                <p>Thêm món vào giỏ để gọi món</p>
            </div>
        </div>
        <div class="cart-footer" id="cartFooter" style="display: none;">
            <div class="cart-total">
                <span class="cart-total-label">Tổng cộng:</span>
                <span class="cart-total-amount" id="cartTotal">0 đ</span>
            </div>
            <button class="btn-checkout" onclick="openOrderForm()">💳 gọi món</button>
        </div>
    </div>
</div>

<!-- ========== MODAL FORM ĐẶT MÓN ========== -->
<!-- Popup form nhập thông tin khách hàng để đặt món -->
<div class="order-form-modal" id="orderFormModal">
    <div class="order-form-content">
        <h2 style="margin-bottom: 20px; color: #0f172a; font-weight: 700;">📝 Thông tin gọi món</h2>
        <div id="orderAlert"></div>
        <form id="orderForm" onsubmit="submitOrder(event)">
            <div class="form-group">
                <label class="form-label required">Tên khách hàng</label>
                <input type="text" name="customerName" class="form-input" required
                       placeholder="Nhập tên của bạn">
            </div>
            <div class="form-group">
                <label class="form-label required">Số điện thoại</label>
                <input type="tel" name="customerPhone" class="form-input" required
                       placeholder="0123456789" pattern="[0-9]{10,11}">
            </div>
            <div class="form-group">
                <label class="form-label">Bàn số</label>
                <input type="text" name="customerAddress" class="form-input"
                       placeholder="Ví dụ: Bàn 5, Bàn 12, Khu VIP...">
            </div>
            <div class="form-group">
                <label class="form-label">Ghi chú</label>
                <textarea name="note" class="form-input form-textarea"
                          placeholder="Ghi chú thêm cho nhà hàng..."></textarea>
            </div>
            <div class="form-actions">
                <button type="button" class="btn-cancel" onclick="closeOrderForm()">Hủy</button>
                <button type="submit" class="btn-submit" id="submitBtn">✅ Xác nhận gọi món</button>
            </div>
        </form>
    </div>
</div>

<script>
    // ========== MAIN SCRIPT - Uses functions defined in head script ==========
    
    // Get variables from global scope
    const restaurantId = window.__restaurantId || <c:choose><c:when test="${not empty restaurant.id}">${restaurant.id}</c:when><c:otherwise>0</c:otherwise></c:choose>;
    let cart = window.__cart || JSON.parse(localStorage.getItem('cart_' + restaurantId)) || [];

    // Normalize cart data - ensure all numbers are properly typed
    cart = cart.map(item => ({
        productId: parseInt(item.productId) || 0,
        productName: String(item.productName || ''),
        productPrice: parseFloat(item.productPrice) || 0,
        quantity: parseInt(item.quantity) || 1
    })).filter(item => item.productId > 0 && item.productName);
        
    const saveCart = window.__saveCart || function() {
        try {
            localStorage.setItem('cart_' + restaurantId, JSON.stringify(cart));
        } catch (e) {
            console.error('Error saving cart:', e);
        }
    };
    const formatPrice = window.__formatPrice || function(price) {
        const num = parseFloat(price);
        if (isNaN(num) || num < 0) {
            return '0';
        }
        return Math.round(num).toLocaleString('vi-VN');
    };

    // Update cart reference in window
    window.__cart = cart;

    function updateCartUI() {
        // Always get latest cart from window to ensure sync
        let currentCart = window.__cart || cart;
        
        // Normalize cart data - ensure all numbers are properly typed
        currentCart = currentCart.map(item => ({
            productId: parseInt(item.productId) || 0,
            productName: String(item.productName || ''),
            productPrice: parseFloat(item.productPrice) || 0,
            quantity: parseInt(item.quantity) || 1
        })).filter(item => item.productId > 0 && item.productName);
        
        cart = currentCart;
        window.__cart = cart;
        
        const cartBody = document.getElementById('cartBody');
        const cartFooter = document.getElementById('cartFooter');
        const cartBadge = document.getElementById('cartBadge');
        const cartTotal = document.getElementById('cartTotal');

        if (!cartBody || !cartFooter || !cartBadge || !cartTotal) {
            console.warn('Cart elements not found, retrying...');
            setTimeout(updateCartUI, 100);
            return;
        }

        if (currentCart.length === 0) {
            cartBody.innerHTML = `
                <div class="cart-empty">
                    <div style="font-size: 60px; margin-bottom: 15px;">🛒</div>
                    <h3>Giỏ hàng trống</h3>
                    <p>Thêm món vào giỏ để gọi món</p>
                </div>
            `;
            cartFooter.style.display = 'none';
            cartBadge.style.display = 'none';
        } else {
            let total = 0;
            let html = '';
            
            currentCart.forEach(item => {
                const itemTotal = item.productPrice * item.quantity;
                total += itemTotal;
                
                html += '<div class="cart-item">' +
                    '<div class="cart-item-info">' +
                    '<div class="cart-item-name">' + item.productName + '</div>' +
                    '<div class="cart-item-price">' + formatPrice(item.productPrice) + ' đ</div>' +
                    '</div>' +
                    '<div class="cart-item-quantity">' +
                    '<button class="quantity-btn" onclick="updateQuantity(' + item.productId + ', -1)">−</button>' +
                    '<span class="quantity-value">' + item.quantity + '</span>' +
                    '<button class="quantity-btn" onclick="updateQuantity(' + item.productId + ', 1)">+</button>' +
                    '</div>' +
                    '<button class="cart-item-remove" onclick="removeFromCart(' + item.productId + ')" title="Xóa">🗑️</button>' +
                    '</div>';
            });
            
            cartBody.innerHTML = html;
            cartFooter.style.display = 'block';
            cartTotal.textContent = formatPrice(total) + ' đ';
            
            const totalItems = currentCart.reduce((sum, item) => sum + item.quantity, 0);
            cartBadge.textContent = totalItems;
            cartBadge.style.display = totalItems > 0 ? 'flex' : 'none';
        }
        
        // Update local cart reference
        cart = currentCart;
    }
    
    // Expose updateCartUI to window so it can be called from other scripts
    window.updateCartUI = updateCartUI;

    // Sync cart with global reference
    cart = window.__cart || cart;
    
    // Override cart functions to sync with global cart
    const originalAddToCart = window.addToCart;
    window.addToCart = function(btn) {
        originalAddToCart(btn);
        cart = window.__cart;
        updateCartUI();
    };
    
    const originalRemoveFromCart = window.removeFromCart;
    window.removeFromCart = function(productId) {
        originalRemoveFromCart(productId);
        cart = window.__cart;
        updateCartUI();
    };
    
    const originalUpdateQuantity = window.updateQuantity;
    window.updateQuantity = function(productId, change) {
        originalUpdateQuantity(productId, change);
        cart = window.__cart;
        updateCartUI();
    };

    window.submitOrder = async function(event) {
        event.preventDefault();
        
        const form = event.target;
        const submitBtn = document.getElementById('submitBtn');
        const alertDiv = document.getElementById('orderAlert');
        
        submitBtn.disabled = true;
        submitBtn.textContent = '⏳ Đang xử lý...';
        
        const orderData = {
            restaurantId: restaurantId,
            customerName: form.customerName.value.trim(),
            customerPhone: form.customerPhone.value.trim(),
            customerAddress: form.customerAddress.value.trim(),
            note: form.note.value.trim(),
            items: cart.map(item => ({
                productId: item.productId,
                quantity: item.quantity
            }))
        };

        try {
            // Get CSRF token
            const csrfToken = document.querySelector('meta[name="_csrf"]')?.content || '';
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content || 'X-CSRF-TOKEN';
            const contextPath = '${pageContext.request.contextPath}';
            
            const response = await fetch(contextPath + '/orders/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    [csrfHeader]: csrfToken
                },
                body: JSON.stringify(orderData)
            });

            // Check if response is JSON
            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                const text = await response.text();
                throw new Error('Server trả về lỗi không phải JSON. Vui lòng thử lại!');
            }

            const result = await response.json();

            if (response.ok && result.success) {
                // Get message and ensure it's a string
                let successMessage = 'Cảm ơn bạn đã đặt món. Nhà hàng sẽ xử lý đơn hàng của bạn sớm nhất!';
                if (result.message && typeof result.message === 'string' && result.message.trim() !== '') {
                    successMessage = result.message;
                }
                
                // Show success message
                alertDiv.innerHTML = '<div class="alert alert-success" style="font-size: 16px; padding: 15px;">' +
                    '✅ <strong>Đã gọi món thành công!</strong><br>' +
                    successMessage +
                    '</div>';
                
                // Clear cart completely
                cart = [];
                window.__cart = [];
                saveCart();
                
                // Update cart UI immediately
                if (window.updateCartUI) {
                    window.updateCartUI();
                }
                
                // Close cart modal if open
                const cartModal = document.getElementById('cartModal');
                if (cartModal) {
                    cartModal.classList.remove('active');
                }
                
                // Reset form
                form.reset();
                
                // Show alert notification
                alert('✅ Đã gọi món thành công!\n\nCảm ơn bạn đã đặt món. Nhà hàng sẽ xử lý đơn hàng của bạn sớm nhất!');
                
                // Close order form modal after 2 seconds
                setTimeout(() => {
                    window.closeOrderForm();
                    alertDiv.innerHTML = '';
                }, 2000);
            } else {
                alertDiv.innerHTML = `
                    <div class="alert alert-error">
                        ❌ ${result.error || 'Có lỗi xảy ra, vui lòng thử lại!'}
                    </div>
                `;
            }
        } catch (error) {
            alertDiv.innerHTML = `
                <div class="alert alert-error">
                    ❌ Lỗi kết nối: ${error.message}
                </div>
            `;
        } finally {
            submitBtn.disabled = false;
            submitBtn.textContent = '✅ Xác nhận gọi món';
        }
    };

    // Wait for DOM to be ready before initializing event listeners
    document.addEventListener('DOMContentLoaded', function() {
        console.log('DOM loaded, initializing menu...');
        
        // Sync cart from window and localStorage
        let rawCart = window.__cart || JSON.parse(localStorage.getItem('cart_' + restaurantId)) || [];
        
        // Normalize cart data - ensure all numbers are properly typed
        cart = rawCart.map(item => ({
            productId: parseInt(item.productId) || 0,
            productName: String(item.productName || ''),
            productPrice: parseFloat(item.productPrice) || 0,
            quantity: parseInt(item.quantity) || 1
        })).filter(item => item.productId > 0 && item.productName);
        
        window.__cart = cart;
        
        // Improve image error handling - hide broken images silently
        // Prevent 404 errors from showing in console by handling them gracefully
        const allImages = document.querySelectorAll('.product-image');
        allImages.forEach(function(img) {
            // Set up error handler before image loads
            img.addEventListener('error', function() {
                try {
                    this.style.display = 'none';
                    const placeholder = this.nextElementSibling;
                    if (placeholder && placeholder.classList.contains('product-image-placeholder')) {
                        placeholder.style.display = 'flex';
                    }
                } catch (e) {
                    // Silently ignore errors in error handler
                }
            }, { once: true, passive: true });
            
            // Also handle load event to show image if it loads successfully
            img.addEventListener('load', function() {
                const placeholder = this.nextElementSibling;
                if (placeholder && placeholder.classList.contains('product-image-placeholder')) {
                    placeholder.style.display = 'none';
                }
            }, { once: true, passive: true });
        });
        
        // Load cart on page load - ensure UI is updated
        setTimeout(function() {
            updateCartUI();
        }, 100);

    // Close modals when clicking outside
        const cartModal = document.getElementById('cartModal');
        if (cartModal) {
            cartModal.addEventListener('click', function(e) {
        if (e.target === this) {
            closeCart();
        }
    });
        }

        const orderFormModal = document.getElementById('orderFormModal');
        if (orderFormModal) {
            orderFormModal.addEventListener('click', function(e) {
        if (e.target === this) {
            closeOrderForm();
        }
    });
        }

        // ========== SEARCH AND FILTER FUNCTIONALITY ==========
        (function() {
            'use strict';
            
            // Get DOM elements
    const searchInput = document.getElementById('searchInput');
    const searchClear = document.getElementById('searchClear');
    const searchResultsInfo = document.getElementById('searchResultsInfo');
            const categoryTabs = document.querySelectorAll('.category-tab');
            
            // State
            let searchTerm = '';
            let selectedCategoryId = 'all';
            
            // Filter products based on search and category
    function filterProducts() {
        const allProducts = document.querySelectorAll('.product-card');
        const allSections = document.querySelectorAll('.category-section');
        let visibleCount = 0;

                allProducts.forEach(function(product) {
            const productName = (product.dataset.productName || '').toLowerCase();
            const productDescription = (product.dataset.productDescription || '').toLowerCase();
                    const productCategory = String(product.dataset.category || '');
            
                    // Check search match
                    const matchesSearch = searchTerm === '' || 
                                        productName.includes(searchTerm) || 
                                        productDescription.includes(searchTerm);
            
                    // Check category match
                    const matchesCategory = selectedCategoryId === 'all' || 
                                          productCategory === String(selectedCategoryId);

                    // Show/hide product
            if (matchesSearch && matchesCategory) {
                product.classList.remove('hidden');
                visibleCount++;
            } else {
                product.classList.add('hidden');
            }
        });

                // Show/hide category sections
                allSections.forEach(function(section) {
                    const visibleProducts = section.querySelectorAll('.product-card:not(.hidden)');
                    if (visibleProducts.length > 0) {
                section.classList.remove('hidden');
                section.style.display = 'block';
            } else {
                section.classList.add('hidden');
                section.style.display = 'none';
            }
        });

                // Update search results info
                if (searchResultsInfo) {
                    if (searchTerm.length > 0) {
            if (visibleCount === 0) {
                            searchResultsInfo.textContent = 'Không tìm thấy món nào với từ khóa "' + searchTerm + '"';
                searchResultsInfo.style.background = '#ffebee';
                searchResultsInfo.style.color = '#c62828';
            } else {
                            searchResultsInfo.textContent = 'Tìm thấy ' + visibleCount + ' món với từ khóa "' + searchTerm + '"';
                searchResultsInfo.style.background = '#e3f2fd';
                searchResultsInfo.style.color = '#1976d2';
            }
            searchResultsInfo.style.display = 'block';
        } else {
            searchResultsInfo.style.display = 'none';
        }
                }
    }

            // Clear search
            function clearSearch() {
                if (searchInput) {
                    searchInput.value = '';
                    searchTerm = '';
                }
                if (searchClear) {
                    searchClear.style.display = 'none';
                }
                if (searchResultsInfo) {
                    searchResultsInfo.style.display = 'none';
                }
                filterProducts();
                if (searchInput) {
                    searchInput.focus();
                }
            }
            
            // Handle search input
            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    searchTerm = searchInput.value.trim().toLowerCase();
                    if (searchClear) {
                        searchClear.style.display = searchTerm.length > 0 ? 'flex' : 'none';
                    }
                    filterProducts();
                });
                
                searchInput.addEventListener('keydown', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        filterProducts();
                    }
                });
                
    searchInput.addEventListener('keyup', function(e) {
        if (e.key === 'Escape') {
            clearSearch();
        }
    });
            }
            
            // Clear button
            if (searchClear) {
                searchClear.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    clearSearch();
                });
            }
            
            // Category tabs
            if (categoryTabs.length > 0) {
                categoryTabs.forEach(function(tab) {
                    function handleCategoryClick(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        
                        const categoryId = tab.getAttribute('data-category') || tab.dataset.category || 'all';
                        selectedCategoryId = categoryId;

                        // Update active state
                        categoryTabs.forEach(function(t) {
                            t.classList.remove('active');
                        });
            tab.classList.add('active');

                        // Filter products
            filterProducts();

                        // Scroll to top
            window.scrollTo({ top: 0, behavior: 'smooth' });
                    }
                    
                    tab.addEventListener('click', handleCategoryClick);
                    tab.addEventListener('touchend', function(e) {
                        e.preventDefault();
                        handleCategoryClick(e);
                    });
                });
            }
        })();
    });
    
    // Log that all functions are defined
    console.log('Menu functions initialized:', {
        addToCart: typeof window.addToCart !== 'undefined',
        openCart: typeof window.openCart !== 'undefined',
        closeCart: typeof window.closeCart !== 'undefined',
        removeFromCart: typeof window.removeFromCart !== 'undefined',
        updateQuantity: typeof window.updateQuantity !== 'undefined'
    });
</script>
</body>
</html>

