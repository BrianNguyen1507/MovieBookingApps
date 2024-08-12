package com.lepham.cinema.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class RoomResponse {
    long id;
    int number;
    int row;
    int column;
    MovieTheaterResponse movieTheater;
}
