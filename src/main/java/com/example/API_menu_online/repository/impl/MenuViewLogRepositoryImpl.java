package com.example.API_menu_online.repository.impl;

import com.example.API_menu_online.entity.MenuViewLog;
import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.repository.MenuViewLogRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class MenuViewLogRepositoryImpl extends BaseRepositoryImpl<MenuViewLog, Long> implements MenuViewLogRepository {

    @Override
    protected Class<MenuViewLog> getEntityClass() {
        return MenuViewLog.class;
    }

    @Override
    protected boolean isNew(MenuViewLog entity) {
        return entity.getId() == null;
    }

    @Override
    public List<MenuViewLog> findByRestaurant(Restaurant restaurant) {
        jakarta.persistence.TypedQuery<MenuViewLog> query = entityManager.createQuery(
            "SELECT m FROM MenuViewLog m WHERE m.restaurant = :restaurant", MenuViewLog.class);
        query.setParameter("restaurant", restaurant);
        return query.getResultList();
    }
}

