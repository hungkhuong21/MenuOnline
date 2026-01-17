package com.example.API_menu_online.controller;

import com.example.API_menu_online.entity.Category;
import com.example.API_menu_online.entity.MenuViewLog;
import com.example.API_menu_online.entity.Product;
import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.service.CategoryService;
import com.example.API_menu_online.service.MenuViewLogService;
import com.example.API_menu_online.service.ProductService;
import com.example.API_menu_online.service.RestaurantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.*;

@Controller
public class MenuViewController {

    private final RestaurantService restaurantService;
    private final MenuViewLogService menuViewLogService;
    private final CategoryService categoryService;
    private final ProductService productService;

    @Autowired
    public MenuViewController(RestaurantService restaurantService,
                             MenuViewLogService menuViewLogService,
                             CategoryService categoryService,
                             ProductService productService) {
        this.restaurantService = restaurantService;
        this.menuViewLogService = menuViewLogService;
        this.categoryService = categoryService;
        this.productService = productService;
    }

    @GetMapping("/restaurant/{id}/menu")
    public String showMenu(@PathVariable("id") Long id, Model model, HttpServletRequest request) {
        Optional<Restaurant> optRestaurant = restaurantService.getById(id);

        if (optRestaurant.isEmpty()) {
            model.addAttribute("errorMessage", "Nhà hàng không tồn tại");
            return "common/error";
        }

        Restaurant restaurant = optRestaurant.get();

        // Kiểm tra nhà hàng có đang hoạt động không
        if (restaurant.getIsActive() == null || !restaurant.getIsActive()) {
            model.addAttribute("errorMessage", "Nhà hàng hiện không hoạt động");
            return "common/error";
        }

        // Ghi log lượt xem
        try {
            MenuViewLog log = new MenuViewLog();
            log.setRestaurant(restaurant);
            log.setViewTime(LocalDateTime.now());
            log.setIpAddress(getClientIP(request));
            log.setUserAgent(request.getHeader("User-Agent"));

            menuViewLogService.save(log);
        } catch (Exception e) {
            System.err.println("Error saving view log: " + e.getMessage());
        }

        // Lấy danh sách categories và products
        List<Category> categories = categoryService.getByRestaurant(restaurant);
        List<Product> products = productService.getByRestaurant(restaurant);

        model.addAttribute("restaurant", restaurant);
        model.addAttribute("categories", categories);
        model.addAttribute("products", products);

        return "public/menu";
    }

    private String getClientIP(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }
}