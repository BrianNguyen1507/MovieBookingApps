package com.lepham.cinema.repository;

import com.lepham.cinema.entity.OrderEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface OrderRepository extends JpaRepository<OrderEntity,Long> {
    Optional<OrderEntity> findByIdAndPending(long id, boolean pending);
}
