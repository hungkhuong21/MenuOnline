package com.example.API_menu_online.service.impl;

import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.entity.User;
import com.example.API_menu_online.repository.RestaurantRepository;
import com.example.API_menu_online.service.RestaurantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class RestaurantServiceImpl implements RestaurantService {

    private final RestaurantRepository restaurantRepository;

    @Autowired
    public RestaurantServiceImpl(RestaurantRepository restaurantRepository) {
        this.restaurantRepository = restaurantRepository;
    }

    @Override
    public List<Restaurant> getAll() {
        return restaurantRepository.findAll();
    }

    @Override
    public Optional<Restaurant> getById(Long id) {
        return restaurantRepository.findById(id);
    }

    @Override
    public List<Restaurant> getByOwner(User owner) {
        return restaurantRepository.findByOwner(owner);
    }

    @Override
    public Restaurant save(Restaurant restaurant) {
        return restaurantRepository.save(restaurant);
    }

    @Override
    public void delete(Long id) {
        restaurantRepository.deleteById(id);
    }
}

