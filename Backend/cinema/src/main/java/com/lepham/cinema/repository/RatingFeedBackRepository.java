package com.lepham.cinema.repository;

import com.lepham.cinema.entity.AccountEntity;
import com.lepham.cinema.entity.OrderEntity;
import com.lepham.cinema.entity.RatingFeedbackEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public interface RatingFeedBackRepository extends JpaRepository<RatingFeedbackEntity,Long> {
    RatingFeedbackEntity findByOrder(OrderEntity order);
    List<RatingFeedbackEntity> findAllByOrder_MovieSchedule_Film_Id(long id);
    int countAllByOrder_AccountVoucher_Account(AccountEntity account);
    boolean existsByOrder(OrderEntity order);
}
