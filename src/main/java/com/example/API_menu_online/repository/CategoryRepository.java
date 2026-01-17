package com.example.API_menu_online.repository;

import com.example.API_menu_online.entity.Category;
import com.example.API_menu_online.entity.Restaurant;
import java.util.List;

public interface CategoryRepository extends BaseRepository<Category, Long> {
    List<Category> findByRestaurant(Restaurant restaurant);
}
