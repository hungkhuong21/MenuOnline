package com.example.API_menu_online.repository;

import com.example.API_menu_online.entity.User;
import java.util.Optional;

public interface UserRepository extends BaseRepository<User, Long> {
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
}
