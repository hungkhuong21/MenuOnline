<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Menu Online</title>
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

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3), 0 0 0 1px rgba(255, 255, 255, 0.2);
            width: 100%;
            max-width: 420px;
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

        .login-header {
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            padding: 48px 32px;
            text-align: center;
            color: white;
            box-shadow: 0 8px 24px rgba(37, 99, 235, 0.4);
            position: relative;
            overflow: hidden;
        }

        .login-header::before {
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

        .login-header h1 {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 12px;
            position: relative;
            z-index: 1;
        }

        .login-header p {
            opacity: 0.95;
            font-size: 15px;
            font-weight: 600;
            position: relative;
            z-index: 1;
        }

        .login-body {
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

        .form-group input {
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

        .form-group input:focus {
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

        .login-footer {
            text-align: center;
            padding: 20px;
            background: linear-gradient(135deg, rgba(219, 234, 254, 0.6) 0%, rgba(191, 219, 254, 0.4) 100%);
            font-size: 12px;
            color: #475569;
            backdrop-filter: blur(10px);
            font-weight: 500;
        }

        .icon {
            font-size: 60px;
            margin-bottom: 10px;
        }

        .register-link {
            margin-top: 24px;
            text-align: center;
            padding-top: 24px;
            border-top: 1px solid rgba(0, 0, 0, 0.08);
        }

        .register-link p {
            color: #475569;
            font-size: 14px;
            font-weight: 500;
            margin: 0;
        }

        .register-link a {
            color: #2563eb;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
        }

        .register-link a::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .register-link a:hover {
            color: #1e40af;
        }

        .register-link a:hover::after {
            width: 100%;
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-header">
        <div class="icon">🍽️</div>
        <h1>Menu Online</h1>
        <p>Hệ thống quản lý thực đơn</p>
    </div>

    <div class="login-body">
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <span>${error}</span>
            </div>
        </c:if>

        <c:if test="${not empty message}">
            <div class="alert alert-success">
                <span>${message}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" accept-charset="UTF-8">
            <div class="form-group">
                <label for="username">Tên đăng nhập</label>
                <input type="text"
                       id="username"
                       name="username"
                       placeholder="Nhập tên đăng nhập"
                       required
                       autofocus>
            </div>

            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password"
                       id="password"
                       name="password"
                       placeholder="Nhập mật khẩu"
                       required>
            </div>

            <button type="submit" class="btn">
                Đăng nhập
            </button>
        </form>

        <div class="register-link">
            <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></p>
        </div>
    </div>

    <div class="login-footer">
        <p>&copy; 2025 Menu Online System. All rights reserved.</p>
    </div>
</div>
</body>
</html>

