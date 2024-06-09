package com.lepham.cinema.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@NonNull
public class FilmRequest {
    String title;
    int duration;
    byte [] description;
    String releaseDate;
    String director;
    String actor;
    byte[] poster;
    String trailer;
    String country;
    String language;
    double basePrice;
    List<CategoryRequest> categories;
}
