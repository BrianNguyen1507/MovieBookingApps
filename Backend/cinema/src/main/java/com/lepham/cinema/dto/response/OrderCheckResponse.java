package com.lepham.cinema.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class OrderCheckResponse {
    long id;
    String seat;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    LocalDateTime date;
    double sumTotal;
    boolean allowUse;
    MovieScheduleResponse movieSchedule;
    String theaterName;
    String address;
    int roomNumber;
    List<FoodResponse> foods;
}
