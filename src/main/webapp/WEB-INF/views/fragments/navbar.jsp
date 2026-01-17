<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar">
    <div class="navbar-container">
        <a href="${pageContext.request.contextPath}/dashboard" class="navbar-brand">
            <span>🍽️</span>
            <span>Menu Online</span>
        </a>
        <c:if test="${not empty user}">
            <div class="navbar-user">
                <div class="user-info">
                    <div class="user-name">${user.fullName}</div>
                    <span class="user-role">${user.role}</span>
                </div>
                <form action="${pageContext.request.contextPath}/logout" method="post" style="margin: 0;">
                    <button type="submit" class="btn-logout">Đăng xuất</button>
                </form>
            </div>
        </c:if>
    </div>
</nav>

