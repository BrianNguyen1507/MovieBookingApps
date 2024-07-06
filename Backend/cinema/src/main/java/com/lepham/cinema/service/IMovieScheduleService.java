package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.ShowTimeRequest;
import com.lepham.cinema.dto.request.ShowTimesRequest;
import com.lepham.cinema.dto.response.*;

import java.text.ParseException;
import java.time.LocalDate;
import java.util.List;

public interface IMovieScheduleService {
    LatestDateResponse getLatestDate();

    List<ShowTimeResponse> getEstimateShowTimeRemaining(ShowTimesRequest request) throws ParseException;

    List<MovieScheduleResponse> autoSortSchedule(ShowTimesRequest request, long idRoom) throws ParseException;
    List<MovieScheduleResponse> swapSchedule(long id, long idSwap);

    MovieScheduleResponse updateSchedule(long id,long filmId);

    ScheduleMobileResponse getAllScheduleByTheaterAndFilm(long theaterId, long filmId, LocalDate date);

    DetailScheduleResponse getMovieScheduleById(long id);
    void holeSeat(long id,String seat);

    void returnSeat(long id,String seat);

}
