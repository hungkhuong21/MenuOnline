<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu Online - Quản lý thực đơn thông minh</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-x: hidden;
        }

        /* Navbar */
        .navbar {
            position: fixed;
            top: 0;
            width: 100%;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 15px 0;
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
            z-index: 1000;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 24px;
            font-weight: bold;
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .nav-buttons {
            display: flex;
            gap: 15px;
        }

        .btn {
            padding: 10px 25px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-outline {
            background: transparent;
            color: #2563eb;
            border: 2px solid #2563eb;
            font-weight: 600;
        }

        .btn-outline:hover {
            background: #2563eb;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(37, 99, 235, 0.4);
        }

        .btn-primary {
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            color: white;
            font-weight: 600;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(37, 99, 235, 0.45);
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
        }

        /* Hero Section */
        .hero {
            margin-top: 80px;
            min-height: 90vh;
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
        }

        .hero::before {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            top: -250px;
            right: -250px;
        }

        .hero::after {
            content: '';
            position: absolute;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            bottom: -200px;
            left: -200px;
        }

        .hero-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 80px 30px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
            position: relative;
            z-index: 1;
        }

        .hero-content h1 {
            font-size: 56px;
            color: white;
            margin-bottom: 25px;
            line-height: 1.2;
        }

        .hero-content p {
            font-size: 20px;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 35px;
            line-height: 1.6;
        }

        .hero-buttons {
            display: flex;
            gap: 20px;
        }

        .btn-large {
            padding: 16px 40px;
            font-size: 18px;
        }

        .btn-white {
            background: white;
            color: #2563eb;
            font-weight: 600;
        }

        .btn-white:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
            background: #f8fafc;
        }

        .hero-image {
            text-align: center;
            font-size: 200px;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }

        /* Features Section */
        .features {
            padding: 100px 30px;
            background: #f8f9fa;
        }

        .section-title {
            text-align: center;
            margin-bottom: 60px;
        }

        .section-title h2 {
            font-size: 42px;
            color: #0f172a;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .section-title p {
            font-size: 18px;
            color: #475569;
            font-weight: 500;
        }

        .features-grid {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
        }

        .feature-card {
            background: white;
            padding: 40px 30px;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            transition: all 0.3s;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .feature-icon {
            font-size: 60px;
            margin-bottom: 20px;
        }

        .feature-card h3 {
            font-size: 24px;
            color: #0f172a;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .feature-card p {
            color: #475569;
            line-height: 1.6;
            font-weight: 500;
        }

        /* How it works */
        .how-it-works {
            padding: 100px 30px;
            background: white;
        }

        .steps-container {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
        }

        .step-card {
            text-align: center;
            padding: 30px;
        }

        .step-number {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            font-weight: bold;
            margin: 0 auto 20px;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }

        .step-card h3 {
            font-size: 20px;
            color: #0f172a;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .step-card p {
            color: #475569;
            line-height: 1.5;
            font-weight: 500;
        }

        /* CTA Section */
        .cta {
            padding: 80px 30px;
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            text-align: center;
        }

        .cta h2 {
            font-size: 42px;
            color: white;
            margin-bottom: 20px;
            font-weight: 700;
        }

        .cta p {
            font-size: 20px;
            color: rgba(255, 255, 255, 0.95);
            margin-bottom: 35px;
            font-weight: 500;
        }

        /* Footer */
        .footer {
            background: #1e293b;
            color: white;
            padding: 40px 30px;
            text-align: center;
            font-weight: 500;
        }

        .footer p {
            margin-bottom: 10px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero-container {
                grid-template-columns: 1fr;
                text-align: center;
            }

            .hero-content h1 {
                font-size: 36px;
            }

            .hero-image {
                font-size: 120px;
            }

            .nav-buttons {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
<!-- Navbar -->
<nav class="navbar">
    <div class="nav-container">
        <div class="logo">
            <span>🍽️</span>
            <span>Menu Online</span>
        </div>
        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Đăng nhập</a>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Đăng ký miễn phí</a>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<section class="hero">
    <div class="hero-container">
        <div class="hero-content">
            <h1>Quản lý thực đơn thông minh cho nhà hàng</h1>
            <p>Tạo menu điện tử chuyên nghiệp với mã QR. Khách hàng quét và xem menu ngay trên điện thoại!</p>
            <div class="hero-buttons">
                <a href="${pageContext.request.contextPath}/register" class="btn btn-white btn-large">Bắt đầu miễn phí</a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline btn-large" style="border-color: white; color: white;">Đăng nhập</a>
            </div>
        </div>
        <div class="hero-image">
            🍕📱
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="features">
    <div class="section-title">
        <h2>Tính năng nổi bật</h2>
        <p>Mọi thứ bạn cần để quản lý menu hiệu quả</p>
    </div>
    <div class="features-grid">
        <div class="feature-card">
            <div class="feature-icon">📱</div>
            <h3>Mã QR thông minh</h3>
            <p>Tạo mã QR cho từng nhà hàng. Khách chỉ cần quét để xem menu đầy đủ</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🍔</div>
            <h3>Quản lý món ăn</h3>
            <p>Thêm, sửa, xóa món ăn dễ dàng. Upload ảnh, mô tả và giá chỉ với vài click</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">📊</div>
            <h3>Thống kê chi tiết</h3>
            <p>Theo dõi số lượt xem menu, phân tích hành vi khách hàng</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">⚡</div>
            <h3>Cập nhật realtime</h3>
            <p>Thay đổi menu và khách hàng thấy ngay lập tức mà không cần in lại</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🎨</div>
            <h3>Giao diện đẹp</h3>
            <p>Menu hiển thị chuyên nghiệp, responsive mọi thiết bị</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🔒</div>
            <h3>Bảo mật cao</h3>
            <p>Dữ liệu được bảo vệ an toàn, chỉ bạn mới quản lý được</p>
        </div>
    </div>
</section>

<!-- How it works -->
<section class="how-it-works">
    <div class="section-title">
        <h2>Cách thức hoạt động</h2>
        <p>Chỉ 4 bước đơn giản để bắt đầu</p>
    </div>
    <div class="steps-container">
        <div class="step-card">
            <div class="step-number">1</div>
            <h3>Đăng ký tài khoản</h3>
            <p>Miễn phí và chỉ mất 30 giây</p>
        </div>
        <div class="step-card">
            <div class="step-number">2</div>
            <h3>Thêm nhà hàng</h3>
            <p>Nhập thông tin cơ bản về quán của bạn</p>
        </div>
        <div class="step-card">
            <div class="step-number">3</div>
            <h3>Tạo thực đơn</h3>
            <p>Thêm danh mục và món ăn với ảnh đẹp</p>
        </div>
        <div class="step-card">
            <div class="step-number">4</div>
            <h3>Tải QR & In</h3>
            <p>Đặt mã QR trên bàn để khách quét</p>
        </div>
    </div>
</section>

<!-- CTA -->
<section class="cta">
    <h2>Sẵn sàng bắt đầu?</h2>
    <p>Tham gia cùng hàng trăm nhà hàng đã tin dùng Menu Online</p>
    <a href="${pageContext.request.contextPath}/register" class="btn btn-white btn-large">Đăng ký ngay - Miễn phí</a>
</section>

<!-- Footer -->
<footer class="footer">
    <p><strong>Menu Online</strong> - Giải pháp menu điện tử thông minh</p>
    <p>&copy; 2025 Menu Online System. All rights reserved.</p>
</footer>
</body>
</html>

