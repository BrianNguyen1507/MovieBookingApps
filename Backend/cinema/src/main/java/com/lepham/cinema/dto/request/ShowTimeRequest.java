package com.lepham.cinema.dto.request;

import com.lepham.cinema.validator.IntegerConstraint;
import lombok.*;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ShowTimeRequest {
    long idFilm;
    @IntegerConstraint
    int quantity;
}
