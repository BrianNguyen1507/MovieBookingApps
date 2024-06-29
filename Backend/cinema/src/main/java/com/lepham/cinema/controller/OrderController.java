package com.lepham.cinema.controller;

import com.lepham.cinema.dto.request.OrderFilmRequest;
import com.lepham.cinema.dto.request.SumTotalRequest;
import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.dto.response.OrderResponse;
import com.lepham.cinema.dto.response.SumTotalResponse;
import com.lepham.cinema.dto.response.VoucherResponse;
import com.lepham.cinema.service.imp.OrderService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("cinema")
@Slf4j
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class OrderController {
    OrderService orderService;

    @PostMapping("/sumTotalOrder")
    APIResponse<SumTotalResponse> sumTotalOrder(@RequestBody SumTotalRequest request){
        return APIResponse.<SumTotalResponse>builder()
                .result(orderService.sumTotalOrder(request))
                .build();
    }



    @GetMapping("/applyVoucher")
    APIResponse<Double> applyVoucher(@RequestParam("voucherId") long voucherId,
                                     @RequestParam("price") double price){
        return APIResponse.<Double>builder()
                .result(orderService.applyVoucher(price,voucherId))
                .build();
    }
    @PostMapping("/createOrder")
    APIResponse<OrderResponse> orderFilm(@RequestBody OrderFilmRequest request){
        return APIResponse.<OrderResponse>builder()
                .result(orderService.orderFilm(request))
                .build();
    }
    @PostMapping("/holdSeat")
    APIResponse<?> holdSeat(@RequestParam("scheduleId") long id, @RequestParam("seat") String  seat){
        orderService.holeSeat(id,seat);
        return APIResponse.builder()
                .message("Hold the seat successfully")
                .build();
    }
    @PostMapping("/returnSeat")
    APIResponse<?> returnSeat(@RequestParam("scheduleId") long id, @RequestParam("seat") String  seat){
        orderService.returnSeat(id,seat);
        return APIResponse.builder()
                .message("RefundSeat the seat successfully")
                .build();
    }
    @PostMapping("/orderFood")
    APIResponse<OrderResponse> orderFood(@RequestBody OrderFilmRequest request){
        return APIResponse.<OrderResponse>builder()
                .result(orderService.orderFood(request))
                .build();
    }

}
