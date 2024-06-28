package com.lepham.cinema.dto.request;

import com.lepham.cinema.dto.response.AccountResponse;
import com.lepham.cinema.dto.response.MovieScheduleResponse;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class OrderFilmRequest {

    long id;
    LocalDate date;
    String paymentMethod;
    int quantityTicket;
    int[] seat;
    double sumTotal;
    AccountResponse accountResponse;
    MovieScheduleResponse movieScheduleResponse;
}
