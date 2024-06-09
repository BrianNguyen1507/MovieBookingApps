package com.lepham.cinema.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@NonNull
public class RoomRequest {
    int number;
    int row;
    int column;
    long theaterId;
}
