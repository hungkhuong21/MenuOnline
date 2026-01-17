package com.example.API_menu_online.service.impl;

import com.example.API_menu_online.entity.Category;
import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.repository.CategoryRepository;
import com.example.API_menu_online.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepository categoryRepository;

    @Autowired
    public CategoryServiceImpl(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    @Override
    public List<Category> getAll() {
        return categoryRepository.findAll();
    }

    @Override
    public Optional<Category> getById(Long id) {
        return categoryRepository.findById(id);
    }

    @Override
    public List<Category> getByRestaurant(Restaurant restaurant) {
        return categoryRepository.findByRestaurant(restaurant);
    }

    @Override
    public Category save(Category category) {
        return categoryRepository.save(category);
    }

    @Override
    public void delete(Long id) {
        categoryRepository.deleteById(id);
    }
}

