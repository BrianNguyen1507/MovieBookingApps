package com.lepham.cinema.converter;

import com.lepham.cinema.dto.request.FilmRequest;
import com.lepham.cinema.dto.response.FilmResponse;
import com.lepham.cinema.dto.response.FilmScheduleResponse;
import com.lepham.cinema.entity.FilmEntity;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.text.ParseException;
import java.time.LocalDate;

@Component
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class FilmConverter {
    CategoryConverter categoryConverter;
    public FilmResponse toFilmResponse(FilmEntity entity){
        return FilmResponse.builder()
                .id(entity.getId())
                .releaseDate(entity.getReleaseDate())
                .actor(entity.getActor())
                .title(entity.getTitle())
                .country(entity.getCountry())
                .duration(entity.getDuration())
                .poster(entity.getPoster())
                .language(entity.getLanguage())
                .trailer(entity.getTrailer())
                .categories(categoryConverter.toListCategoryRequest(entity.getCategories()))
                .description(entity.getDescription())
                .basePrice(entity.getBasePrice())
                .director(entity.getDirector())
                .classify(entity.getClassify())
                .isRelease(!(LocalDate.now().isBefore(entity.getReleaseDate())))
                .active(entity.getActive())
                .build();
    }

    public FilmEntity toFilmEntity(FilmRequest request){
        FilmEntity entity = new FilmEntity();
        entity.setActor(request.getActor());
        entity.setCountry(request.getCountry());
        entity.setDescription(request.getDescription());
        entity.setDirector(request.getDirector());
        entity.setDuration(request.getDuration());
        entity.setBasePrice(request.getBasePrice());
        entity.setLanguage(request.getLanguage());
        entity.setPoster(request.getPoster());
        entity.setReleaseDate(request.getReleaseDate());
        entity.setTrailer(request.getTrailer());
        entity.setTitle(request.getTitle());
        entity.setClassify(request.getClassify());
        entity.setCategories(categoryConverter.toListEntities(request.getCategories()));
        return entity;
    }
    public FilmScheduleResponse toFilmScheduleResponse(FilmEntity entity){
        FilmScheduleResponse response = new FilmScheduleResponse();
        response.setId(entity.getId());
        response.setTitle(entity.getTitle());
        response.setPoster(entity.getPoster());
        response.setReleaseDate(entity.getReleaseDate());
        response.setDuration(entity.getDuration());
        return response;
    }
}
