package com.example.API_menu_online.repository;

import com.example.API_menu_online.entity.MenuViewLog;
import com.example.API_menu_online.entity.Restaurant;
import java.util.List;

public interface MenuViewLogRepository extends BaseRepository<MenuViewLog, Long> {
    List<MenuViewLog> findByRestaurant(Restaurant restaurant);
}
