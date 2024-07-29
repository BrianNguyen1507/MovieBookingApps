package com.lepham.cinema.service.imp;

import com.lepham.cinema.constant.ConstantVariable;
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
    public List<RevenueResponse> getRevenueTotalByYear() {
        List<RevenueResponse> responseList = new ArrayList<>();
        RevenueResponse responseTotal = new RevenueResponse();
        RevenueResponse responseVn = new RevenueResponse();
        RevenueResponse responseZl = new RevenueResponse();
        int currentYear = LocalDate.now().getYear();

        Map<String, Double> revenue = new HashMap<>();
        Map<String, Double> revenueVn = new HashMap<>();
        Map<String, Double> revenueZl = new HashMap<>();
        for (int year = currentYear - ConstantVariable.step; year <= currentYear; year++) {
            responseTotal.setType("Total");
            responseVn.setType("VNPAY");
            responseZl.setType("ZALOPAY");
            List<String> paymentMethods = orderRepository.getALLPaymentMethod();
            for (String paymentMethod : paymentMethods) {
                Optional<Double> sumOptional = orderRepository.sumAllByDateAndPaymentMethod(year, paymentMethod);
                double sum = 0;
                if(sumOptional.isPresent()) sum = sumOptional.get();;

                if (paymentMethod.equals(responseVn.getType())) {
                    revenueVn.put(year + "", sum);
                } else {
                    revenueZl.put(year + "", sum);
                }

            }
            revenue.put(year+"",revenueVn.get(year+"")+revenueZl.get(year+""));
        }
        responseTotal.setRevenue(revenue);
        responseVn.setRevenue(revenueVn);
        responseZl.setRevenue(revenueZl);
        responseList.add(responseTotal);
        responseList.add(responseVn);
        responseList.add(responseZl);
        return responseList;
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
