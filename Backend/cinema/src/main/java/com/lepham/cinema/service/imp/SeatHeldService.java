package com.lepham.cinema.service.imp;

import com.lepham.cinema.constant.ConstantVariable;
import com.lepham.cinema.entity.AccountEntity;
import com.lepham.cinema.entity.MovieScheduleEntity;
import com.lepham.cinema.entity.SeatHeldEntity;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.AccountRepository;
import com.lepham.cinema.repository.MovieScheduleRepository;
import com.lepham.cinema.repository.SeatHeldRepository;
import com.lepham.cinema.service.ISeatHeldService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class SeatHeldService implements ISeatHeldService {
    SeatHeldRepository seatHeldRepository;
    MovieScheduleRepository movieScheduleRepository;
    AccountRepository accountRepository;

    @Override
    @PreAuthorize("hasRole('USER')")
    @Transactional
    public void holeSeat(long id, String seat) {
        var context = SecurityContextHolder.getContext();
        String email = context.getAuthentication().getName();
        MovieScheduleEntity schedule = movieScheduleRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.SCHEDULE_NOT_FOUND));
        AccountEntity account = accountRepository.findByEmail(email)
                .orElseThrow(() -> new AppException(ErrorCode.ACCOUNT_NOT_EXIST));

        String[] seatArray = seat.split(",");
        for (String seatComponent : seatArray){
            SeatHeldEntity seatHeld = seatHeldRepository.findByScheduleAndSeat(schedule, seat);
            seatHeld = seatHeld != null ? seatHeld : new SeatHeldEntity();
            seatHeld.setHeldDateTime(LocalDateTime.now());
            seatHeld.setSchedule(schedule);
            seatHeld.setSeat(seatComponent);
            seatHeld.setAccount(account);
            seatHeld.setStatus(ConstantVariable.SEAT_HOLD);
            seatHeldRepository.save(seatHeld);
        }
        if (!schedule.holdSeat(seat)) throw new AppException(ErrorCode.SEAT_WAS_ORDERED);
        movieScheduleRepository.save(schedule);
    }

    @Override
    @PreAuthorize("hasRole('USER')")
    public boolean checkAccountHoldSeat(long id, String seat) {
        var context = SecurityContextHolder.getContext();
        String email = context.getAuthentication().getName();
        MovieScheduleEntity schedule = movieScheduleRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.SCHEDULE_NOT_FOUND));
        AccountEntity account = accountRepository.findByEmail(email)
                .orElseThrow(() -> new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
        boolean flag = true;
        String[] seatArray = seat.split(",");

        for (String seatComponent : seatArray){
            if(seatHeldRepository.findByScheduleAndSeat(schedule,seatComponent)!=null){
                if(seatHeldRepository.findByScheduleAndSeatAndAccountAndStatus(
                                schedule,
                                seatComponent,
                                account,
                                ConstantVariable.SEAT_HOLD)
                        .isEmpty())return false;
            }
        }
        return flag;
    }

    @Override
    @PreAuthorize("hasRole('USER')")
    public void returnSeat(long id, String seat) {
        var context = SecurityContextHolder.getContext();
        String email = context.getAuthentication().getName();
        MovieScheduleEntity schedule = movieScheduleRepository.findById(id)
                 .orElseThrow(() -> new AppException(ErrorCode.SCHEDULE_NOT_FOUND));
        AccountEntity account = accountRepository.findByEmail(email)
                .orElseThrow(() -> new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
        String[] seatArray = seat.split(",");
        for (String seatComponent : seatArray){
            SeatHeldEntity seatHeld = seatHeldRepository.findByScheduleAndSeatAndAccountAndStatus(
                            schedule,
                            seatComponent,
                            account,
                            ConstantVariable.SEAT_HOLD)
                    .orElseThrow(() ->  new AppException(ErrorCode.SEAT_NOT_ORDERED));
            seatHeldRepository.delete(seatHeld);
            if (!schedule.returnSeat(seatComponent)) throw new AppException(ErrorCode.SEAT_NOT_ORDERED);
        }
        movieScheduleRepository.save(schedule);
    }
    @Override
    @Scheduled(fixedRate = 60000)
    public void autoReturnSeat() {
        LocalDateTime localDateTime = LocalDateTime.now().minusMinutes(5);
        List<SeatHeldEntity> seats = seatHeldRepository.findByHeldDateTimeBeforeAndStatus(localDateTime, ConstantVariable.SEAT_HOLD);
        seats.forEach(seat -> {
           MovieScheduleEntity schedule = movieScheduleRepository.findById(seat.getSchedule().getId())
                   .orElseThrow(() -> new AppException(ErrorCode.SCHEDULE_NOT_FOUND));;
           schedule.returnSeat(seat.getSeat());
           movieScheduleRepository.save(schedule);
           seatHeldRepository.delete(seat);
        });
    }
}
