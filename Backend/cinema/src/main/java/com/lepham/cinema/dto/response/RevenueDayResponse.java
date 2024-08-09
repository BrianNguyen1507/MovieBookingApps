package com.lepham.cinema.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
public class RevenueDayResponse {
    List<Integer> day;
    List<Double> total;
    List<Double> food;
    List<Double> film;
}
