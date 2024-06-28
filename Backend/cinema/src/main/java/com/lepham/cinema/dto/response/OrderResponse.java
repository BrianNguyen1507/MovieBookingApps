package com.lepham.cinema.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class OrderResponse {
    long id;
    LocalDate date;
    String paymentMethod;
    int quantityTicket;
    List<String> seat;
    double sumTotal;
    AccountResponse accountResponse;
    MovieScheduleResponse movieScheduleResponse;
    FoodResponse foodResponse;
}
