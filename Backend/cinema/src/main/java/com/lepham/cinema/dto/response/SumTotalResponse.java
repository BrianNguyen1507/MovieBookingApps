package com.lepham.cinema.dto.response;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.lepham.cinema.validator.CustomDoubleSerializer;
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
