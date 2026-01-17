package com.example.API_menu_online.repository;

import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.entity.User;
import java.util.List;

public interface RestaurantRepository extends BaseRepository<Restaurant, Long> {
    List<Restaurant> findByOwner(User owner);
}
