package com.example.API_menu_online.repository.impl;

import com.example.API_menu_online.entity.Category;
import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.repository.CategoryRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class CategoryRepositoryImpl extends BaseRepositoryImpl<Category, Long> implements CategoryRepository {

    @Override
    protected Class<Category> getEntityClass() {
        return Category.class;
    }

    @Override
    protected boolean isNew(Category entity) {
        return entity.getId() == null;
    }

    @Override
    public List<Category> findByRestaurant(Restaurant restaurant) {
        jakarta.persistence.TypedQuery<Category> query = entityManager.createQuery(
            "SELECT c FROM Category c WHERE c.restaurant = :restaurant", Category.class);
        query.setParameter("restaurant", restaurant);
        return query.getResultList();
    }
}

