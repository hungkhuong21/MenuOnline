package com.example.API_menu_online.service;

import com.example.API_menu_online.entity.Category;
import com.example.API_menu_online.entity.Product;
import com.example.API_menu_online.entity.Restaurant;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

public interface ProductService {
    List<Product> getAll();
    Optional<Product> getById(Long id);
    List<Product> getByCategory(Category category);
    List<Product> getByRestaurant(Restaurant restaurant);
    Product save(Product product);
    Product saveWithImage(Product product, MultipartFile imageFile) throws IOException;
    void delete(Long id);
}
