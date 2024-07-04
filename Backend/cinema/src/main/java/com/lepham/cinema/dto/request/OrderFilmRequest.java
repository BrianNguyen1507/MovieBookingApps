package com.lepham.cinema.dto.request;

import com.lepham.cinema.constant.ConstantVariable;
import com.lepham.cinema.dto.response.AccountResponse;
import com.lepham.cinema.dto.response.MovieScheduleResponse;
import com.lepham.cinema.validator.PriceConstraint;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class OrderFilmRequest {
    long movieScheduleId;
    long voucherId;
    String paymentMethod;
    String paymentCode;
    String seat;
    @PriceConstraint()
    double sumTotal;
    @Builder.Default
    int isUsed = ConstantVariable.ORDER_UNUSED;
    List<FoodOrderRequest> food;
}
