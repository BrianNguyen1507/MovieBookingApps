package com.lepham.cinema.controller;

import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.dto.response.RevenueDayResponse;
import com.lepham.cinema.dto.response.RevenueResponse;
import com.lepham.cinema.service.imp.RevenueService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@Slf4j
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
@RequestMapping("/cinema")
public class RevenueController {
    RevenueService revenueService;

    @GetMapping(value = "/getRevenueByMonth")
    APIResponse<RevenueResponse> getRevenueByMonth(@RequestParam("year") int year){
        return APIResponse.<RevenueResponse>builder()
                .result(revenueService.getRevenueTotalByMonth(year))
                .build();
    }
    @GetMapping(value = "/getFoodSaleTotalByMonth")
    APIResponse<RevenueResponse> getFoodSaleTotalByMonth(@RequestParam("year") int year){
        return APIResponse.<RevenueResponse>builder()
                .result(revenueService.getFoodSaleTotalByMonth(year))
                .build();
    }
    @GetMapping(value = "/getRevenueByDay")
    APIResponse<RevenueDayResponse> getRevenueByDay(){
        return APIResponse.<RevenueDayResponse> builder()
                .result(revenueService.getRevenueByDay())
                .build();
    }
}
