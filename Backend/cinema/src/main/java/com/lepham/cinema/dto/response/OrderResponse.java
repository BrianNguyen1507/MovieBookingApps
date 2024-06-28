package com.lepham.cinema.dto.response;

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
    LocalDateTime date;
    String paymentMethod;
    String paymentCode;
    boolean pending;
}