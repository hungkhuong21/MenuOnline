package com.example.API_menu_online.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Authentication Interceptor
 * Intercepts requests to protected pages and checks if user is logged in
 */
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            // User not logged in, redirect to login page
            response.sendRedirect(request.getContextPath() + "/login?message=required");
            return false;
        }
        
        // User is logged in, allow request to continue
        return true;
    }
}

