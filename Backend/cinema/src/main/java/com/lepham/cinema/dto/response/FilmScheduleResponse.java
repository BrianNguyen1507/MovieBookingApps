package com.lepham.cinema.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FilmScheduleResponse {
    long id;
    String title;
    LocalDate releaseDate;
    int duration;
}
