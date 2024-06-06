package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.ShowTimeRequest;
import com.lepham.cinema.dto.request.ShowTimesRequest;
import com.lepham.cinema.dto.response.LatestDateResponse;
import com.lepham.cinema.dto.response.MovieScheduleResponse;
import com.lepham.cinema.dto.response.ShowTimeResponse;

import java.text.ParseException;
import java.util.List;

public interface IMovieScheduleService {
    LatestDateResponse getLatestDate();

    List<ShowTimeResponse> getEstimateShowTimeRemaining(ShowTimesRequest request) throws ParseException;

    List<MovieScheduleResponse> autoSortSchedule(ShowTimesRequest request, long idRoom) throws ParseException;
    List<MovieScheduleResponse> swapSchedule(long id, long idSwap);

    MovieScheduleResponse updateSchedule(long id,long filmId);
}
