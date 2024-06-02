package com.lepham.cinema.dto.response;

import com.lepham.cinema.dto.response.CategoryResponse;
import jakarta.persistence.Column;
import lombok.*;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;

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
    String duration;
    byte[] description;
    String releaseDate;
    String director;
    String actor;
    byte[] poster;
    String trailer;
    String country;
    String language;
    double basePrice;
    List<CategoryResponse> categories;
}
