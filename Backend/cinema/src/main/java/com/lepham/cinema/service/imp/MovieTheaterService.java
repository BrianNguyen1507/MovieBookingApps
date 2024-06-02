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
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class MovieTheaterService implements IMovieTheaterService {

    MovieTheaterRepository movieTheaterRepository;
    MovieTheaterConverter movieTheaterConverter;

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public List<MovieTheaterResponse> getAllMovieTheater() {
        List<MovieTheaterEntity> entities = movieTheaterRepository.findAll();
        return entities.stream().map(movieTheaterConverter::toResponse).collect(Collectors.toList());
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public MovieTheaterResponse addMovieTheater(MovieTheaterRequest request) {
        MovieTheaterEntity entity = movieTheaterConverter.toEntity(request);
        return movieTheaterConverter.toResponse(movieTheaterRepository.save(entity));
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public MovieTheaterResponse updateMovieTheater(long id,MovieTheaterRequest request) {
        MovieTheaterEntity entity= movieTheaterRepository.getReferenceById(id);
        entity.setAddress(request.getAddress());
        entity.setName(request.getName());
        return movieTheaterConverter.toResponse(movieTheaterRepository.save(entity));
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public void deleteMovieTheater(long id) {
        MovieTheaterEntity entity = movieTheaterRepository.findById(id)
                .orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));
        movieTheaterRepository.delete(entity);
    }
}
