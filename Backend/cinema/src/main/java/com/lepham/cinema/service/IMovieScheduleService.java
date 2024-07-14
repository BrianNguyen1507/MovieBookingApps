package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.ScheduleRequest;
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
    boolean swapSchedule(long id, long idSwap,LocalDate date);

//    MovieScheduleResponse updateSchedule(long id,long filmId);

    ScheduleMobileResponse getAllScheduleByTheaterAndFilm(long theaterId, long filmId, LocalDate date);

    DetailScheduleResponse getMovieScheduleById(long id);
    void holeSeat(long id,String seat);

    void returnSeat(long id,String seat);

    List<MovieScheduleDateResponse> getAllScheduleByRoomAndDate(long roomId, LocalDate dateStart);

    MovieScheduleResponse addSchedule(ScheduleRequest request);
    void deleteSchedule(long id);

}
