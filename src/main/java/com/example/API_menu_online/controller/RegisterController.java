package com.example.API_menu_online.controller;

import com.example.API_menu_online.entity.User;
import com.example.API_menu_online.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;

/**
 * Controller xử lý chức năng ĐĂNG KÝ tài khoản merchant.
 * - GET /register: hiển thị form đăng ký
 * - POST /register: nhận dữ liệu form, validate và tạo user mới
 */
@Controller
public class RegisterController {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public RegisterController(UserService userService, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }

    /**
     * Hiển thị trang đăng ký tài khoản merchant.
     */
    @GetMapping("/register")
    public String registerPage() {
        return "auth/register";
    }

    /**
     * Xử lý submit form đăng ký:
     * - Validate dữ liệu đầu vào (độ dài username/password)
     * - Kiểm tra username đã tồn tại hay chưa
     * - Nếu hợp lệ: tạo user mới với role MERCHANT và mã hóa password bằng BCrypt
     * - Lưu user qua UserService và chuyển hướng sang trang login
     */
    @PostMapping(value = "/register", produces = "text/html;charset=UTF-8", consumes = "application/x-www-form-urlencoded;charset=UTF-8")
    public String register(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            @RequestParam("fullName") String fullName,
            @RequestParam("email") String email,
            @RequestParam(value = "phone", required = false) String phone,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {
        

        try {
            // Validation cơ bản: kiểm tra độ dài username và password
            if (username.length() < 3) {
                redirectAttributes.addFlashAttribute("error", "Tên đăng nhập phải từ 3 ký tự!");
                return "redirect:/register";
            }

            if (password.length() < 6) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu phải từ 6 ký tự!");
                return "redirect:/register";
            }

            // Kiểm tra username đã tồn tại trong hệ thống hay chưa
            if (userService.getByUsername(username).isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Tên đăng nhập đã tồn tại!");
                return "redirect:/register";
            }

            // Tạo user mới từ dữ liệu form
            User newUser = new User();
            newUser.setUsername(username);
            // Mã hóa mật khẩu trước khi lưu vào database (BCrypt)
            newUser.setPassword(passwordEncoder.encode(password));
            newUser.setFullName(fullName);
            newUser.setEmail(email);
            newUser.setPhone(phone);
            // Mặc định user đăng ký từ form là MERCHANT
            newUser.setRole(User.Role.MERCHANT);
            newUser.setStatus(true);
            newUser.setCreatedAt(LocalDateTime.now());

            // Lưu user mới vào database thông qua UserService
            userService.save(newUser);

            redirectAttributes.addFlashAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            return "redirect:/login";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/register";
        }
    }
}