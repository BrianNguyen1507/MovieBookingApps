package com.lepham.cinema.dto.request;

import com.lepham.cinema.validator.DateConstraint;
import com.lepham.cinema.validator.DurationConstraint;
import com.lepham.cinema.validator.PriceConstraint;
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
public class FilmRequest {
    @StringConstraint
    String title;
    @DurationConstraint(message = "DURATION_INVALID")
    int duration;
    byte [] description;

    @DateConstraint
    LocalDate releaseDate;
    @StringConstraint
    String director;
    @StringConstraint
    String actor;
    byte[] poster;
    String trailer;
    @StringConstraint
    String country;
    @StringConstraint
    String language;

    @PriceConstraint
    double basePrice;
    String classify;
    List<CategoryRequest> categories;
}
