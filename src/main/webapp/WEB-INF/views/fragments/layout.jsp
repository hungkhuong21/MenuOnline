<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<c:if test="${not empty _csrf}">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
</c:if>
<title>${not empty title ? title : 'Menu Online'}</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
<style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary: #2563eb;
            --primary-dark: #1e40af;
            --primary-light: #3b82f6;
            --primary-very-light: #dbeafe;
            --secondary: #7c3aed;
            --secondary-dark: #6d28d9;
            --accent: #06b6d4;
            --success: #10b981;
            --success-dark: #059669;
            --danger: #ef4444;
            --danger-dark: #dc2626;
            --warning: #f59e0b;
            --warning-dark: #d97706;
            --info: #06b6d4;
            --info-dark: #0891b2;
            --dark: #1e293b;
            --dark-light: #334155;
            --light: #f1f5f9;
            --light-gray: #e2e8f0;
            --white: #ffffff;
            --gray: #64748b;
            --gray-light: #94a3b8;
            --border: #cbd5e1;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --shadow-sm: 0 2px 4px rgba(37, 99, 235, 0.1);
            --shadow: 0 4px 12px rgba(37, 99, 235, 0.15);
            --shadow-md: 0 8px 24px rgba(37, 99, 235, 0.2);
            --shadow-lg: 0 16px 48px rgba(37, 99, 235, 0.25);
            --shadow-xl: 0 24px 64px rgba(37, 99, 235, 0.3);
        }

        body {
            font-family: 'Inter', 'Segoe UI', -apple-system, BlinkMacSystemFont, 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', sans-serif;
            background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 50%, #93c5fd 100%);
            background-attachment: fixed;
            min-height: 100vh;
            line-height: 1.6;
            color: var(--text-primary);
        }

        /* Navbar */
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            color: var(--text-primary);
            padding: 0;
            box-shadow: 0 4px 20px rgba(37, 99, 235, 0.25);
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 2px solid rgba(37, 99, 235, 0.3);
        }

        .navbar-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 24px;
            font-weight: 700;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-decoration: none;
        }

        .navbar-brand span:first-child {
            font-size: 32px;
            filter: drop-shadow(0 2px 4px rgba(135, 206, 235, 0.4));
        }

        .navbar-user {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info {
            text-align: right;
        }

        .user-name {
            font-weight: 600;
            font-size: 16px;
            color: var(--text-primary);
        }

        .user-role {
            font-size: 11px;
            font-weight: 600;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            display: inline-block;
            margin-top: 4px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 8px rgba(135, 206, 235, 0.3);
        }

        .btn-logout {
            padding: 10px 24px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            border: none;
            color: white;
            border-radius: 12px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            box-shadow: 0 4px 12px rgba(135, 206, 235, 0.3);
        }

        /* Main Layout */
        .main-layout {
            display: flex;
            min-height: calc(100vh - 70px);
        }

        /* Sidebar */
        .sidebar {
            width: 280px;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            box-shadow: 4px 0 20px rgba(135, 206, 235, 0.15);
            padding: 24px 0;
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
            gap: 14px;
            padding: 14px 28px;
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 15px;
            font-weight: 500;
            position: relative;
            margin: 4px 12px;
            border-radius: 12px;
        }

        .sidebar-menu a::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            margin-top: -15px;
            width: 4px;
            height: 0;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            border-radius: 0 4px 4px 0;
        }

        .sidebar-menu a:hover {
            background: linear-gradient(90deg, rgba(37, 99, 235, 0.15) 0%, transparent 100%);
            color: var(--primary-dark);
            font-weight: 600;
        }

        .sidebar-menu a:hover::before {
            height: 60%;
        }

        .sidebar-menu a.active {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.2) 0%, rgba(30, 64, 175, 0.15) 100%);
            color: var(--primary-dark);
            font-weight: 700;
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.25);
        }

        .sidebar-menu a.active::before {
            height: 100%;
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

        /* Content Area */
        .content {
            flex: 1;
            padding: 40px;
            max-width: 1600px;
            margin: 0 auto;
            width: 100%;
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .sidebar {
                display: none;
            }

            .content {
                padding: 15px;
            }

            .navbar-container {
                padding: 15px 20px;
            }

            .navbar-brand {
                font-size: 18px;
            }

            .user-name {
                display: none;
            }
        }

        /* Utilities */
        .page-header {
            margin-bottom: 32px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 20px;
        }

        .page-header h1 {
            font-size: 36px;
            font-weight: 700;
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
            line-height: 1.2;
            text-shadow: 0 2px 4px rgba(135, 206, 235, 0.1);
        }

        .page-header p {
            color: var(--text-secondary);
            font-size: 16px;
            font-weight: 600;
        }

        .alert {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
            box-shadow: var(--shadow-sm);
        }

        .alert-success {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.15) 0%, rgba(16, 185, 129, 0.25) 100%);
            color: #065f46;
            border-left: 4px solid var(--success);
            backdrop-filter: blur(10px);
            font-weight: 600;
        }

        .alert-error {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.15) 0%, rgba(239, 68, 68, 0.25) 100%);
            color: #991b1b;
            border-left: 4px solid var(--danger);
            backdrop-filter: blur(10px);
            font-weight: 600;
        }

        .alert-info {
            background: linear-gradient(135deg, rgba(6, 182, 212, 0.15) 0%, rgba(6, 182, 212, 0.25) 100%);
            color: #164e63;
            border-left: 4px solid var(--info);
            backdrop-filter: blur(10px);
            font-weight: 600;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: var(--shadow);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.35);
            font-weight: 600;
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.95);
            color: var(--text-primary);
            border: 2px solid var(--primary-light);
            backdrop-filter: blur(10px);
            font-weight: 600;
        }

        .btn-secondary:hover {
            background: var(--primary-very-light);
            border-color: var(--primary);
            color: var(--primary-dark);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
        }
    </style>

