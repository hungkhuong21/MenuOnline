package com.example.API_menu_online.service;

import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.entity.User;
import java.util.List;
import java.util.Optional;

public interface RestaurantService {
    List<Restaurant> getAll();
    Optional<Restaurant> getById(Long id);
    List<Restaurant> getByOwner(User owner);
    Restaurant save(Restaurant restaurant);
    void delete(Long id);
}
