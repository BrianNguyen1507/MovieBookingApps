package com.lepham.cinema.controller;

import com.lepham.cinema.dto.request.OrderFilmRequest;
import com.lepham.cinema.dto.request.SumTotalRequest;
import com.lepham.cinema.dto.response.*;
import com.lepham.cinema.service.imp.OrderService;
import com.lepham.cinema.validator.PriceConstraint;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
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
    @PostMapping("/order")
    APIResponse<OrderResponse> order(@RequestBody @Valid OrderFilmRequest request) throws NoSuchAlgorithmException, InvalidKeyException {
        return APIResponse.<OrderResponse>builder()
                .result(orderService.order(request))
                .build();
    }

    @GetMapping("/getAllFilmOrder")
    APIResponse<List<OrderResponse>> getAllFilmOrder(){
        return APIResponse.<List<OrderResponse>>builder()
                .result(orderService.listFilmOrder())
                .build();
    }
    @GetMapping("/getAllFoodOrder")
    APIResponse<List<OrderResponse>> getAllFoodOrder(){
        return APIResponse.<List<OrderResponse>>builder()
                .result(orderService.listFoodOrder())
                .build();
    }

    @GetMapping("/detailOrder")
    APIResponse<DetailOrderResponse> detailOrder(@RequestParam("id") long id){
        return APIResponse.<DetailOrderResponse>builder()
                .result(orderService.detailOrder(id))
                .build();
    }
    @GetMapping("/detailOrderByOrderCode")
    APIResponse<OrderCheckResponse> detailOrderByOrderCode(@RequestParam("orderCode") String orderCode){
        return APIResponse.<OrderCheckResponse>builder()
                .result(orderService.detailOrderByOrderCode(orderCode))
                .build();
    }
    @PostMapping("/usedOrder")
    APIResponse<?> changeOrderStatus(@RequestParam("id") long id){
        orderService.changeOrderStatus(id);
        return APIResponse.builder()
                .message("Use successful!")
                .build();
    }

}
