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
    @StringConstraint(message = "STRING_IS_EMPTY")
    String name;
    @StringConstraint(message = "STRING_IS_EMPTY")
    String address;
}
