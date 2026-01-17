package com.example.API_menu_online.controller;

import com.example.API_menu_online.entity.User;
import com.example.API_menu_online.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@CrossOrigin("*")
@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    // Lấy tất cả người dùng
    @GetMapping
    public List<User> getAllUsers() {
        return userService.getAll();
    }

    // Lấy người dùng theo ID
    @GetMapping("/{id}")
    public Optional<User> getUserById(@PathVariable("id") Long id) {
        return userService.getById(id);
    }

    // Lấy người dùng theo username
    @GetMapping("/username/{username}")
    public Optional<User> getByUsername(@PathVariable("username") String username) {
        return userService.getByUsername(username);
    }

    // Thêm người dùng mới
    @PostMapping
    public User createUser(@RequestBody User user) {
        return userService.save(user);
    }

    // Cập nhật người dùng
    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(@PathVariable("id") Long id, @RequestBody User newData) {
        return userService.getById(id)
                .map(existing -> {
                    // Chỉ cập nhật nếu có dữ liệu mới (không null)
                    if (newData.getUsername() != null) existing.setUsername(newData.getUsername());
                    if (newData.getPassword() != null) existing.setPassword(newData.getPassword());
                    if (newData.getFullName() != null) existing.setFullName(newData.getFullName());
                    if (newData.getEmail() != null) existing.setEmail(newData.getEmail());
                    if (newData.getPhone() != null) existing.setPhone(newData.getPhone());
                    if (newData.getRole() != null) existing.setRole(newData.getRole());
                    if (newData.getStatus() != null) existing.setStatus(newData.getStatus());
                    if (newData.getCreatedAt() != null) existing.setCreatedAt(newData.getCreatedAt());

                    User updated = userService.save(existing);
                    return ResponseEntity.ok(updated);
                })
                .orElse(ResponseEntity.notFound().build());
    }



    // Xóa người dùng
    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable("id") Long id) {
        userService.delete(id);
    }
}
