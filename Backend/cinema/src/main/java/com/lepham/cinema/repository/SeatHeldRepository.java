package com.lepham.cinema.repository;

import com.lepham.cinema.entity.MovieScheduleEntity;
import com.lepham.cinema.entity.SeatHeldEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDateTime;
import java.util.List;

public interface SeatHeldRepository extends JpaRepository<SeatHeldEntity,Long> {
    @Query(value = "SELECT s from SeatHeldEntity s where s.heldDateTime<= ?1 and s.status= ?2")
    List<SeatHeldEntity> findByHeldDateTimeBeforeAndStatus(LocalDateTime dateTime,int status);

    SeatHeldEntity findByScheduleAndSeat(MovieScheduleEntity schedule, String seat);
}
