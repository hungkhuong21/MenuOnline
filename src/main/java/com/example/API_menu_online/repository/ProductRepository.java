package com.example.API_menu_online.repository;

import com.example.API_menu_online.entity.Product;
import com.example.API_menu_online.entity.Category;
import com.example.API_menu_online.entity.Restaurant;
import java.util.List;

public interface ProductRepository extends BaseRepository<Product, Long> {
    List<Product> findByCategory(Category category);
    List<Product> findByRestaurant(Restaurant restaurant);
}
