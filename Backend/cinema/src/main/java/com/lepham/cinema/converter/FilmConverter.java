package com.lepham.cinema.converter;

import com.lepham.cinema.dto.request.FilmRequest;
import com.lepham.cinema.dto.response.FilmResponse;
import com.lepham.cinema.entity.FilmEntity;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.text.ParseException;

@Component
@RequiredArgsConstructor
@Slf4j

@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class FilmConverter {

    CategoryConverter categoryConverter;

    public FilmResponse toFilmResponse(FilmEntity entity){
        return FilmResponse.builder()
                .id(entity.getId())
                .releaseDate(DateConverter.toStringYMDTime(entity.getReleaseDate()))
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
                .build();
    }

    public FilmEntity toFilmEntity(FilmRequest request) throws ParseException {
        FilmEntity entity = new FilmEntity();
        entity.setActor(request.getActor());
        entity.setCountry(request.getCountry());
        entity.setDescription(request.getDescription());
        entity.setDirector(request.getDirector());
        entity.setDuration(request.getDuration());
        entity.setBasePrice(request.getBasePrice());
        entity.setLanguage(request.getLanguage());
        entity.setPoster(request.getPoster());
        entity.setReleaseDate(DateConverter.toYMDTime(request.getReleaseDate()));
        entity.setTrailer(request.getTrailer());
        entity.setTitle(request.getTitle());
        entity.setCategories(categoryConverter.toListEntities(request.getCategories()));
        return entity;
    }
}
