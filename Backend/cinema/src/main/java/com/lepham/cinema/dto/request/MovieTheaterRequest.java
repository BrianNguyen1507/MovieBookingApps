package com.lepham.cinema.dto.request;

import com.lepham.cinema.validator.StringConstraint;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@NonNull
public class MovieTheaterRequest {
    @StringConstraint
    String name;
    @StringConstraint
    String address;
}
