package com.example.API_menu_online.service;

import com.example.API_menu_online.entity.MenuViewLog;
import com.example.API_menu_online.entity.Restaurant;
import java.util.List;

public interface MenuViewLogService {
    List<MenuViewLog> getAll();
    List<MenuViewLog> getByRestaurant(Restaurant restaurant);
    MenuViewLog save(MenuViewLog log);
    void delete(Long id);
}
