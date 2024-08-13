package com.lepham.cinema.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class MovieScheduleResponse {
    long id;
    String date;
    String timeStart;
    String timeEnd;
    FilmScheduleResponse film;
}
