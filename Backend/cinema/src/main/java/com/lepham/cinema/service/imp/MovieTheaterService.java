package com.lepham.cinema.service.imp;

import com.lepham.cinema.converter.MovieTheaterConverter;
import com.lepham.cinema.dto.request.MovieTheaterRequest;
import com.lepham.cinema.dto.response.MovieTheaterResponse;
import com.lepham.cinema.entity.MovieTheaterEntity;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.MovieTheaterRepository;
import com.lepham.cinema.service.IMovieTheaterService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class MovieTheaterService implements IMovieTheaterService {

    MovieTheaterRepository movieTheaterRepository;
    MovieTheaterConverter movieTheaterConverter;

    @Override
    public List<MovieTheaterResponse> getAllMovieTheater() {
        List<MovieTheaterEntity> entities = movieTheaterRepository.findAllByHide(false);
        return entities.stream().map(movieTheaterConverter::toResponse).collect(Collectors.toList());
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public MovieTheaterResponse addMovieTheater(MovieTheaterRequest request) {
        Optional<MovieTheaterEntity> theater = movieTheaterRepository.findByName(request.getName());
        if(theater.isPresent()) throw new AppException(ErrorCode.THEATER_NAME_EXIST);
        MovieTheaterEntity entity = movieTheaterConverter.toEntity(request);
        entity.setHide(false);
        return movieTheaterConverter.toResponse(movieTheaterRepository.save(entity));
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public MovieTheaterResponse updateMovieTheater(long id,MovieTheaterRequest request) {
        Optional<MovieTheaterEntity> theater = movieTheaterRepository.findByNameAndIdNot(request.getName(),id);
        if(theater.isPresent()) throw new AppException(ErrorCode.THEATER_NAME_EXIST);
        MovieTheaterEntity entity= movieTheaterRepository.getReferenceById(id);
        entity.setAddress(request.getAddress());
        entity.setName(request.getName());
        return movieTheaterConverter.toResponse(movieTheaterRepository.save(entity));
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public void deleteMovieTheater(long id) {
        MovieTheaterEntity entity = movieTheaterRepository.findById(id)
                .orElseThrow(()->new AppException(ErrorCode.THEATER_NOT_FOUND));
        entity.setHide(true);
        movieTheaterRepository.save(entity);
    }
}
