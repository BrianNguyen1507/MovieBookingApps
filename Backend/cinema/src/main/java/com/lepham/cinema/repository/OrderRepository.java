package com.lepham.cinema.repository;

import com.lepham.cinema.entity.AccountEntity;
import com.lepham.cinema.entity.OrderEntity;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface OrderRepository extends JpaRepository<OrderEntity,Long> {
    List<OrderEntity> findByAccountVoucher_AccountAndMovieScheduleNotNull(AccountEntity account, Sort sort);
    List<OrderEntity> findByAccountVoucher_AccountAndMovieScheduleNull(AccountEntity account,Sort sort);
    Optional<OrderEntity> findByOrderCode(String orderCode);

    @Query(value = "SELECT o from OrderEntity o where function('MONTH',o.date)= :month and  function('YEAR',o.date)= :year")
    List<OrderEntity> findByMonthAndYear(int month, int year);

    @Query(value = "select sum(o.sumTotal) from OrderEntity o where YEAR(o.date)=?1 and o.paymentMethod=?2")
    Optional<Double> sumAllByDateAndPaymentMethod(int year,String paymentMethod);

    @Query(value = "select o.paymentMethod from OrderEntity o group by o.paymentMethod")
    List<String> getALLPaymentMethod();
}
