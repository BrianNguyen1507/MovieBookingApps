package com.lepham.cinema.repository;

import com.lepham.cinema.entity.MovieScheduleEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

public interface MovieScheduleRepository extends JpaRepository<MovieScheduleEntity,Long> {

    @Query(value = "select s from MovieScheduleEntity s " +
            "where s.timeStart=(SELECT MAX(s.timeStart) from MovieScheduleEntity s)")
    MovieScheduleEntity getLatestDate();

    @Query(value = "select ms from MovieScheduleEntity ms " +
            "where ms.timeStart >= ?1 and date (ms.timeStart) =  date(?1)")
    List<MovieScheduleEntity> getAllByTimeStartAfter(Date date);

}
