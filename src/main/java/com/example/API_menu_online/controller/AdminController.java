package com.example.API_menu_online.controller;

import com.example.API_menu_online.entity.User;
import com.example.API_menu_online.service.UserService;
import com.example.API_menu_online.util.UserContextHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final UserContextHelper userContextHelper;

    @Autowired
    public AdminController(UserService userService, 
                          PasswordEncoder passwordEncoder,
                          UserContextHelper userContextHelper) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.userContextHelper = userContextHelper;
    }

    private User getCurrentUser(HttpSession session) {
        return userContextHelper.getCurrentUser(session);
    }

    @GetMapping("/users")
    public String listUsers(Model model, HttpSession session) {
        User currentUser = getCurrentUser(session);
        List<User> users = userService.getAll();
        
        model.addAttribute("user", currentUser);
        model.addAttribute("users", users);
        model.addAttribute("totalUsers", users.size());
        model.addAttribute("totalAdmins", users.stream().filter(u -> u.getRole() == User.Role.ADMIN).count());
        model.addAttribute("totalMerchants", users.stream().filter(u -> u.getRole() == User.Role.MERCHANT).count());
        model.addAttribute("activeUsers", users.stream().filter(u -> u.getStatus() != null && u.getStatus()).count());
        
        return "admin/users";
    }

    @PostMapping(value = "/users/add", produces = "text/html;charset=UTF-8", consumes = "application/x-www-form-urlencoded;charset=UTF-8")
    public String addUser(@RequestParam("username") String username,
                         @RequestParam("password") String password,
                         @RequestParam("fullName") String fullName,
                         @RequestParam(value = "email", required = false) String email,
                         @RequestParam(value = "phone", required = false) String phone,
                         @RequestParam("role") User.Role role,
                         HttpServletRequest request,
                         RedirectAttributes redirectAttributes) {
        try {
            // Check if username exists
            if (userService.getByUsername(username).isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Username đã tồn tại!");
                return "redirect:/admin/users";
            }

            User user = new User();
            user.setUsername(username);
            user.setPassword(passwordEncoder.encode(password));
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setRole(role);
            user.setStatus(true);

            userService.save(user);
            redirectAttributes.addFlashAttribute("success", "Thêm user thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    @PostMapping(value = "/users/edit/{id}", produces = "text/html;charset=UTF-8", consumes = "application/x-www-form-urlencoded;charset=UTF-8")
    public String editUser(@PathVariable("id") Long id,
                          @RequestParam("fullName") String fullName,
                          @RequestParam(value = "email", required = false) String email,
                          @RequestParam(value = "phone", required = false) String phone,
                          @RequestParam("role") User.Role role,
                          @RequestParam(value = "password", required = false) String password,
                          HttpServletRequest request,
                          RedirectAttributes redirectAttributes) {
        try {
            // Validate input
            if (fullName == null || fullName.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Họ và tên không được để trống!");
                return "redirect:/admin/users";
            }
            
            if (role == null) {
                redirectAttributes.addFlashAttribute("error", "Vai trò không được để trống!");
                return "redirect:/admin/users";
            }
            
            Optional<User> optUser = userService.getById(id);
            if (optUser.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy user với ID: " + id);
                return "redirect:/admin/users";
            }
            
            User user = optUser.get();
            user.setFullName(fullName.trim());
            
            // Handle email - set to null if empty
            if (email != null && !email.trim().isEmpty()) {
                user.setEmail(email.trim());
            } else {
                user.setEmail(null);
            }
            
            // Handle phone - set to null if empty
            if (phone != null && !phone.trim().isEmpty()) {
                user.setPhone(phone.trim());
            } else {
                user.setPhone(null);
            }
            
            user.setRole(role);
            
            // Only update password if provided and not empty
            if (password != null && !password.trim().isEmpty()) {
                if (password.trim().length() < 6) {
                    redirectAttributes.addFlashAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
                    return "redirect:/admin/users";
                }
                user.setPassword(passwordEncoder.encode(password.trim()));
            }
            
            userService.save(user);
            redirectAttributes.addFlashAttribute("success", "Cập nhật người dùng thành công!");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi dữ liệu: " + e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi cập nhật: " + e.getMessage());
            e.printStackTrace(); // Log for debugging
        }
        return "redirect:/admin/users";
    }

    @PostMapping("/users/toggle-status/{id}")
    public String toggleUserStatus(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> optUser = userService.getById(id);
            if (optUser.isPresent()) {
                User user = optUser.get();
                if (user.getStatus() == null) {
                    user.setStatus(true);
                } else {
                    user.setStatus(!user.getStatus());
                }
                userService.save(user);
                redirectAttributes.addFlashAttribute("success", 
                    "Đã đổi trạng thái thành: " + (user.getStatus() ? "Active" : "Inactive"));
            } else {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy user!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    @PostMapping("/users/delete/{id}")
    public String deleteUser(@PathVariable("id") Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            User currentUser = getCurrentUser(session);
            if (currentUser != null && currentUser.getId().equals(id)) {
                redirectAttributes.addFlashAttribute("error", "Không thể xóa chính mình!");
                return "redirect:/admin/users";
            }

            Optional<User> optUser = userService.getById(id);
            if (optUser.isPresent()) {
                userService.delete(id);
                redirectAttributes.addFlashAttribute("success", "Xóa user thành công!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy user!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }
}