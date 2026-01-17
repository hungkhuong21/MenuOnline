package com.example.API_menu_online.repository;

import java.util.List;
import java.util.Optional;

public interface BaseRepository<T, ID> {
    List<T> findAll();
    Optional<T> findById(ID id);
    <S extends T> S save(S entity);
    <S extends T> List<S> saveAll(Iterable<S> entities);
    void deleteById(ID id);
    void delete(T entity);
    void deleteAll();
    void deleteAll(Iterable<? extends T> entities);
    long count();
    boolean existsById(ID id);
}

