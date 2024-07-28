package com.lepham.cinema.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class OrderCheckResponse {
    long id;
    String seat;
    @JsonFormat(pattern = "yyyy-MM-dd hh:mm:ss")
    LocalDateTime date;
    boolean allowUse;
    MovieScheduleResponse movieSchedule;
}
