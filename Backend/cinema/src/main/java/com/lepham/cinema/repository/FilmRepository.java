package com.lepham.cinema.repository;

import com.lepham.cinema.entity.FilmEntity;
import lombok.Builder;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

public interface FilmRepository extends JpaRepository<FilmEntity, Long> {

    Optional<FilmEntity> findByIdAndHideAndActive(long id,boolean hide , int active);
    Optional<FilmEntity> findByTitle(String title);
    @Query(value = "SELECT f FROM FilmEntity f WHERE f.releaseDate BETWEEN ?1 AND ?2 ")
    List<FilmEntity> findAllByReleasDate(Date dateStart, Date dateEnd);

    @Query(value = "SELECT f FROM FilmEntity f WHERE f.active != 0 order by f.releaseDate asc ")
    List<FilmEntity> findAllByActive();
    @Query(value = "SELECT f FROM FilmEntity f WHERE f.active = 0 and f.hide = false order by f.releaseDate asc ")
    List<FilmEntity> findAllByActiveAndHide();
    List<FilmEntity> findAllByHide(boolean hide);

    @Query(value = "SELECT f FROM FilmEntity f WHERE (f.actor like %?1% or f.country like %?1% or f.director like %?1% or f.title like %?1%) and f.active != 2 and f.hide = false order by f.releaseDate asc ")
    List<FilmEntity> findAllByKeyWord(String keyWord);

    @Query(value = "SELECT f FROM FilmEntity f WHERE f.active = 0 and f.hide = false and f.releaseDate <= NOW()")
    List<FilmEntity> findAllMovieRelease();

    @Query(value = "SELECT f FROM FilmEntity f WHERE f.active = 0 and f.hide = false and f.releaseDate > NOW()")
    List<FilmEntity> findAllMovieFuture ();

    @Query(value = "SELECT f FROM FilmEntity f WHERE YEAR(f.releaseDate) = YEAR(CURRENT_DATE) AND MONTH(f.releaseDate) = :month AND f.active = 0 AND f.hide = false")
    List<FilmEntity>findAllMovieByFutureMonth(@Param("month")int month);

}

