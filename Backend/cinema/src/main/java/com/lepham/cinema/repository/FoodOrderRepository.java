package com.lepham.cinema.repository;

import com.lepham.cinema.entity.FoodOrderEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FoodOrderRepository extends JpaRepository<FoodOrderEntity,Long> {
}
