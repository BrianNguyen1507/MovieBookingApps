package com.lepham.cinema.service.imp;

import com.lepham.cinema.constant.ConstantVariable;
import com.lepham.cinema.converter.RatingFeedbackConverter;
import com.lepham.cinema.dto.request.RatingFeedbackRequest;
import com.lepham.cinema.dto.response.RatingFeedbackResponse;
import com.lepham.cinema.entity.AccountEntity;
import com.lepham.cinema.entity.OrderEntity;
import com.lepham.cinema.entity.RatingFeedbackEntity;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.AccountRepository;
import com.lepham.cinema.repository.OrderRepository;
import com.lepham.cinema.repository.RatingFeedBackRepository;
import com.lepham.cinema.service.IRatingFeedbackService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Objects;
@Service
@Slf4j
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class RatingFeedBackService implements IRatingFeedbackService {
    RatingFeedBackRepository ratingFeedBackRepository;
    RatingFeedbackConverter ratingFeedbackConverter;
    AccountRepository accountRepository;
    OrderRepository orderRepository;
    @Override
    @PreAuthorize("hasRole('USER')")
    public RatingFeedbackResponse creatingRatingFeedback(RatingFeedbackRequest request, long orderId) {
        var context = SecurityContextHolder.getContext();
        String email = context.getAuthentication().getName();
        AccountEntity account = accountRepository.findByEmail(email)
                        .orElseThrow(()->new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
        OrderEntity order = orderRepository.findById(orderId)
                .orElseThrow(()->new AppException(ErrorCode.ORDER_NOT_FOUND));
        if(order.getStatus()!= ConstantVariable.ORDER_USED) throw new AppException(ErrorCode.CAN_NOT_RATING);
        if(!Objects.equals(account,order.getAccountVoucher().getAccount()))
            throw new AppException(ErrorCode.ORDER_NOT_BELONG_ACCOUNT);
        RatingFeedbackEntity ratingFeedback = ratingFeedbackConverter.toEntity(request);
        ratingFeedback.setDatetime(LocalDateTime.now());
        ratingFeedback.setOrder(order);
        return ratingFeedbackConverter.toResponse( ratingFeedBackRepository.save(ratingFeedback));
    }
}
