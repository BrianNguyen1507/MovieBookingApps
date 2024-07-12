package com.lepham.cinema.repository;

import com.lepham.cinema.entity.FilmEntity;
import com.lepham.cinema.entity.MovieScheduleEntity;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

public interface MovieScheduleRepository extends JpaRepository<MovieScheduleEntity,Long> {

    @Query(value = "select s from MovieScheduleEntity s " +
            "where s.timeStart=(SELECT MAX(s.timeStart) from MovieScheduleEntity s)")
    MovieScheduleEntity getLatestDate();

    @Query(value = "select ms from MovieScheduleEntity ms " +
            "where ms.timeStart >= ?1 and date (ms.timeStart) =  date(?1)")
    List<MovieScheduleEntity> getAllByTimeStartAfter(LocalDateTime date);

    @Query(value = "select ms from MovieScheduleEntity ms " +
            "inner join FilmEntity f on f.id = ms.film.id " +
            "inner join RoomEntity r on r.id = ms.room.id " +
            "inner join MovieTheaterEntity mt on mt.id = r.movieTheater.id " +
            "where f.id=?1 and mt.id = ?2 and r.hide=false and Date(ms.timeStart) = ?3 and ms.timeStart > Now()")
    List<MovieScheduleEntity> findAllByFilmAndMovieTheater(long filmId, long theaterId, LocalDate date);

    @Query(value = "SELECT ms from MovieScheduleEntity ms inner join RoomEntity r on r.id = ms.room.id where Date( ms.timeStart) = ?2 and ms.room.id=?1")
    List<MovieScheduleEntity> findAllByRoomIdAndDateStart(long roomId, LocalDate date, Sort sort);



}
