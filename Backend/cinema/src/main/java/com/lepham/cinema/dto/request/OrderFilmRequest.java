package com.lepham.cinema.dto.request;

import com.lepham.cinema.dto.response.AccountResponse;
import com.lepham.cinema.dto.response.MovieScheduleResponse;
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
    double sumTotal;
    List<FoodOrderRequest> food;

}
