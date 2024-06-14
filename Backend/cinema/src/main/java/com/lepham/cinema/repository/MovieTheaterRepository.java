package com.lepham.cinema.repository;

import com.lepham.cinema.entity.MovieTheaterEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MovieTheaterRepository extends JpaRepository<MovieTheaterEntity,Long> {
    List<MovieTheaterEntity> findAllByHide(boolean hide);
}
