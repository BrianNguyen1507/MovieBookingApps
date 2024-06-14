package com.lepham.cinema.service.imp;

import com.lepham.cinema.converter.MovieTheaterConverter;
import com.lepham.cinema.converter.RoomConverter;
import com.lepham.cinema.dto.request.RoomRequest;
import com.lepham.cinema.dto.response.RoomResponse;
import com.lepham.cinema.entity.MovieTheaterEntity;
import com.lepham.cinema.entity.RoomEntity;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.MovieTheaterRepository;
import com.lepham.cinema.repository.RoomRepository;
import com.lepham.cinema.service.IRoomService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class RoomService implements IRoomService {

    RoomRepository roomRepository;
    RoomConverter roomConverter;
    MovieTheaterRepository theaterRepository;
    MovieTheaterConverter movieTheaterConverter;

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public List<RoomResponse> getAllRoom() {
        List<RoomEntity> entities = roomRepository.findAllByHide(false);
        return entities.stream().map(entity ->
                roomConverter.toResponse(entity,movieTheaterConverter.toResponse(entity.getMovieTheater())))
                .collect(Collectors.toList());
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public RoomResponse getRoomById(long id) {
        RoomEntity room = roomRepository.findById(id).orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));
        return roomConverter.toResponse(room,movieTheaterConverter.toResponse(room.getMovieTheater()));
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public List<RoomResponse> getAllRoomByTheater(long theaterId) {
        List<RoomEntity> entities = roomRepository.findAllByMovieTheater_Id(theaterId);
        return entities.stream().map(entity ->
                        roomConverter.toResponse(entity,movieTheaterConverter.toResponse(entity.getMovieTheater())))
                .collect(Collectors.toList());
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public RoomResponse addRoom(RoomRequest request) {
        MovieTheaterEntity movieTheater = theaterRepository.findById(request.getTheaterId())
                .orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));
        RoomEntity entity = roomConverter.toEntity(request,movieTheater);
        if(roomRepository.checkExistsRoom(request.getNumber(),request.getTheaterId())!=null)
            throw new AppException(ErrorCode.ROOM_EXISTS);
        entity.setHide(false);
        return roomConverter.toResponse(roomRepository.save(entity),
                movieTheaterConverter.toResponse(entity.getMovieTheater()));
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public RoomResponse updateRoom(long roomId, RoomRequest request) {
        MovieTheaterEntity movieTheater = theaterRepository.findById(request.getTheaterId())
                .orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));
        if(roomRepository.checkExistsRoom(request.getNumber(),request.getTheaterId())!=null)
            throw new AppException(ErrorCode.ROOM_EXISTS);
        RoomEntity entity = roomRepository.getReferenceById(roomId);
        entity.setRow(request.getRow());
        entity.setColumn(request.getColumn());
        entity.setNumber(request.getNumber());
        entity.setMovieTheater(movieTheater);
        return roomConverter.toResponse(roomRepository.save(entity),
                movieTheaterConverter.toResponse(entity.getMovieTheater()));
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public void deleteRoom(long id) {
        RoomEntity entity = roomRepository.findById(id).orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));
        if(entity.getMovieTheater()==null&&entity.getSchedules()==null){
            roomRepository.delete(entity);
        }
        else{
            entity.setHide(true);
            roomRepository.save(entity);
        }
    }
}
