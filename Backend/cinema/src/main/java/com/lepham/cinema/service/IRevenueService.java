package com.lepham.cinema.service;

import com.lepham.cinema.dto.response.RevenueResponse;
import com.lepham.cinema.service.imp.RevenueService;

import java.util.List;

public interface IRevenueService {
    List<RevenueResponse> getRevenueTotalByYear();
    RevenueResponse getRevenueTotalByMonth(int year);
    RevenueResponse getFoodSaleTotalByMonth(int year);
}
