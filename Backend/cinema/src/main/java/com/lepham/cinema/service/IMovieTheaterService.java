package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.MovieTheaterRequest;
import com.lepham.cinema.dto.response.MovieTheaterResponse;

import java.util.List;

public interface IMovieTheaterService {
    List<MovieTheaterResponse> getAllMovieTheater();
    MovieTheaterResponse addMovieTheater(MovieTheaterRequest request);
    MovieTheaterResponse updateMovieTheater(long id,MovieTheaterRequest request);

    void deleteMovieTheater(long id);
}
