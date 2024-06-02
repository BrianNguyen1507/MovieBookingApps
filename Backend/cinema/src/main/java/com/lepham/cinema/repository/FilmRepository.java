package com.lepham.cinema.repository;

import com.lepham.cinema.entity.FilmEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Date;
import java.util.List;

public interface FilmRepository extends JpaRepository<FilmEntity, Long> {
    @Query(value="SELECT f FROM FilmEntity f WHERE f.releaseDate BETWEEN ?1 AND ?2 ")
    List<FilmEntity> findAllByReleasDate(Date dateStart, Date dateEnd);
}

