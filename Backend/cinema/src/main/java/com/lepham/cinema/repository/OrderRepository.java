package com.lepham.cinema.repository;

import com.lepham.cinema.entity.AccountEntity;
import com.lepham.cinema.entity.OrderEntity;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface OrderRepository extends JpaRepository<OrderEntity,Long> {
    List<OrderEntity> findByAccountVoucher_AccountAndMovieScheduleNotNull(AccountEntity account, Sort sort);
    List<OrderEntity> findByAccountVoucher_AccountAndMovieScheduleNull(AccountEntity account,Sort sort);
}
