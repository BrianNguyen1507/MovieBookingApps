package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.FilmRequest;
import com.lepham.cinema.dto.response.FilmResponse;

import java.text.ParseException;
import java.util.List;

public interface IFilmService {
    List<FilmResponse> getAllFilmByStep(int step);
    List<FilmResponse> getAllFilm();
    FilmResponse getFilmById(long id);
    FilmResponse addFilm(FilmRequest request) throws ParseException;
    FilmResponse updateFilm(long id,FilmRequest request) throws ParseException;
    void deleteFilm(long id);

    List<FilmResponse> searchFilm(String textFilter);
    List<FilmResponse> getListMovieRelease();
    List<FilmResponse> getListMovieFuture();
    List<FilmResponse> getListMovieFutureByMonth(int month);
}
