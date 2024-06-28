package com.lepham.cinema.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
public class ScheduleMobileResponse {
    LocalDate date;
    List<ScheduleHourResponse> scheduleByHour;
    FilmScheduleResponse film;
}
