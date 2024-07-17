package com.lepham.cinema.controller;

import com.lepham.cinema.constant.ConstantVariable;
import com.lepham.cinema.dto.request.FilmRequest;
import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.dto.response.FilmResponse;
import com.lepham.cinema.service.imp.FilmService;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.util.List;

@RestController
@RequestMapping("/cinema")
@Slf4j
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class FilmController {

    FilmService filmService;

    @GetMapping(value = "/getAllFilmByStep")
    APIResponse<List<FilmResponse>> getAllFilmByStep(@RequestParam("step") int step) {
        return APIResponse.<List<FilmResponse>>builder()
                .result(filmService.getAllFilmByStep(step))
                .build();
    }

    @GetMapping(value = "/getAllFilm")
    APIResponse<List<FilmResponse>> getAllFilm() {
        return APIResponse.<List<FilmResponse>>builder()
                .result(filmService.getAllFilm())
                .build();
    }

    @GetMapping(value = "/getFilmById")
    APIResponse<FilmResponse> getFilmById(@RequestParam("id") long id) {
        return APIResponse.<FilmResponse>builder()
                .result(filmService.getFilmById(id))
                .build();
    }

    @PostMapping(value = "/addFilm")
    APIResponse<FilmResponse> addFilm(@RequestBody @Valid FilmRequest request){
        return APIResponse.<FilmResponse>builder()
                .result(filmService.addFilm(request))
                .build();
    }

    @PutMapping(value = "/updateFilm")
    APIResponse<FilmResponse> updateFilm(@RequestParam("id") long id, @RequestBody @Valid FilmRequest request) {
        return APIResponse.<FilmResponse>builder()
                .result(filmService.updateFilm(id, request))
                .build();
    }

    @DeleteMapping(value = "/deleteFilm")
    APIResponse<?> deleteFilm(@RequestParam("id") long id) {
        filmService.deleteFilm(id);
        return APIResponse.builder()
                .message("Delete successful")
                .build();
    }

    @GetMapping(value = "/searchFilm")
    APIResponse<List<FilmResponse>> getFilmById(@RequestParam("keyword") String keyword) {
        return APIResponse.<List<FilmResponse>>builder()
                .result(filmService.searchFilm(keyword)).build();
    }

    @GetMapping(value = "/getListMovieRelease")
    APIResponse<List<FilmResponse>> getListMovieRelease() {
        return APIResponse.<List<FilmResponse>>builder()
                .result(filmService.getListMovieRelease())
                .build();
    }

    @GetMapping(value = "/getListMovieFuture")
    APIResponse<List<FilmResponse>> getListMovieFuture() {
        return APIResponse.<List<FilmResponse>>builder()
                .result(filmService.getListMovieFuture())
                .build();
    }

    @GetMapping(value = "/getListMovieFutureByMonth")
    APIResponse<List<FilmResponse>> getListMovieFutureByMonth(@RequestParam("month")int month) {
        return APIResponse.<List<FilmResponse>>builder()
                .result(filmService.getListMovieFutureByMonth(month))
                .build();
    }
    @PutMapping(value = "/activeFilm")
    APIResponse<?> activeFilm(@RequestParam("id") long id) {
        return APIResponse.builder()
                .message(filmService.activeFilm(id)== ConstantVariable.FILM_RELEASE?"Active successful":"Inactive successful")
                .build();
    }
    @GetMapping(value = "/getAllListMovie")
    APIResponse<List<FilmResponse>>  getAllListMovie() {
        return APIResponse.<List<FilmResponse>>builder()
                .result(filmService.getAllListMovie())
                .build();
    }


}