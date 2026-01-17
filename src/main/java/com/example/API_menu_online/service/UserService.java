package com.example.API_menu_online.service;

import com.example.API_menu_online.entity.User;
import java.util.List;
import java.util.Optional;

public interface UserService {
    List<User> getAll();
    Optional<User> getById(Long id);
    Optional<User> getByUsername(String username);
    User save(User user);
    void delete(Long id);
    Optional<User> authenticate(String username, String password);
    boolean isUsernameExists(String username);
    boolean isEmailExists(String email);
}
