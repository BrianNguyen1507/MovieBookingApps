package com.lepham.cinema.service.imp;

import com.lepham.cinema.constant.ConstantVariable;
import com.lepham.cinema.entity.MovieScheduleEntity;
import com.lepham.cinema.entity.SeatHeldEntity;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.MovieScheduleRepository;
import com.lepham.cinema.repository.SeatHeldRepository;
import com.lepham.cinema.service.ISeatHeldService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class SeatHeldService implements ISeatHeldService {
    SeatHeldRepository seatHeldRepository;
    MovieScheduleRepository movieScheduleRepository;

    @Override
    @Scheduled(fixedRate = 60000)
    public void autoReturnSeat() {
        LocalDateTime localDateTime = LocalDateTime.now().minusMinutes(5);
        List<SeatHeldEntity> seats = seatHeldRepository.findByHeldDateTimeBeforeAndStatus(localDateTime, ConstantVariable.SEAT_HOLD);
        seats.forEach(seat -> {
           MovieScheduleEntity schedule = movieScheduleRepository.findById(seat.getSchedule().getId())
                   .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));;
           schedule.returnSeat(seat.getSeat());
           movieScheduleRepository.save(schedule);
           seat.setStatus(ConstantVariable.SEAT_EMPTY);
           seatHeldRepository.save(seat);
        });
    }
}
