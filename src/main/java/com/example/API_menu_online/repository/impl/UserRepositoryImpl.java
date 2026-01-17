package com.example.API_menu_online.repository.impl;

import com.example.API_menu_online.entity.User;
import com.example.API_menu_online.repository.UserRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public class UserRepositoryImpl extends BaseRepositoryImpl<User, Long> implements UserRepository {

    @Override
    protected Class<User> getEntityClass() {
        return User.class;
    }

    @Override
    protected boolean isNew(User entity) {
        return entity.getId() == null;
    }

    @Override
    public Optional<User> findByUsername(String username) {
        jakarta.persistence.TypedQuery<User> query = entityManager.createQuery(
            "SELECT u FROM User u WHERE u.username = :username", User.class);
        query.setParameter("username", username);
        try {
            return Optional.of(query.getSingleResult());
        } catch (jakarta.persistence.NoResultException e) {
            return Optional.empty();
        }
    }

    @Override
    public Optional<User> findByEmail(String email) {
        jakarta.persistence.TypedQuery<User> query = entityManager.createQuery(
            "SELECT u FROM User u WHERE u.email = :email", User.class);
        query.setParameter("email", email);
        try {
            return Optional.of(query.getSingleResult());
        } catch (jakarta.persistence.NoResultException e) {
            return Optional.empty();
        }
    }
}

