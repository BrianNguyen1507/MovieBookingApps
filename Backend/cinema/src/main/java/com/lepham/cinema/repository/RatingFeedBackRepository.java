package com.lepham.cinema.repository;

import com.lepham.cinema.entity.OrderEntity;
import com.lepham.cinema.entity.RatingFeedbackEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RatingFeedBackRepository extends JpaRepository<RatingFeedbackEntity,Long> {
    RatingFeedbackEntity findByOrder(OrderEntity order);
}
