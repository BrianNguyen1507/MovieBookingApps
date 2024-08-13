package com.lepham.cinema.repository;

import com.lepham.cinema.entity.FoodEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository
public interface FoodRepository  extends JpaRepository<FoodEntity, Long> {
    List<FoodEntity> findAllByHide(boolean hide);
    Optional<FoodEntity> findByIdAndHide(long id, boolean hide);
}
