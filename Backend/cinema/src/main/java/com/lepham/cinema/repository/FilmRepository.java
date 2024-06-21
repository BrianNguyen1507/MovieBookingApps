package com.lepham.cinema.repository;

import com.lepham.cinema.entity.FilmEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Date;
import java.util.List;

public interface FilmRepository extends JpaRepository<FilmEntity, Long> {
    @Query(value = "SELECT f FROM FilmEntity f WHERE f.releaseDate BETWEEN ?1 AND ?2 ")
    List<FilmEntity> findAllByReleasDate(Date dateStart, Date dateEnd);

    @Query(value = "SELECT f FROM FilmEntity f WHERE f.active != 0 order by f.releaseDate asc ")
    List<FilmEntity> findAllByActive();

    List<FilmEntity> findAllByHide(boolean hide);

    @Query(value = "SELECT f FROM FilmEntity f WHERE (f.actor like %?1% or f.country like %?1% or f.director like %?1% or f.title like %?1%) and f.active != 0 and f.hide = false order by f.releaseDate asc ")
    List<FilmEntity> findAllByKeyWord(String keyWord);
  
    List<FilmEntity> findAllByActiveAndHide(int active, boolean hide);
}

