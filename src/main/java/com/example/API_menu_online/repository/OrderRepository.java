package com.example.API_menu_online.repository;

import com.example.API_menu_online.entity.Order;
import com.example.API_menu_online.entity.Restaurant;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface OrderRepository extends BaseRepository<Order, Long> {
    List<Order> findByRestaurantOrderByCreatedAtDesc(Restaurant restaurant);
    List<Order> findByRestaurant(Restaurant restaurant);
    List<Order> findByRestaurantAndStatus(Restaurant restaurant, Order.OrderStatus status);
    Optional<Order> findByOrderCode(String orderCode);
    List<Order> findByRestaurantAndCreatedAtBetween(Restaurant restaurant, LocalDateTime start, LocalDateTime end);
}

