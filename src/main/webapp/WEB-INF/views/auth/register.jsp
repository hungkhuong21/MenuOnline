<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Menu Online</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', -apple-system, BlinkMacSystemFont, 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', sans-serif;
            background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 50%, #93c5fd 100%);
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .register-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(37, 99, 235, 0.35), 0 0 0 1px rgba(255, 255, 255, 0.2);
            width: 100%;
            max-width: 520px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.3);
            animation: slideUp 0.5s cubic-bezier(0.4, 0, 0.2, 1);
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(40px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .register-header {
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            padding: 48px 32px;
            text-align: center;
            color: white;
            box-shadow: 0 8px 24px rgba(37, 99, 235, 0.4);
            position: relative;
            overflow: hidden;
        }

        .register-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: rotate 20s linear infinite;
        }

        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .register-header h1 {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 12px;
            position: relative;
            z-index: 1;
        }

        .register-header p {
            opacity: 0.95;
            font-size: 15px;
            font-weight: 600;
            position: relative;
            z-index: 1;
        }

        .register-body {
            padding: 48px 32px;
            background: rgba(255, 255, 255, 0.5);
        }

        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .alert-error {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.15) 0%, rgba(239, 68, 68, 0.25) 100%);
            color: #991b1b;
            border: 2px solid rgba(239, 68, 68, 0.4);
            backdrop-filter: blur(10px);
            font-weight: 600;
        }

        .alert-success {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.15) 0%, rgba(16, 185, 129, 0.25) 100%);
            color: #065f46;
            border: 2px solid rgba(16, 185, 129, 0.4);
            backdrop-filter: blur(10px);
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #0f172a;
            font-weight: 600;
            font-size: 14px;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid rgba(0, 0, 0, 0.15);
            border-radius: 12px;
            font-size: 15px;
            font-weight: 500;
            color: #0f172a;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: rgba(255, 255, 255, 0.95);
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.2);
            background: white;
            transform: translateY(-2px);
        }

        .btn {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 16px rgba(37, 99, 235, 0.35);
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .btn:hover::before {
            width: 300px;
            height: 300px;
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 32px rgba(37, 99, 235, 0.45);
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
        }

        .btn:active {
            transform: translateY(-1px);
        }

        .register-footer {
            text-align: center;
            padding: 20px;
            background: linear-gradient(135deg, rgba(219, 234, 254, 0.6) 0%, rgba(191, 219, 254, 0.4) 100%);
            font-size: 14px;
            color: #475569;
            backdrop-filter: blur(10px);
            font-weight: 500;
        }

        .register-footer a {
            color: #2563eb;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s;
        }

        .register-footer a:hover {
            color: #1e40af;
            text-decoration: underline;
        }

        .icon {
            font-size: 60px;
            margin-bottom: 10px;
        }

        .required {
            color: #ef4444;
        }
    </style>
</head>
<body>
<div class="register-container">
    <div class="register-header">
        <div class="icon">🍽️</div>
        <h1>Đăng ký tài khoản</h1>
        <p>Tạo tài khoản để quản lý menu nhà hàng</p>
    </div>

    <div class="register-body">
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" accept-charset="UTF-8">
            <div class="form-group">
                <label for="username">Tên đăng nhập <span class="required">*</span></label>
                <input type="text"
                       id="username"
                       name="username"
                       placeholder="Chọn tên đăng nhập"
                       required
                       minlength="3"
                       maxlength="50">
            </div>

            <div class="form-group">
                <label for="password">Mật khẩu <span class="required">*</span></label>
                <input type="password"
                       id="password"
                       name="password"
                       placeholder="Tạo mật khẩu mạnh"
                       required
                       minlength="6">
            </div>

            <div class="form-group">
                <label for="fullName">Họ và tên <span class="required">*</span></label>
                <input type="text"
                       id="fullName"
                       name="fullName"
                       placeholder="Nhập họ tên đầy đủ"
                       required>
            </div>

            <div class="form-group">
                <label for="email">Email <span class="required">*</span></label>
                <input type="email"
                       id="email"
                       name="email"
                       placeholder="email@example.com"
                       required>
            </div>

            <div class="form-group">
                <label for="phone">Số điện thoại</label>
                <input type="tel"
                       id="phone"
                       name="phone"
                       placeholder="0123456789"
                       pattern="[0-9]{10,11}">
            </div>

            <button type="submit" class="btn">
                Đăng ký ngay
            </button>
        </form>
    </div>

    <div class="register-footer">
        <p>Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a></p>
        <p style="margin-top: 10px;"><a href="${pageContext.request.contextPath}/">← Quay về trang chủ</a></p>
    </div>
</div>
</body>
</html>

