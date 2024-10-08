package com.lepham.cinema.service.imp;

import com.lepham.cinema.constant.ConstantVariable;
import com.lepham.cinema.converter.DateConverter;
import com.lepham.cinema.converter.FilmConverter;
import com.lepham.cinema.converter.MovieScheduleConverter;
import com.lepham.cinema.dto.request.ScheduleRequest;
import com.lepham.cinema.dto.request.ShowTimeRequest;
import com.lepham.cinema.dto.request.ShowTimesRequest;
import com.lepham.cinema.dto.response.*;
import com.lepham.cinema.entity.FilmEntity;
import com.lepham.cinema.entity.MovieScheduleEntity;
import com.lepham.cinema.entity.RoomEntity;
import com.lepham.cinema.entity.SeatHeldEntity;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.FilmRepository;
import com.lepham.cinema.repository.MovieScheduleRepository;
import com.lepham.cinema.repository.RoomRepository;
import com.lepham.cinema.repository.SeatHeldRepository;
import com.lepham.cinema.service.IMovieScheduleService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class MovieScheduleService implements IMovieScheduleService {

    MovieScheduleRepository movieScheduleRepository;

    FilmRepository filmRepository;

    FilmConverter filmConverter;

    RoomRepository roomRepository;

    MovieScheduleConverter movieScheduleConverter;
    SeatHeldRepository seatHeldRepository;

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public LatestDateResponse getLatestDate() {
        MovieScheduleEntity entity = movieScheduleRepository.getLatestDate();
        LatestDateResponse response = new LatestDateResponse();
        LocalDate localDate = entity.getTimeStart().toLocalDate();
        localDate.plusDays(1);
        response.setDateStart(localDate);
        localDate.plusDays(ConstantVariable.step);
        response.setDateEnd(localDate);
        return response;
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public List<ShowTimeResponse> getEstimateShowTimeRemaining(ShowTimesRequest requests) throws ParseException {
        int minuteRemaining = ConstantVariable.totalMinuteByDay;
        List<FilmEntity> entities = new ArrayList<>();
        for (ShowTimeRequest request : requests.getShowTimes()) {
            FilmEntity entity = filmRepository.findById(request.getIdFilm())
                    .orElseThrow(() -> new AppException(ErrorCode.FILM_NOT_FOUND));
            minuteRemaining -= (entity.getDuration() * request.getQuantity()) / 7;
            entities.add(entity);
        }
        List<ShowTimeResponse> showTimeResponses = new ArrayList<>();
        Date dateStart = DateConverter.convertLocalDateToDate(requests.getDateStart());
        Calendar cdStart = Calendar.getInstance();
        cdStart.setTime(dateStart);
        Calendar cdEnd = Calendar.getInstance();
        cdEnd.setTime(dateStart);
        cdEnd.add(Calendar.DAY_OF_YEAR, 7);


        List<FilmEntity> filmEntities = filmRepository.findAllByActiveAndHide();
        for (FilmEntity film : filmEntities) {
            if (!entities.contains(film)) {
                Calendar cdFilm = Calendar.getInstance();
                cdFilm.setTime(DateConverter.localDateToDate(film.getReleaseDate()));
                if (cdEnd.get(Calendar.DAY_OF_YEAR) >= cdFilm.get(Calendar.DAY_OF_YEAR)) {
                    ShowTimeResponse showTime = new ShowTimeResponse();
                    FilmScheduleResponse filmResponse = new FilmScheduleResponse();
                    filmResponse.setId(film.getId());
                    filmResponse.setTitle(film.getTitle());
                    filmResponse.setReleaseDate(film.getReleaseDate());

                    // check release date between date start and date end
                    boolean checkReleaseDate = cdFilm.get(Calendar.DAY_OF_YEAR) <= cdEnd.get(Calendar.DAY_OF_YEAR)
                            && cdFilm.get(Calendar.DAY_OF_YEAR) >= cdStart.get(Calendar.DAY_OF_YEAR);

                    int quantity = checkReleaseDate
                            ? 16 * 60 / film.getDuration() * ((getDayByCalendar(cdFilm, cdEnd) + 1))
                            : (minuteRemaining / film.getDuration()) * 7;
                    int limitMax = 0;
                    for (FilmEntity filmLimit : filmEntities) {
                        Calendar cdFilmLimit = Calendar.getInstance();
                        cdFilmLimit.setTime(DateConverter.localDateToDate(filmLimit.getReleaseDate()));
                        if (!entities.contains(filmLimit)) {
                            if (cdFilmLimit.get(Calendar.DAY_OF_YEAR) > cdFilm.get(Calendar.DAY_OF_YEAR)) {
                                limitMax += getDayByCalendar(cdFilmLimit, cdEnd) + 1;
                            } else {
                                limitMax += getDayByCalendar(cdFilm, cdEnd) + 1;
                            }
                        } else {
                            if (cdFilmLimit.get(Calendar.DAY_OF_YEAR) > cdFilm.get(Calendar.DAY_OF_YEAR)) {
                                limitMax -= getDayByCalendar(cdFilmLimit, cdEnd);
                            } else {
                                limitMax -= getDayByCalendar(cdFilm, cdEnd);
                            }
                        }
                    }
                    showTime.setLimitMax(quantity - limitMax);
                    showTime.setFilm(filmResponse);
                    showTime.setQuantity(quantity);
                    showTimeResponses.add(showTime);
                }
            }
        }
        return showTimeResponses;
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public List<MovieScheduleResponse> autoSortSchedule(ShowTimesRequest request, long idRoom) throws ParseException {
        List<ShowTimeRequest> showTimes = request.getShowTimes();
        showTimes.sort(Comparator.comparingInt(ShowTimeRequest::getQuantity));
        List<List<MovieScheduleEntity>> movieScheduleAllDay = new ArrayList<>();
        for (int i = 0; i < ConstantVariable.step; i++) {
            List<MovieScheduleEntity> movieSchedule = new ArrayList<>();
            for (ShowTimeRequest showTime : showTimes) {
                int avgShowTime = showTime.getQuantity() / ConstantVariable.step;
                int surplusShowTime = showTime.getQuantity() % ConstantVariable.step;

                if (avgShowTime > 0) {
                    for (int j = 0; j < avgShowTime; j++) {
                        MovieScheduleEntity schedule = saveSchedule(showTime.getIdFilm(), idRoom);
                        movieSchedule.add(schedule);
                    }
                    if (i < surplusShowTime) {
                        MovieScheduleEntity schedule = saveSchedule(showTime.getIdFilm(), idRoom);
                        movieSchedule.add(schedule);
                    }
                } else {
                    MovieScheduleEntity schedule = saveSchedule(showTime.getIdFilm(), idRoom);
                    Calendar cdShowTime = Calendar.getInstance();
                    cdShowTime.setTime(DateConverter.localDateToDate(schedule.getFilm().getReleaseDate()));
                    Calendar cdStart = Calendar.getInstance();
                    cdStart.setTime(DateConverter.convertLocalDateToDate(request.getDateStart()));
                    if (cdShowTime.get(Calendar.DAY_OF_YEAR) - cdStart.get(Calendar.DAY_OF_YEAR) <= i + 1) {
                        schedule = saveSchedule(showTime.getIdFilm(), idRoom);
                        movieSchedule.add(schedule);
                    }
                }
            }

            movieScheduleAllDay.add(movieSchedule);
        }
        LocalDate dateStart = request.getDateStart();
        List<MovieScheduleEntity> entities = new ArrayList<>();
        for (List<MovieScheduleEntity> movieSchedule : movieScheduleAllDay) {
            int day = movieScheduleAllDay.indexOf(movieSchedule);
            LocalDateTime localDateTime = LocalDateTime.now()
                    .withDayOfYear(dateStart.getDayOfYear() + day)
                    .withHour(ConstantVariable.hourStart)
                    .withMinute(0)
                    .withSecond(0)
                    .withNano(0);
            long id = 0;
            for (MovieScheduleEntity schedule : movieSchedule) {
                if (id != 0) {
                    schedule.setId(++id);
                }
                schedule.setTimeStart(localDateTime);
                schedule = movieScheduleRepository.save(schedule);
                entities.add(schedule);
                id = schedule.getId();
                int duration = 0;
                if (schedule.getFilm().getDuration() % 10 == 0) {
                    duration = (schedule.getFilm().getDuration() / 10) * 10 + 5;
                } else if (schedule.getFilm().getDuration() % 10 <= 5) {
                    duration = (schedule.getFilm().getDuration() / 10) * 10 + 10;
                } else {
                    duration = (schedule.getFilm().getDuration() / 10) * 10 + 15;
                }

                int hours = (duration / 60);
                int minutes = (duration % (60 * hours));
                if (minutes + localDateTime.getMinute() >= 60) {
                    minutes = minutes - 60;
                    hours++;
                }
                if (localDateTime.getHour() + hours >= 24 || localDateTime.getHour() < ConstantVariable.hourStart)
                    break;
                localDateTime = localDateTime.plusMinutes(minutes);
                localDateTime = localDateTime.plusHours(hours);
            }
        }
        return entities.stream()
                .map(entity -> movieScheduleConverter
                        .toResponse(entity, filmConverter.toFilmScheduleResponse(entity.getFilm())))
                .toList();
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    @Transactional
    public boolean swapSchedule(long id, long idSwap, LocalDate date) {
        if (idSwap != -1) {
            MovieScheduleEntity schedule = movieScheduleRepository.findById(id)
                    .orElseThrow(() -> new AppException(ErrorCode.SCHEDULE_NOT_FOUND));
            MovieScheduleEntity scheduleSwap = movieScheduleRepository.findById(idSwap)
                    .orElseThrow(() -> new AppException(ErrorCode.SCHEDULE_NOT_FOUND));
            if (!schedule.getTimeStart().toLocalDate().isAfter(LocalDate.now().plusDays(7))
                    || !scheduleSwap.getTimeStart().toLocalDate().isAfter(LocalDate.now().plusDays(7)))
                throw new AppException(ErrorCode.DATE_AFTER_NOW);
            if (schedule.getFilm().getReleaseDate().isAfter(scheduleSwap.getTimeStart().toLocalDate())
                    || (scheduleSwap.getFilm().getReleaseDate().isAfter(schedule.getTimeStart().toLocalDate())))
                throw new AppException(ErrorCode.FILM_NOT_RELEASE);
            if (Objects.equals(schedule.getFilm(), scheduleSwap.getFilm())) return true;
            FilmEntity filmSwap = schedule.getFilm();
            schedule.setFilm(scheduleSwap.getFilm());
            schedule = movieScheduleRepository.save(schedule);
            scheduleSwap.setFilm(filmSwap);
            scheduleSwap = movieScheduleRepository.save(scheduleSwap);
            if (Objects.equals(schedule.getTimeStart(), scheduleSwap.getTimeStart())) {

                List<MovieScheduleEntity> scheduleToday = movieScheduleRepository.findAllByRoomIdAndDateStart(
                        schedule.getRoom().getId(),
                        schedule.getTimeStart().toLocalDate(),
                        Sort.by(Sort.Direction.ASC, "timeStart"));

                generateScheduleByDate(scheduleToday);
            } else {
                List<MovieScheduleEntity> scheduleList = movieScheduleRepository.findAllByRoomIdAndDateStart(
                        schedule.getRoom().getId(),
                        schedule.getTimeStart().toLocalDate(),
                        Sort.by(Sort.Direction.ASC, "timeStart"));
                List<MovieScheduleEntity> scheduleSwapList = movieScheduleRepository.findAllByRoomIdAndDateStart(
                        scheduleSwap.getRoom().getId(),
                        scheduleSwap.getTimeStart().toLocalDate(),
                        Sort.by(Sort.Direction.ASC, "timeStart"));
                generateScheduleByDate(scheduleList);
                generateScheduleByDate(scheduleSwapList);
            }
            return true;
        } else {
            MovieScheduleEntity movieSchedule = movieScheduleRepository.findById(id)
                    .orElseThrow(() -> new AppException(ErrorCode.SCHEDULE_NOT_FOUND));
            RoomEntity room = movieSchedule.getRoom();
            FilmEntity film = movieSchedule.getFilm();
            deleteSchedule(movieSchedule.getId());
            addSchedule(ScheduleRequest.builder()
                    .roomId(room.getId())
                    .filmId(film.getId())
                    .date(date)
                    .build());
            return true;
        }
    }

    public ScheduleMobileResponse getAllScheduleByTheaterAndFilm(long theaterId, long filmId, LocalDate date) {
        List<MovieScheduleEntity> scheduleEntities = movieScheduleRepository.findAllByFilmAndMovieTheater(filmId, theaterId, date);
        if (scheduleEntities.isEmpty()) throw new AppException(ErrorCode.SCHEDULE_NOT_FOUND);
        return movieScheduleConverter.toScheduleMobileResponse(scheduleEntities, filmConverter.toFilmScheduleResponse(scheduleEntities.getFirst().getFilm()));
    }

    @Override
    public DetailScheduleResponse getMovieScheduleById(long id) {
        MovieScheduleEntity movieSchedule = movieScheduleRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.SCHEDULE_NOT_FOUND));
        return movieScheduleConverter.toDetailScheduleResponse(movieSchedule);
    }

    int getDayByCalendar(Calendar cdStart, Calendar cdEnd) {
        return cdEnd.get(Calendar.DAY_OF_YEAR) - cdStart.get(Calendar.DAY_OF_YEAR);
    }

    MovieScheduleEntity saveSchedule(long idFilm, long idRoom) {
        MovieScheduleEntity schedule = new MovieScheduleEntity();
        FilmEntity film = filmRepository.findByIdAndHideAndActive(idFilm, false, 0)
                .orElseThrow(() -> new AppException(ErrorCode.FILM_NOT_FOUND));
        RoomEntity room = roomRepository.findByIdAndHide(idRoom, false)
                .orElseThrow(() -> new AppException(ErrorCode.ROOM_NOT_FOUND));
        schedule.setFilm(film);
        schedule.setRoom(room);
        schedule.setSeat(schedule.generateSeat(room.getRow(), room.getColumn()));
        return schedule;
    }



    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public List<MovieScheduleDateResponse> getAllScheduleByRoomAndDate(long roomId, LocalDate dateStart) {
        List<MovieScheduleDateResponse> responses = new ArrayList<>();
        for (int i = 0; i < ConstantVariable.step; i++) {
            MovieScheduleDateResponse movieScheduleDateResponse = new MovieScheduleDateResponse();
            movieScheduleDateResponse.setDate(dateStart.plusDays(i));
            List<MovieScheduleEntity> scheduleEntities = movieScheduleRepository
                    .findAllByRoomIdAndDateStart(
                            roomId,
                            movieScheduleDateResponse.getDate(),
                            Sort.by(Sort.Direction.ASC, "timeStart"));
            movieScheduleDateResponse.setMovieSchedule(
                    scheduleEntities.stream()
                            .map(schedule -> movieScheduleConverter
                                    .toResponse(schedule, filmConverter.toFilmScheduleResponse(schedule.getFilm()))).toList());
            responses.add(movieScheduleDateResponse);
        }
        return responses;
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public MovieScheduleResponse addSchedule(ScheduleRequest request) {
        FilmEntity film = filmRepository.findById(request.getFilmId())
                .orElseThrow(() -> new AppException(ErrorCode.FILM_NOT_FOUND));
        RoomEntity room = roomRepository.findByIdAndHide(request.getRoomId(), false)
                .orElseThrow(() -> new AppException(ErrorCode.ROOM_NOT_FOUND));
        if (film.getReleaseDate().isAfter(request.getDate())) throw new AppException(ErrorCode.FILM_NOT_RELEASE);
        List<MovieScheduleEntity> movieScheduleEntities = movieScheduleRepository
                .findAllByRoomIdAndDateStart(request.getRoomId(), request.getDate(), Sort.by(Sort.Direction.ASC, "timeStart"));
        LocalTime time = LocalTime.of(8, 0);
        LocalDateTime timeStart = request.getDate().atTime(time);
        if (!movieScheduleEntities.isEmpty()) {
            MovieScheduleEntity movieScheduleLast = movieScheduleEntities.getLast();
            //Rounding duration
            int duration = durationRounding(movieScheduleLast.getFilm().getDuration());
            timeStart = movieScheduleLast.getTimeStart().plusMinutes(duration);
            if (timeStart.getDayOfYear() == movieScheduleLast.getTimeStart().plusDays(1).getDayOfYear())
                throw new AppException(ErrorCode.START_TIME_NOT_TODAY);
        }
        MovieScheduleEntity movieSchedule = new MovieScheduleEntity();
        movieSchedule.setFilm(film);
        movieSchedule.setRoom(room);
        movieSchedule.setSeat(movieSchedule.generateSeat(room.getRow(), room.getColumn()));
        movieSchedule.setTimeStart(timeStart);
        return movieScheduleConverter.toResponse(movieScheduleRepository.save(movieSchedule), filmConverter.toFilmScheduleResponse((film)));
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public void deleteSchedule(long id) {
        MovieScheduleEntity movieSchedule = movieScheduleRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.SCHEDULE_NOT_FOUND));
        LocalDateTime timeStart = movieSchedule.getTimeStart();
        if (!movieSchedule.getTimeStart().toLocalDate().isAfter(LocalDate.now().plusDays(7)))
            throw new AppException(ErrorCode.DATE_AFTER_NOW);
        movieScheduleRepository.delete(movieSchedule);
        List<MovieScheduleEntity> scheduleAfter = movieScheduleRepository.findAllByTimeStartAfter(timeStart.toLocalDate(), timeStart);
        scheduleAfter.forEach(schedule -> {
            //Rounding duration
            int duration = durationRounding(schedule.getFilm().getDuration());
            schedule.setTimeStart(timeStart);
            movieScheduleRepository.save(schedule);
            timeStart.plusMinutes(duration);
        });

    }

    private int durationRounding(int duration) {
        return (duration % 10) <= 5 ?
                (duration / 10) * 10 + 10 :
                (duration / 10) * 10 + 15;
    }

    private void generateScheduleByDate(List<MovieScheduleEntity> movieScheduleEntities) {
        LocalDateTime timeStart = movieScheduleEntities.getFirst().getTimeStart();
        ;
        for (MovieScheduleEntity movieSchedule : movieScheduleEntities) {
            int duration = durationRounding(movieSchedule.getFilm().getDuration());
            movieSchedule.setTimeStart(timeStart);
            movieScheduleRepository.save(movieSchedule);
            try {
                timeStart = timeStart.plusMinutes(duration);
            } catch (Exception exception) {
                throw new AppException(ErrorCode.START_TIME_NOT_TODAY);
            }
        }
    }
}
