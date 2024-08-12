package com.lepham.cinema.controller;

import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.service.imp.SeatHeldService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/cinema")
@Slf4j
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class SeatHeldController {

    SeatHeldService seatHeldService;
    @PostMapping("/holdSeat")
    APIResponse<?> holdSeat(@RequestParam("scheduleId") long id, @RequestParam("seat") String  seat){
        seatHeldService.holeSeat(id,seat);
        return APIResponse.builder()
                .message("Hold the seat successfully")
                .build();
    }
    @PostMapping("/returnSeat")
    APIResponse<?> returnSeat(@RequestParam("scheduleId") long id, @RequestParam("seat") String  seat){
        seatHeldService.returnSeat(id,seat);
        return APIResponse.builder()
                .message("RefundSeat the seat successfully")
                .build();
    }

    @GetMapping("/checkHoldSeat")
    APIResponse<Boolean> checkHoldSeat(@RequestParam("scheduleId") long id, @RequestParam("seat") String  seat){
        return APIResponse.<Boolean>builder()
                .result(seatHeldService.checkAccountHoldSeat(id,seat))
                .build();
    }
}
