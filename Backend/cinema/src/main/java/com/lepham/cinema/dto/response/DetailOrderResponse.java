package com.lepham.cinema.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.lepham.cinema.validator.CustomDoubleSerializer;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class DetailOrderResponse {
    long id;
    String seat;
    double sumTotal;
    @JsonFormat(pattern = "yyyy-MM-dd hh:mm:ss")
    LocalDateTime date;
    String paymentMethod;
    String paymentCode;
    boolean allowedComment;
    String status;
    VoucherResponse voucher;
    List<FoodResponse> food;
    String theaterName;
    FilmResponse film;
    int roomNumber;
    @JsonFormat(pattern = "yyyy-MM-dd hh:mm:ss")
    LocalDateTime movieTimeStart;
    @JsonFormat(pattern = "yyyy-MM-dd hh:mm:ss")
    LocalDateTime movieTimeEnd;
    String orderCode;
}
