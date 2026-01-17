package com.example.API_menu_online.controller;

import com.example.API_menu_online.entity.Category;
import com.example.API_menu_online.service.CategoryService;
import com.example.API_menu_online.service.RestaurantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin("*")
@RestController
@RequestMapping("/api/categories")
public class CategoryController {

    private final CategoryService categoryService;
    private final RestaurantService restaurantService;

    @Autowired
    public CategoryController(CategoryService categoryService, RestaurantService restaurantService) {
        this.categoryService = categoryService;
        this.restaurantService = restaurantService;
    }

    // Lấy tất cả
    @GetMapping
    public List<Category> getAll() {
        return categoryService.getAll();
    }

    // Lấy theo ID
    @GetMapping("/{id}")
    public ResponseEntity<Category> getById(@PathVariable("id") Long id) {
        return categoryService.getById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Lấy tất cả category của 1 nhà hàng
    @GetMapping("/restaurant/{restaurantId}")
    public ResponseEntity<List<Category>> getByRestaurant(@PathVariable("restaurantId") Long restaurantId) {
        return restaurantService.getById(restaurantId)
                .map(restaurant -> ResponseEntity.ok(categoryService.getByRestaurant(restaurant)))
                .orElse(ResponseEntity.notFound().build());
    }

    // Thêm mới
    @PostMapping
    public ResponseEntity<Category> create(@RequestBody Category category) {
        if (category.getRestaurant() == null) {
            return ResponseEntity.badRequest().build();
        }
        Category created = categoryService.save(category);
        return ResponseEntity.ok(created);
    }

    // Cập nhật
    @PutMapping("/{id}")
    public ResponseEntity<Category> update(@PathVariable("id") Long id, @RequestBody Category newData) {
        return categoryService.getById(id)
                .map(existing -> {
                    if (newData.getName() != null) existing.setName(newData.getName());
                    if (newData.getRestaurant() != null) existing.setRestaurant(newData.getRestaurant());
                    return ResponseEntity.ok(categoryService.save(existing));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    // Xóa
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        categoryService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
