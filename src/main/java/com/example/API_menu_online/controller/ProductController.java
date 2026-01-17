package com.example.API_menu_online.controller;

import com.example.API_menu_online.entity.Product;
import com.example.API_menu_online.service.CategoryService;
import com.example.API_menu_online.service.ProductService;
import com.example.API_menu_online.service.RestaurantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin("*")
@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ProductService productService;
    private final CategoryService categoryService;
    private final RestaurantService restaurantService;

    @Autowired
    public ProductController(ProductService productService,
                            CategoryService categoryService,
                            RestaurantService restaurantService) {
        this.productService = productService;
        this.categoryService = categoryService;
        this.restaurantService = restaurantService;
    }

    // Lấy toàn bộ sản phẩm
    @GetMapping
    public List<Product> getAllProducts() {
        return productService.getAll();
    }

    // Lấy sản phẩm theo ID
    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable("id") Long id) {
        return productService.getById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Lấy danh sách sản phẩm theo category
    @GetMapping("/category/{categoryId}")
    public ResponseEntity<List<Product>> getProductsByCategory(@PathVariable("categoryId") Long categoryId) {
        return categoryService.getById(categoryId)
                .map(category -> ResponseEntity.ok(productService.getByCategory(category)))
                .orElse(ResponseEntity.notFound().build());
    }

    // Lấy danh sách sản phẩm theo restaurant
    @GetMapping("/restaurant/{restaurantId}")
    public ResponseEntity<List<Product>> getProductsByRestaurant(@PathVariable("restaurantId") Long restaurantId) {
        return restaurantService.getById(restaurantId)
                .map(restaurant -> ResponseEntity.ok(productService.getByRestaurant(restaurant)))
                .orElse(ResponseEntity.notFound().build());
    }

    // Thêm sản phẩm mới
    @PostMapping
    public ResponseEntity<Product> createProduct(@RequestBody Product product) {
        if (product.getCategory() == null || product.getRestaurant() == null) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(productService.save(product));
    }

    // Cập nhật sản phẩm
    @PutMapping("/{id}")
    public ResponseEntity<Product> updateProduct(@PathVariable("id") Long id, @RequestBody Product newData) {
        return productService.getById(id)
                .map(existing -> {
                    if (newData.getName() != null) existing.setName(newData.getName());
                    if (newData.getDescription() != null) existing.setDescription(newData.getDescription());
                    if (newData.getPrice() != null) existing.setPrice(newData.getPrice());
                    if (newData.getImage() != null) existing.setImage(newData.getImage());
                    if (newData.getAvailable() != null) existing.setAvailable(newData.getAvailable());
                    if (newData.getCategory() != null) existing.setCategory(newData.getCategory());
                    if (newData.getRestaurant() != null) existing.setRestaurant(newData.getRestaurant());
                    return ResponseEntity.ok(productService.save(existing));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    // Xóa sản phẩm
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable("id") Long id) {
        productService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
