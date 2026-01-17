package com.example.API_menu_online.controller;

import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.entity.User;
import com.example.API_menu_online.service.RestaurantService;
import com.example.API_menu_online.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@CrossOrigin("*")
@RestController
@RequestMapping("/api/restaurants")
public class RestaurantController {

    private final RestaurantService restaurantService;
    private final UserService userService;

    @Autowired
    public RestaurantController(RestaurantService restaurantService, UserService userService) {
        this.restaurantService = restaurantService;
        this.userService = userService;
    }

    // Lấy tất cả nhà hàng
    @GetMapping
    public List<Restaurant> getAllRestaurants() {
        return restaurantService.getAll();
    }

    // Lấy 1 nhà hàng theo ID
    @GetMapping("/{id}")
    public ResponseEntity<Restaurant> getRestaurantById(@PathVariable("id") Long id) {
        return restaurantService.getById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Lấy danh sách quán của 1 user (owner)
    @GetMapping("/owner/{userId}")
    public ResponseEntity<List<Restaurant>> getRestaurantsByOwner(@PathVariable("userId") Long userId) {
        Optional<User> user = userService.getById(userId);
        if (user.isPresent()) {
            return ResponseEntity.ok(restaurantService.getByOwner(user.get()));
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Tạo nhà hàng mới
    @PostMapping
    public ResponseEntity<Restaurant> createRestaurant(@RequestBody Restaurant restaurant) {
        if (restaurant.getOwner() == null) {
            return ResponseEntity.badRequest().body(null);
        }
        Restaurant created = restaurantService.save(restaurant);
        return ResponseEntity.ok(created);
    }

    // Cập nhật thông tin nhà hàng
    @PutMapping("/{id}")
    public ResponseEntity<Restaurant> updateRestaurant(@PathVariable("id") Long id, @RequestBody Restaurant newData) {
        return restaurantService.getById(id)
                .map(existing -> {
                    if (newData.getName() != null) existing.setName(newData.getName());
                    if (newData.getAddress() != null) existing.setAddress(newData.getAddress());
                    if (newData.getDescription() != null) existing.setDescription(newData.getDescription());
                    if (newData.getLogo() != null) existing.setLogo(newData.getLogo());
                    if (newData.getQrToken() != null) existing.setQrToken(newData.getQrToken());
                    if (newData.getIsActive() != null) existing.setIsActive(newData.getIsActive());
                    if (newData.getOwner() != null) existing.setOwner(newData.getOwner());

                    Restaurant updated = restaurantService.save(existing);
                    return ResponseEntity.ok(updated);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    // Xóa nhà hàng
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteRestaurant(@PathVariable("id") Long id) {
        restaurantService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
