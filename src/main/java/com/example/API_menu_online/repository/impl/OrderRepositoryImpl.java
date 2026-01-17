package com.example.API_menu_online.repository.impl;

import com.example.API_menu_online.entity.Order;
import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.repository.OrderRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public class OrderRepositoryImpl extends BaseRepositoryImpl<Order, Long> implements OrderRepository {

    @Override
    protected Class<Order> getEntityClass() {
        return Order.class;
    }

    @Override
    protected boolean isNew(Order entity) {
        return entity.getId() == null;
    }

    @Override
    public List<Order> findAll() {
        jakarta.persistence.TypedQuery<Order> query = entityManager.createQuery(
            "SELECT DISTINCT o FROM Order o LEFT JOIN FETCH o.items i LEFT JOIN FETCH i.product", Order.class);
        return query.getResultList();
    }

    @Override
    public Optional<Order> findById(Long id) {
        jakarta.persistence.TypedQuery<Order> query = entityManager.createQuery(
            "SELECT DISTINCT o FROM Order o LEFT JOIN FETCH o.items i LEFT JOIN FETCH i.product WHERE o.id = :id", Order.class);
        query.setParameter("id", id);
        try {
            return Optional.of(query.getSingleResult());
        } catch (jakarta.persistence.NoResultException e) {
            return Optional.empty();
        }
    }

    @Override
    public List<Order> findByRestaurantOrderByCreatedAtDesc(Restaurant restaurant) {
        jakarta.persistence.TypedQuery<Order> query = entityManager.createQuery(
            "SELECT DISTINCT o FROM Order o LEFT JOIN FETCH o.items i LEFT JOIN FETCH i.product WHERE o.restaurant = :restaurant ORDER BY o.createdAt DESC", Order.class);
        query.setParameter("restaurant", restaurant);
        return query.getResultList();
    }

    @Override
    public List<Order> findByRestaurant(Restaurant restaurant) {
        jakarta.persistence.TypedQuery<Order> query = entityManager.createQuery(
            "SELECT DISTINCT o FROM Order o LEFT JOIN FETCH o.items i LEFT JOIN FETCH i.product WHERE o.restaurant = :restaurant", Order.class);
        query.setParameter("restaurant", restaurant);
        return query.getResultList();
    }

    @Override
    public List<Order> findByRestaurantAndStatus(Restaurant restaurant, Order.OrderStatus status) {
        jakarta.persistence.TypedQuery<Order> query = entityManager.createQuery(
            "SELECT DISTINCT o FROM Order o LEFT JOIN FETCH o.items i LEFT JOIN FETCH i.product WHERE o.restaurant = :restaurant AND o.status = :status ORDER BY o.createdAt DESC", Order.class);
        query.setParameter("restaurant", restaurant);
        query.setParameter("status", status);
        return query.getResultList();
    }

    @Override
    public Optional<Order> findByOrderCode(String orderCode) {
        jakarta.persistence.TypedQuery<Order> query = entityManager.createQuery(
            "SELECT DISTINCT o FROM Order o LEFT JOIN FETCH o.items i LEFT JOIN FETCH i.product WHERE o.orderCode = :orderCode", Order.class);
        query.setParameter("orderCode", orderCode);
        try {
            return Optional.of(query.getSingleResult());
        } catch (jakarta.persistence.NoResultException e) {
            return Optional.empty();
        }
    }

    @Override
    public List<Order> findByRestaurantAndCreatedAtBetween(Restaurant restaurant, LocalDateTime start, LocalDateTime end) {
        jakarta.persistence.TypedQuery<Order> query = entityManager.createQuery(
            "SELECT DISTINCT o FROM Order o LEFT JOIN FETCH o.items i LEFT JOIN FETCH i.product WHERE o.restaurant = :restaurant AND o.createdAt BETWEEN :start AND :end", Order.class);
        query.setParameter("restaurant", restaurant);
        query.setParameter("start", start);
        query.setParameter("end", end);
        return query.getResultList();
    }
}

