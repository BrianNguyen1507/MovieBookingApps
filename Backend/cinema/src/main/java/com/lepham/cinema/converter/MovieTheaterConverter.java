package com.lepham.cinema.converter;

import com.lepham.cinema.dto.request.MovieTheaterRequest;
import com.lepham.cinema.dto.response.MovieTheaterResponse;
import com.lepham.cinema.entity.MovieTheaterEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface MovieTheaterConverter {
    MovieTheaterEntity toEntity(MovieTheaterRequest request);
    MovieTheaterResponse toResponse(MovieTheaterEntity entity);
}
