package com.lepham.cinema.repository;

import com.lepham.cinema.entity.AccountEntity;
import com.lepham.cinema.entity.OrderEntity;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
@Repository
public interface OrderRepository extends JpaRepository<OrderEntity,Long> {
    List<OrderEntity> findByAccountVoucher_AccountAndMovieScheduleNotNull(AccountEntity account, Sort sort);
    List<OrderEntity> findByAccountVoucher_AccountAndMovieScheduleNull(AccountEntity account,Sort sort);
    Optional<OrderEntity> findByOrderCode(String orderCode);

    @Query(value = "SELECT o from OrderEntity o where function('MONTH',o.date)= :month and  function('YEAR',o.date)= :year")
    List<OrderEntity> findByMonthAndYear(int month, int year);

    @Query(value = "select o from OrderEntity o where Date(o.date) < ?1 and o.movieSchedule is null and o.status = ?2")
    List<OrderEntity> MovieScheduleIsNullByDate_Date(LocalDate date,int status);

    @Query(value = "select o from OrderEntity o where Date(o.movieSchedule.timeStart) = ?1 and o.movieSchedule is not null")
    @EntityGraph(attributePaths = {"movieSchedule", "movieSchedule.film"})
    List<OrderEntity> findAllByMovieSchedule_TimeStart_Date(LocalDate date);
    @Query(value = "select sum(o.sumTotal) from OrderEntity o where Date(o.date) = ?1")
    Double sumRevenueTotalByDay(LocalDate date);

    @Query(value = "select o from OrderEntity o where Date(o.date) = ?1")
    List<OrderEntity> findAllOrderByDay(LocalDate date);
}
