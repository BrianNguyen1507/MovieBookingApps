package com.lepham.cinema.dto.request;

import com.lepham.cinema.validator.StringConstraint;
import lombok.*;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDate;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ShowTimesRequest {
    LocalDate dateStart;
    List<ShowTimeRequest> showTimes;
}
