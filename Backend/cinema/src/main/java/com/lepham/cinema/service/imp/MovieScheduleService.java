package com.lepham.cinema.service.imp;

import com.lepham.cinema.constant.ConstantVariable;
import com.lepham.cinema.converter.DateConverter;
import com.lepham.cinema.converter.FilmConverter;
import com.lepham.cinema.converter.MovieScheduleConverter;
import com.lepham.cinema.dto.request.ShowTimeRequest;
import com.lepham.cinema.dto.request.ShowTimesRequest;
import com.lepham.cinema.dto.response.*;
import com.lepham.cinema.entity.FilmEntity;
import com.lepham.cinema.entity.MovieScheduleEntity;
import com.lepham.cinema.entity.RoomEntity;
import com.lepham.cinema.entity.SeatHeldEntity;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.*;
import com.lepham.cinema.service.IMovieScheduleService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

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
                    .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));
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

                if(avgShowTime>0){
                    for (int j = 0; j < avgShowTime; j++) {
                        MovieScheduleEntity schedule = saveSchedule(showTime.getIdFilm(), idRoom);
                        movieSchedule.add(schedule);
                    }
                    if (i < surplusShowTime) {
                        MovieScheduleEntity schedule = saveSchedule(showTime.getIdFilm(), idRoom);
                        movieSchedule.add(schedule);
                    }
                }
                else{
                    MovieScheduleEntity schedule = saveSchedule(showTime.getIdFilm(), idRoom);
                    Calendar cdShowTime = Calendar.getInstance();
                    cdShowTime.setTime(DateConverter.localDateToDate(schedule.getFilm().getReleaseDate()));
                    Calendar cdStart = Calendar.getInstance();
                    cdStart.setTime(DateConverter.convertLocalDateToDate(request.getDateStart()));
                    if(cdShowTime.get(Calendar.DAY_OF_YEAR)-cdStart.get(Calendar.DAY_OF_YEAR)<=i+1){
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
                    .withDayOfYear(dateStart.getDayOfYear()+day)
                    .withHour(ConstantVariable.hourStart)
                    .withMinute(0)
                    .withSecond(0)
                    .withNano(0);
            long id=0;
            for (MovieScheduleEntity schedule : movieSchedule) {
                if(id!=0){
                    schedule.setId(++id);
                }
                schedule.setTimeStart(localDateTime);
                schedule = movieScheduleRepository.save(schedule);
                entities.add(schedule);
                id=schedule.getId();
                int duration=0;
                if(schedule.getFilm().getDuration() % 10==0){
                    duration= (schedule.getFilm().getDuration() / 10) * 10 + 5 ;
                }
                else if(schedule.getFilm().getDuration() % 10<=5){
                    duration= (schedule.getFilm().getDuration() / 10) * 10 + 10 ;
                }
                else{
                    duration=(schedule.getFilm().getDuration() / 10) * 10 + 15;
                }

                int hours = (duration / 60);
                int minutes =(duration % (60 * hours));
                if(minutes+localDateTime.getMinute()>=60){
                    minutes= minutes-60;
                    hours++;
                }
                if(localDateTime.getHour()+hours >= 24 || localDateTime.getHour()< ConstantVariable.hourStart)break;
                localDateTime  = localDateTime.plusMinutes(minutes);
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
    public List<MovieScheduleResponse> swapSchedule(long id, long idSwap) {
        List<MovieScheduleEntity> response = new ArrayList<>();
        MovieScheduleEntity schedule = movieScheduleRepository.findById(id)
                .orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));
        MovieScheduleEntity scheduleSwap = movieScheduleRepository.findById(idSwap)
                .orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));

        LocalDateTime localDateTime = schedule.getTimeStart(); // Example LocalDateTime

        // Extract hour, day of year, and year
        int hour = localDateTime.getHour();
        int day = localDateTime.getDayOfYear();
        int year = localDateTime.getYear();
        List<MovieScheduleEntity> listSchedule = movieScheduleRepository.getAllByTimeStartAfter(schedule.getTimeStart());

        localDateTime  =scheduleSwap.getTimeStart();
        int hourSwap =  localDateTime.getHour();
        int daySwap = localDateTime.getDayOfYear();
        int yearSwap =localDateTime.getYear();
        List<MovieScheduleEntity> listScheduleSwap = movieScheduleRepository.getAllByTimeStartAfter(scheduleSwap.getTimeStart());
        if( day==daySwap && yearSwap==year){
            if(hour<hourSwap){
                FilmEntity film = schedule.getFilm();
                schedule.setFilm(scheduleSwap.getFilm());
                scheduleSwap.setFilm(film);
                localDateTime = schedule.getTimeStart();
                int duration = (schedule.getFilm().getDuration() % 10) <= 5 ?
                        (schedule.getFilm().getDuration() / 10) * 10 + 10 :
                        (schedule.getFilm().getDuration() / 10) * 10 + 15;
                hour = (duration / 60);
                int minute =(duration % (60 * hour));
                if(minute+localDateTime.getMinute()>=60){
                    minute=60-minute;
                    hour++;
                }
                localDateTime.plusMinutes(minute);
                localDateTime.plusHours(hour);
                scheduleSwap.setTimeStart(localDateTime);
                schedule = movieScheduleRepository.save(schedule);
                scheduleSwap = movieScheduleRepository.save(scheduleSwap);
                response.add(schedule);
                response.add(scheduleSwap);
            }
        }
        else{
            FilmEntity film = schedule.getFilm();
            listSchedule = checkSwap(listSchedule,scheduleSwap.getFilm());
            listScheduleSwap = checkSwap(listScheduleSwap,film);
            if(listSchedule!=null&& listScheduleSwap!=null){
                listSchedule=movieScheduleRepository.saveAll(listSchedule);
                listScheduleSwap=movieScheduleRepository.saveAll(listScheduleSwap);

                response.add(listSchedule.getFirst());
                response.add(listScheduleSwap.getFirst());
            }
        }
        return response.stream()
                .map(entity -> movieScheduleConverter
                        .toResponse(entity,filmConverter.toFilmScheduleResponse(entity.getFilm())))
                .toList();
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public MovieScheduleResponse updateSchedule(long id,long filmId) {
        MovieScheduleEntity schedule = movieScheduleRepository.findById(id)
                .orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));
        List<MovieScheduleEntity> listSchedule = movieScheduleRepository.getAllByTimeStartAfter(schedule.getTimeStart());
        FilmEntity film = filmRepository.findById(filmId)
                .orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));

        listSchedule=checkSwap(listSchedule,film);
        if(listSchedule==null) throw new AppException(ErrorCode.NULL_EXCEPTION);
        listSchedule = movieScheduleRepository.saveAll(listSchedule);
        return movieScheduleConverter.toResponse(listSchedule.getFirst(),filmConverter.toFilmScheduleResponse(film));
    }


    public ScheduleMobileResponse getAllScheduleByTheaterAndFilm(long theaterId, long filmId,LocalDate date) {
        List<MovieScheduleEntity> scheduleEntities = movieScheduleRepository.findAllByFilmAndMovieTheater(filmId,theaterId,date);
        if(scheduleEntities.isEmpty()) throw  new AppException(ErrorCode.NULL_EXCEPTION);
        return movieScheduleConverter.toScheduleMobileResponse(scheduleEntities,filmConverter.toFilmScheduleResponse(scheduleEntities.getFirst().getFilm()));
    }

    @Override
    public DetailScheduleResponse getMovieScheduleById(long id) {
        MovieScheduleEntity movieSchedule = movieScheduleRepository.findById(id)
                .orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));
        return movieScheduleConverter.toDetailScheduleResponse(movieSchedule);
    }

    int getDayByCalendar(Calendar cdStart, Calendar cdEnd) {
        return cdEnd.get(Calendar.DAY_OF_YEAR) - cdStart.get(Calendar.DAY_OF_YEAR);
    }

    MovieScheduleEntity saveSchedule(long idFilm, long idRoom) {
        MovieScheduleEntity schedule = new MovieScheduleEntity();
        FilmEntity film = filmRepository.findByIdAndHideAndActive(idFilm,false,0)
                .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));
        RoomEntity room = roomRepository.findByIdAndHide(idRoom,false)
                .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));
        schedule.setFilm(film);
        schedule.setRoom(room);
        schedule.setSeat(schedule.generateSeat(room.getRow(),room.getColumn()));
        return schedule;
    }
    List<MovieScheduleEntity> checkSwap(List<MovieScheduleEntity> scheduleEntities,FilmEntity film){
        List<MovieScheduleEntity> listScheduleSwap = new ArrayList<>();
        LocalDateTime localDateTime = scheduleEntities.getFirst().getTimeStart();
        for(MovieScheduleEntity schedule : scheduleEntities){
            if(schedule.equals(scheduleEntities.getFirst())){
                schedule.setFilm(film);
            }
            schedule.setTimeStart(localDateTime);
            listScheduleSwap.add(schedule);
            int duration = schedule.getFilm().getDuration() % 10 <= 5 ?
                    (schedule.getFilm().getDuration() / 10) * 10 + 10 :
                    (schedule.getFilm().getDuration() / 10) * 10 + 15;
            int hour = (duration / 60);
            int minute =(duration % (60 * hour));
            if(minute+localDateTime.getMinute()>=60){
                minute = 60-minute;
                hour++;
            }
            if(localDateTime.getHour()+hour >= 24 && !scheduleEntities.getLast().equals(schedule))return null;
            localDateTime.plusMinutes(minute);
            localDateTime.plusHours(hour);
        }
        return listScheduleSwap;
    }
    @Override
    @PreAuthorize("hasRole('USER')")
    public void holeSeat(long id, String seat) {
        MovieScheduleEntity schedule = movieScheduleRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));
        if (!schedule.holdSeat(seat)) throw new AppException(ErrorCode.SEAT_WAS_ORDERED);
        SeatHeldEntity seatHeld = seatHeldRepository.findByScheduleAndSeat(schedule,seat);
        seatHeld = seatHeld!=null?seatHeld:new SeatHeldEntity();
        seatHeld.setHeldDateTime(LocalDateTime.now());
        seatHeld.setSchedule(schedule);
        seatHeld.setSeat(seat);
        seatHeld.setStatus(ConstantVariable.SEAT_HOLD);
        seatHeldRepository.save(seatHeld);
        movieScheduleRepository.save(schedule);
    }
    @Override
    @PreAuthorize("hasRole('USER')")
    public void returnSeat(long id, String seat) {
        MovieScheduleEntity schedule = movieScheduleRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));
        if (!schedule.returnSeat(seat)) throw new AppException(ErrorCode.SEAT_NOT_ORDERED);
        movieScheduleRepository.save(schedule);
    }

}
