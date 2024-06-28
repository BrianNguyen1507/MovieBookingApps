package com.lepham.cinema.controller;

import com.lepham.cinema.dto.request.ShowTimesRequest;
import com.lepham.cinema.dto.response.*;
import com.lepham.cinema.service.imp.MovieScheduleService;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/cinema")
@Slf4j
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class MovieScheduleController {

    MovieScheduleService movieScheduleService;

    @GetMapping(value = "/getLatestDate")
    APIResponse<LatestDateResponse> getLatestDate(){
        return APIResponse.<LatestDateResponse>builder()
                .result(movieScheduleService.getLatestDate())
                .build();
    }
    @PostMapping(value = "/getShowTimeRemaining")
    APIResponse<List<ShowTimeResponse>> getShowTimeRemaining(@RequestBody @Valid ShowTimesRequest request) throws ParseException {
        return APIResponse.<List<ShowTimeResponse>>builder()
                .result(movieScheduleService.getEstimateShowTimeRemaining(request))
                .build();
    }
    @PostMapping(value = "/autoSortSchedule")
    APIResponse<List<MovieScheduleResponse>> autoSortSchedule(@RequestBody @Valid ShowTimesRequest request
            , @RequestParam("roomId") long roomId) throws ParseException {
        return APIResponse.<List<MovieScheduleResponse>>builder()
                .result(movieScheduleService.autoSortSchedule(request,roomId))
                .build();
    }
    @PutMapping(value = "/swapSchedule")
    APIResponse<List<MovieScheduleResponse>> swapSchedule(@RequestParam("id") long id,@RequestParam("idSwap") long idSwap) throws ParseException {
        return APIResponse.<List<MovieScheduleResponse>>builder()
                .result(movieScheduleService.swapSchedule(id,idSwap))
                .build();
    }
    @PutMapping(value = "/updateSchedule")
    APIResponse<MovieScheduleResponse> updateSchedule(@RequestParam("id") long id,@RequestParam("filmId") long filmId) throws ParseException {
        return APIResponse.<MovieScheduleResponse>builder()
                .result(movieScheduleService.updateSchedule(id,filmId))
                .build();
    }
    @GetMapping(value = "/getAllScheduleMobile")
    APIResponse<ScheduleMobileResponse> getAllScheduleByTheaterAndFilm(@RequestParam("filmId") long filmId,
                                                                       @RequestParam("theaterId") long theaterId,
                                                                       @RequestParam("date") LocalDate date){
        return APIResponse.<ScheduleMobileResponse>builder()
                .result(movieScheduleService.getAllScheduleByTheaterAndFilm(theaterId,filmId,date))
                .build();
    }

    @GetMapping(value = "/getMovieScheduleById")
    APIResponse<DetailScheduleResponse> getMovieScheduleById(@RequestParam("id") long id){
        return APIResponse.<DetailScheduleResponse>builder()
                .result(movieScheduleService.getMovieScheduleById(id))
                .build();
    }

}