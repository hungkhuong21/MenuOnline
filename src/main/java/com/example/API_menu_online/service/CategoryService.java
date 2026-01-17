package com.example.API_menu_online.service;

import com.example.API_menu_online.entity.Category;
import com.example.API_menu_online.entity.Restaurant;
import java.util.List;
import java.util.Optional;

public interface CategoryService {
    List<Category> getAll();
    Optional<Category> getById(Long id);
    List<Category> getByRestaurant(Restaurant restaurant);
    Category save(Category category);
    void delete(Long id);
}
