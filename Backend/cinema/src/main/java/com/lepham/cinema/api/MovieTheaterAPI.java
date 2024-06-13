package com.lepham.cinema.api;

import com.lepham.cinema.dto.request.MovieTheaterRequest;
import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.dto.response.MovieTheaterResponse;
import com.lepham.cinema.service.imp.MovieTheaterService;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/cinema")
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class MovieTheaterAPI {

    MovieTheaterService movieTheaterService;

    @GetMapping(value = "/getAllMovieTheater")
    APIResponse<List<MovieTheaterResponse>> getAllMovieTheater(){
        return APIResponse.<List<MovieTheaterResponse>>builder()
                .result(movieTheaterService.getAllMovieTheater())
                .build();
    }

    @PostMapping(value = "/addMovieTheater")
    APIResponse<MovieTheaterResponse> addMovieTheater(@RequestBody @Valid MovieTheaterRequest request){
        return APIResponse.<MovieTheaterResponse>builder()
                .result(movieTheaterService.addMovieTheater(request))
                .build();
    }

    @PutMapping(value = "/updateMovieTheater")
    APIResponse<MovieTheaterResponse> updateMovieTheater(@RequestParam("id") long id
            , @RequestBody @Valid MovieTheaterRequest request){
        return APIResponse.<MovieTheaterResponse>builder()
                .result(movieTheaterService.updateMovieTheater(id,request))
                .build();
    }

    @DeleteMapping(value = "/deleteMovieTheater")
    APIResponse<?> deleteMovieTheater(@RequestParam("id") long id){
        movieTheaterService.deleteMovieTheater(id);
        return APIResponse.builder()
                .message("Delete successful")
                .build();
    }
}
