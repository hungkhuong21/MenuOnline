package com.example.API_menu_online.repository.impl;

import com.example.API_menu_online.repository.BaseRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

public abstract class BaseRepositoryImpl<T, ID> implements BaseRepository<T, ID> {

    @PersistenceContext
    protected EntityManager entityManager;

    protected abstract Class<T> getEntityClass();

    @Override
    @Transactional(readOnly = true)
    public List<T> findAll() {
        TypedQuery<T> query = entityManager.createQuery(
            "SELECT e FROM " + getEntityClass().getSimpleName() + " e", getEntityClass());
        return query.getResultList();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<T> findById(ID id) {
        T entity = entityManager.find(getEntityClass(), id);
        return Optional.ofNullable(entity);
    }

    @Override
    @Transactional
    public <S extends T> S save(S entity) {
        if (isNew(entity)) {
            entityManager.persist(entity);
            return entity;
        } else {
            return entityManager.merge(entity);
        }
    }

    @Override
    @Transactional
    public <S extends T> List<S> saveAll(Iterable<S> entities) {
        List<S> result = new java.util.ArrayList<>();
        for (S entity : entities) {
            result.add(save(entity));
        }
        return result;
    }

    @Override
    @Transactional
    public void deleteById(ID id) {
        T entity = entityManager.find(getEntityClass(), id);
        if (entity != null) {
            entityManager.remove(entity);
        }
    }

    @Override
    @Transactional
    public void delete(T entity) {
        entityManager.remove(entityManager.contains(entity) ? entity : entityManager.merge(entity));
    }

    @Override
    @Transactional
    public void deleteAll() {
        entityManager.createQuery("DELETE FROM " + getEntityClass().getSimpleName()).executeUpdate();
    }

    @Override
    @Transactional
    public void deleteAll(Iterable<? extends T> entities) {
        for (T entity : entities) {
            delete(entity);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public long count() {
        TypedQuery<Long> query = entityManager.createQuery(
            "SELECT COUNT(e) FROM " + getEntityClass().getSimpleName() + " e", Long.class);
        return query.getSingleResult();
    }

    @Override
    @Transactional(readOnly = true)
    public boolean existsById(ID id) {
        return findById(id).isPresent();
    }

    protected abstract boolean isNew(T entity);
}

