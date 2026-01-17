package com.example.API_menu_online.controller;

import com.example.API_menu_online.entity.MenuViewLog;
import com.example.API_menu_online.service.MenuViewLogService;
import com.example.API_menu_online.service.RestaurantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin("*")
@RestController
@RequestMapping("/api/menu-view-logs")
public class MenuViewLogController {

    private final MenuViewLogService menuViewLogService;
    private final RestaurantService restaurantService;

    @Autowired
    public MenuViewLogController(MenuViewLogService menuViewLogService, RestaurantService restaurantService) {
        this.menuViewLogService = menuViewLogService;
        this.restaurantService = restaurantService;
    }

    // Lấy toàn bộ log
    @GetMapping
    public List<MenuViewLog> getAllLogs() {
        return menuViewLogService.getAll();
    }

    // Lấy log theo restaurant
    @GetMapping("/restaurant/{restaurantId}")
    public ResponseEntity<List<MenuViewLog>> getLogsByRestaurant(@PathVariable("restaurantId") Long restaurantId) {
        return restaurantService.getById(restaurantId)
                .map(r -> ResponseEntity.ok(menuViewLogService.getByRestaurant(r)))
                .orElse(ResponseEntity.notFound().build());
    }

    // Thêm log mới
    @PostMapping
    public ResponseEntity<MenuViewLog> createLog(@RequestBody MenuViewLog log) {
        if (log.getRestaurant() == null) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(menuViewLogService.save(log));
    }

    // Xóa log
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteLog(@PathVariable("id") Long id) {
        menuViewLogService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
