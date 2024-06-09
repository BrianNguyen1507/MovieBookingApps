package com.lepham.cinema.api;

import com.lepham.cinema.dto.request.FilmRequest;
import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.dto.response.FilmResponse;
import com.lepham.cinema.service.imp.FilmService;
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
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class FilmAPI {

    FilmService filmService;

    @GetMapping(value = "/getAllFilm")
    APIResponse<List<FilmResponse>> getAllFilm(@RequestParam("step") int step){
        return APIResponse.<List<FilmResponse>>builder()
                .result(filmService.getAllFilm(step))
                .build();
    }

    @GetMapping(value = "/getFilmById")
    APIResponse<FilmResponse> getFilmById(@RequestParam("id") long id){
        return APIResponse.<FilmResponse>builder()
                .result(filmService.getFilmById(id))
                .build();
    }

    @PostMapping(value = "/addFilm")
    APIResponse<FilmResponse> addFilm(@RequestBody FilmRequest request) throws ParseException {
        return APIResponse.<FilmResponse>builder()
                .result(filmService.addFilm(request))
                .build();
    }

    @PutMapping(value = "/updateFilm")
    APIResponse<FilmResponse> updateFilm(@RequestParam("id") long id, @RequestBody FilmRequest request) throws ParseException {
        return APIResponse.<FilmResponse>builder()
                .result(filmService.updateFilm(id, request))
                .build();
    }

    @DeleteMapping(value = "/deleteFilm")
    APIResponse<?> deleteFilm(@RequestParam("id") long id){
        filmService.deleteFilm(id);
        return APIResponse.builder()
                .message("Delete successful")
                .build();
    }
}
