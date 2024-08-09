package com.lepham.cinema.service;

import com.lepham.cinema.dto.response.RevenueDayResponse;
import com.lepham.cinema.dto.response.RevenueResponse;
import com.lepham.cinema.service.imp.RevenueService;

import java.util.List;
import java.util.Map;

public interface IRevenueService {
    RevenueDayResponse getRevenueByDay();
    RevenueResponse getRevenueTotalByMonth(int year);
    RevenueResponse getFoodSaleTotalByMonth(int year);
}
