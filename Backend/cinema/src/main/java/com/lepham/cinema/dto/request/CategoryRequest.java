package com.lepham.cinema.dto.request;


import com.lepham.cinema.validator.StringConstraint;
import jakarta.validation.constraints.Size;
import lombok.*;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class CategoryRequest {
    long id;


    @StringConstraint(message = "STRING_IS_EMPTY")
    String name;
}
