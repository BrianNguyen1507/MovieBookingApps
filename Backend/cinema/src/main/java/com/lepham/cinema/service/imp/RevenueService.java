package com.lepham.cinema.service.imp;

import com.lepham.cinema.constant.ConstantVariable;
import com.lepham.cinema.dto.response.RevenueDayResponse;
import com.lepham.cinema.dto.response.RevenueResponse;
import com.lepham.cinema.entity.OrderEntity;
import com.lepham.cinema.repository.OrderRepository;
import com.lepham.cinema.service.IRevenueService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;
import java.util.concurrent.atomic.DoubleAdder;

@Service
@Slf4j
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class RevenueService implements IRevenueService {

    OrderRepository orderRepository;

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public RevenueDayResponse getRevenueByDay() {

        List<Integer> day = new ArrayList<>();
        List<Double> total = new ArrayList<>();
        List<Double> food = new ArrayList<>();
        List<Double> film = new ArrayList<>();
        LocalDate now = LocalDate.now();
        int dayOfMonth = now.lengthOfMonth();
        for(int i=1;i<=dayOfMonth;i++){
            day.add(i);
            now = now.withDayOfMonth(i);
            List<OrderEntity> orders = orderRepository.findAllOrderByDay(now);
            RevenueDayResponse revenueResponse;
            if(orders==null){
                total.add(0.0);
                food.add(0.0);
                film.add(0.0);
                continue;
            }
            double foodRevenue =0;
            double filmRevenue = 0;
            DoubleAdder doubleAdder = new DoubleAdder();
            for(OrderEntity order : orders){
                order.getFoodOrders().forEach(
                        foodOrderEntity -> {
                            doubleAdder.add(foodOrderEntity.getQuantity()*foodOrderEntity.getFood().getPrice());
                        }
                );
            }
            foodRevenue = doubleAdder.sum();
            double totalRevenue = orderRepository.sumRevenueTotalByDay(now)==null?0:orderRepository.sumRevenueTotalByDay(now);
            filmRevenue = totalRevenue-foodRevenue;
            total.add(totalRevenue);
            food.add(foodRevenue);
            film.add(filmRevenue);
        }
        return RevenueDayResponse
                .builder()
                .day(day)
                .film(film)
                .total(total)
                .food(food)
                .build();
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public RevenueResponse getRevenueTotalByMonth(int year) {
        Map<String, Double> revenue = new HashMap<>();
        for (int i = 1; i <= 12; i++) {
            List<OrderEntity> orders = orderRepository.findByMonthAndYear(i, year);
            if (orders == null) {
                revenue.put(i + "", 0.0);
                continue;
            }
            DoubleAdder doubleAdder = new DoubleAdder();
            orders.forEach(order -> {
                doubleAdder.add(order.getSumTotal());
            });
            revenue.put(i + "", doubleAdder.sum());
        }
        return RevenueResponse.builder()
                .year(year)
                .revenue(revenue)
                .build();
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public RevenueResponse getFoodSaleTotalByMonth(int year) {
        Map<String, Double> revenue = new HashMap<>();
        for (int i = 1; i <= 12; i++) {
            List<OrderEntity> orders = orderRepository.findByMonthAndYear(i, year);
            if (orders == null) {
                revenue.put(i + "", 0.0);
                continue;
            }
            DoubleAdder doubleAdder = new DoubleAdder();
            orders.forEach(order -> {
                order.getFoodOrders().forEach(foodOrderEntity -> {
                    doubleAdder.add(foodOrderEntity.getQuantity() * foodOrderEntity.getFood().getPrice());
                });
            });
            revenue.put(i + "", doubleAdder.sum());
        }
        return RevenueResponse.builder()
                .year(year)
                .revenue(revenue)
                .build();
    }
}
