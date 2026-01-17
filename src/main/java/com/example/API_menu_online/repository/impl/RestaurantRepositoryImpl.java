package com.example.API_menu_online.repository.impl;

import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.entity.User;
import com.example.API_menu_online.repository.RestaurantRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class RestaurantRepositoryImpl extends BaseRepositoryImpl<Restaurant, Long> implements RestaurantRepository {

    @Override
    protected Class<Restaurant> getEntityClass() {
        return Restaurant.class;
    }

    @Override
    protected boolean isNew(Restaurant entity) {
        return entity.getId() == null;
    }

    @Override
    public List<Restaurant> findByOwner(User owner) {
        jakarta.persistence.TypedQuery<Restaurant> query = entityManager.createQuery(
            "SELECT r FROM Restaurant r WHERE r.owner = :owner", Restaurant.class);
        query.setParameter("owner", owner);
        return query.getResultList();
    }
}

