package com.lepham.cinema.repository;

import com.lepham.cinema.entity.AccountEntity;
import com.lepham.cinema.entity.MovieScheduleEntity;
import com.lepham.cinema.entity.SeatHeldEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
@Repository
public interface SeatHeldRepository extends JpaRepository<SeatHeldEntity,Long> {
    @Query(value = "SELECT s from SeatHeldEntity s where s.heldDateTime<= ?1 and s.status= ?2")
    List<SeatHeldEntity> findByHeldDateTimeBeforeAndStatus(LocalDateTime dateTime,int status);

    SeatHeldEntity findByScheduleAndSeat(MovieScheduleEntity schedule, String seat);
    Optional<SeatHeldEntity> findByScheduleAndSeatAndAccountAndStatus(MovieScheduleEntity schedule, String seat, AccountEntity account,int status);

}
