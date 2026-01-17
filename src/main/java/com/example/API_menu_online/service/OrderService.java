package com.example.API_menu_online.service;

import com.example.API_menu_online.dto.CartItemDTO;
import com.example.API_menu_online.entity.Order;
import com.example.API_menu_online.entity.Restaurant;
import java.util.List;
import java.util.Optional;

public interface OrderService {
    List<Order> getAll();
    Optional<Order> getById(Long id);
    Optional<Order> getByOrderCode(String orderCode);
    List<Order> getByRestaurant(Restaurant restaurant);
    List<Order> getByRestaurantAndStatus(Restaurant restaurant, Order.OrderStatus status);
    Order save(Order order);
    Order createOrder(Order order, List<CartItemDTO> cartItems);
    void delete(Long id);
}
