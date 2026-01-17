package com.example.API_menu_online.service.impl;

import com.example.API_menu_online.entity.MenuViewLog;
import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.repository.MenuViewLogRepository;
import com.example.API_menu_online.service.MenuViewLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MenuViewLogServiceImpl implements MenuViewLogService {

    private final MenuViewLogRepository menuViewLogRepository;

    @Autowired
    public MenuViewLogServiceImpl(MenuViewLogRepository menuViewLogRepository) {
        this.menuViewLogRepository = menuViewLogRepository;
    }

    @Override
    public List<MenuViewLog> getAll() {
        return menuViewLogRepository.findAll();
    }

    @Override
    public List<MenuViewLog> getByRestaurant(Restaurant restaurant) {
        return menuViewLogRepository.findByRestaurant(restaurant);
    }

    @Override
    public MenuViewLog save(MenuViewLog log) {
        return menuViewLogRepository.save(log);
    }

    @Override
    public void delete(Long id) {
        menuViewLogRepository.deleteById(id);
    }
}

