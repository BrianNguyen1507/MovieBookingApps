package com.lepham.cinema.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.lepham.cinema.validator.CustomDoubleSerializer;
import jakarta.persistence.Column;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class OrderResponse {
    long id;
    String orderCode;
    String seat;

    double sumTotal;
    @JsonFormat(pattern = "yyyy-MM-dd hh:mm:ss")
    LocalDateTime date;
    String paymentMethod;
    String paymentCode;

    FilmResponse film;
}
