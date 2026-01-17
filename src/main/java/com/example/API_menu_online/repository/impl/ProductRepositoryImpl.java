package com.example.API_menu_online.repository.impl;

import com.example.API_menu_online.entity.Category;
import com.example.API_menu_online.entity.Product;
import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.repository.ProductRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ProductRepositoryImpl extends BaseRepositoryImpl<Product, Long> implements ProductRepository {

    @Override
    protected Class<Product> getEntityClass() {
        return Product.class;
    }

    @Override
    protected boolean isNew(Product entity) {
        return entity.getId() == null;
    }

    @Override
    public List<Product> findByCategory(Category category) {
        jakarta.persistence.TypedQuery<Product> query = entityManager.createQuery(
            "SELECT p FROM Product p WHERE p.category = :category", Product.class);
        query.setParameter("category", category);
        return query.getResultList();
    }

    @Override
    public List<Product> findByRestaurant(Restaurant restaurant) {
        jakarta.persistence.TypedQuery<Product> query = entityManager.createQuery(
            "SELECT p FROM Product p WHERE p.restaurant = :restaurant", Product.class);
        query.setParameter("restaurant", restaurant);
        return query.getResultList();
    }
}

