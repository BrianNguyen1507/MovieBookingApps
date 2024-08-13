package com.lepham.cinema.repository;

import com.lepham.cinema.entity.MovieTheaterEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository
public interface MovieTheaterRepository extends JpaRepository<MovieTheaterEntity,Long> {
    List<MovieTheaterEntity> findAllByHide(boolean hide);

    Optional<MovieTheaterEntity> findByName(String name);
    Optional<MovieTheaterEntity> findByNameAndIdNot(String name,long id);
}
