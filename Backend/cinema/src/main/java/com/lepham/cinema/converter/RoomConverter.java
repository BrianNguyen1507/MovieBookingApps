package com.lepham.cinema.converter;

import com.lepham.cinema.dto.request.RoomRequest;
import com.lepham.cinema.dto.response.MovieTheaterResponse;
import com.lepham.cinema.dto.response.RoomResponse;
import com.lepham.cinema.entity.MovieTheaterEntity;
import com.lepham.cinema.entity.RoomEntity;
import com.lepham.cinema.repository.RoomRepository;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface RoomConverter {
    default RoomEntity toEntity(RoomRequest request, MovieTheaterEntity movieTheater){
        RoomEntity entity = new RoomEntity();
        entity.setNumber(request.getNumber());
        entity.setMovieTheater(movieTheater);
        entity.setRow(request.getRow());
        entity.setColumn(request.getColumn());
        return entity;
    }
    default RoomResponse toResponse(RoomEntity entity, MovieTheaterResponse movieTheaterResponse){
        RoomResponse response = new RoomResponse();
        response.setId(entity.getId());
        response.setRow(entity.getRow());
        response.setColumn(entity.getColumn());
        response.setNumber(entity.getNumber());
        response.setMovieTheater(movieTheaterResponse);
        return response;
    }
}
