package com.lepham.cinema.dto.response;

import com.lepham.cinema.dto.response.CategoryResponse;
import jakarta.persistence.Column;
import lombok.*;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
public class FilmResponse {
    long id;
    String title;
    int duration;
    LocalDate releaseDate;
    String director;
    String actor;
    String trailer;
    String country;
    String language;
    double basePrice;
    String classify;
    boolean isRelease;

    List<CategoryResponse> categories;
    byte[] description;
    byte[] poster;
    int active;

}
