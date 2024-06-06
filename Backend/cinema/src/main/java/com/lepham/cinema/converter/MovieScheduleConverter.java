package com.lepham.cinema.converter;

import com.lepham.cinema.dto.response.FilmScheduleResponse;
import com.lepham.cinema.dto.response.MovieScheduleResponse;
import com.lepham.cinema.entity.FilmEntity;
import com.lepham.cinema.entity.MovieScheduleEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface MovieScheduleConverter {

    default MovieScheduleResponse toResponse(MovieScheduleEntity entity, FilmScheduleResponse film){
        MovieScheduleResponse response = new MovieScheduleResponse();
        response.setFilm(film);
        response.setId(entity.getId());
        response.setTime(DateConverter.toTime(entity.getTimeStart()));
        response.setDate(DateConverter.toStringDMY(entity.getTimeStart()));
        return response;
    }
}
