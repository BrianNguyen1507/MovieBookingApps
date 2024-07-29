package com.lepham.cinema.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.Map;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
public class RevenueResponse {
    int year;
    String type;
    Map<String,Double> revenue;
}
