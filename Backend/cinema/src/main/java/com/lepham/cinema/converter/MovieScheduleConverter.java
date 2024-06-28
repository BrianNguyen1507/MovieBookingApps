package com.lepham.cinema.converter;

import com.lepham.cinema.constant.ConstantVariable;
import com.lepham.cinema.dto.response.FilmScheduleResponse;
import com.lepham.cinema.dto.response.MovieScheduleResponse;
import com.lepham.cinema.dto.response.ScheduleHourResponse;
import com.lepham.cinema.dto.response.ScheduleMobileResponse;
import com.lepham.cinema.entity.MovieScheduleEntity;
import org.mapstruct.Mapper;

import java.util.ArrayList;
import java.util.List;

@Mapper(componentModel = "spring")

public interface MovieScheduleConverter {

    default MovieScheduleResponse toResponse(MovieScheduleEntity entity, FilmScheduleResponse film) {
        MovieScheduleResponse response = new MovieScheduleResponse();
        response.setFilm(film);
        response.setId(entity.getId());
        response.setTime(entity.getTimeStart().toLocalTime().format(ConstantVariable.formatter));
        response.setDate(entity.getTimeStart().toLocalDate().toString());
        return response;
    }

    default ScheduleMobileResponse toScheduleMobileResponse(List<MovieScheduleEntity> scheduleByDay, FilmScheduleResponse film) {
        ScheduleMobileResponse response = new ScheduleMobileResponse();
        response.setFilm(film);
        response.setDate(scheduleByDay.getLast().getTimeStart().toLocalDate());
        List<ScheduleHourResponse> scheduleDayResponses = new ArrayList<>();

        for (MovieScheduleEntity movieSchedule : scheduleByDay) {
            scheduleDayResponses.add(
                    ScheduleHourResponse.builder()
                            .roomNUmber(movieSchedule.getRoom().getNumber())
                            .times(movieSchedule.getTimeStart().toLocalTime())
                            .build()
            );
        }
        response.setScheduleByHour(scheduleDayResponses);
        return response;
    }
}
