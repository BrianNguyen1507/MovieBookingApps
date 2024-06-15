package com.lepham.cinema.dto.request;

import com.lepham.cinema.validator.DurationConstraint;
import com.lepham.cinema.validator.StringConstraint;
import jakarta.validation.constraints.Size;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.springframework.format.annotation.NumberFormat;

import java.time.LocalDate;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@NonNull
public class FilmRequest {
    @StringConstraint(message = "STRING_IS_EMPTY")
    String title;
    @DurationConstraint(message = "DURATION_INVALID")
    int duration;
    byte [] description;
    LocalDate releaseDate;
    @StringConstraint(message = "STRING_IS_EMPTY")
    String director;
    @StringConstraint(message = "STRING_IS_EMPTY")
    String actor;
    byte[] poster;
    String trailer;
    @StringConstraint(message = "STRING_IS_EMPTY")
        String country;
    @StringConstraint(message = "STRING_IS_EMPTY")
    String language;
    double basePrice;
    String classify;
    List<CategoryRequest> categories;
}
