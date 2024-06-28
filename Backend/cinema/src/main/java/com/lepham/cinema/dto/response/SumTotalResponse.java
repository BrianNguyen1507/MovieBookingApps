package com.lepham.cinema.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;


@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
public class SumTotalResponse {
    double priceTicket;
    double priceFood;
    double total;
}
