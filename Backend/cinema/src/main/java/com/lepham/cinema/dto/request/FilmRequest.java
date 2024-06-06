package com.lepham.cinema.dto.request;

import com.lepham.cinema.dto.response.CategoryResponse;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;

import java.util.Date;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FilmRequest {
    String title;
    int duration;
    byte[] description;
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
