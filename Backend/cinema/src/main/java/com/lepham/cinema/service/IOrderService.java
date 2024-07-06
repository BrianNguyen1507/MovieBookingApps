package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.OrderFilmRequest;
import com.lepham.cinema.dto.request.SumTotalRequest;
import com.lepham.cinema.dto.response.DetailOrderResponse;
import com.lepham.cinema.dto.response.OrderResponse;
import com.lepham.cinema.dto.response.SumTotalResponse;
import com.lepham.cinema.dto.response.VoucherResponse;

import java.util.List;

public interface IOrderService {
    SumTotalResponse sumTotalOrder(SumTotalRequest request);

    double applyVoucher(double price, long voucherId);

    OrderResponse order(OrderFilmRequest request);



    List<OrderResponse> listFilmOrder();
    List<OrderResponse> listFoodOrder();

    DetailOrderResponse detailOrder(long id);
}
