package com.lepham.cinema.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE)
public class MovieScheduleResponse {
    long id;
    String date;
    String time;
    FilmScheduleResponse film;
}
