package com.example.API_menu_online.util;

import com.example.API_menu_online.entity.User;
import com.example.API_menu_online.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Helper class để lấy thông tin user từ session
 * Tránh code trùng lặp getCurrentUser() ở nhiều Controller
 */
@Component
public class UserContextHelper {

    private final UserService userService;

    @Autowired
    public UserContextHelper(UserService userService) {
        this.userService = userService;
    }

    /**
     * Lấy user hiện tại từ session
     * @param session HttpSession
     * @return User hoặc null nếu chưa đăng nhập
     */
    public User getCurrentUser(HttpSession session) {
        if (session != null && session.getAttribute("userId") != null) {
            Long userId = (Long) session.getAttribute("userId");
            return userService.getById(userId).orElse(null);
        }
        return null;
    }
}

