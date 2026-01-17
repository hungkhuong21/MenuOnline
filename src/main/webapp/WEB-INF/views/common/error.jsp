<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #87CEEB 0%, #6BB6D6 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .error-container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            text-align: center;
            max-width: 500px;
        }
        .error-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
        h1 {
            color: #f5576c;
            margin-bottom: 15px;
        }
        p {
            color: #666;
            font-size: 16px;
            line-height: 1.6;
        }
    </style>
</head>
<body>
<div class="error-container">
    <div class="error-icon">⚠️</div>
    <h1>Đã xảy ra lỗi</h1>
    <p>${not empty errorMessage ? errorMessage : 'Không tìm thấy trang bạn yêu cầu'}</p>
</div>
</body>
</html>

