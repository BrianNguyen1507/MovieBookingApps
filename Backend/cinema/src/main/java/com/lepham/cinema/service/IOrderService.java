package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.OrderFilmRequest;
import com.lepham.cinema.dto.request.SumTotalRequest;
import com.lepham.cinema.dto.response.*;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

public interface IOrderService {
    SumTotalResponse sumTotalOrder(SumTotalRequest request);

    double applyVoucher(double price, long voucherId);

    OrderResponse order(OrderFilmRequest request) throws NoSuchAlgorithmException, InvalidKeyException;

    List<OrderResponse> listFilmOrder();
    List<OrderResponse> listFoodOrder();

    DetailOrderResponse detailOrder(long id);

    OrderCheckResponse detailOrderByOrderCode(String orderCode);
    void changeOrderStatus(long id);

    void autoChangeStatusFoodOrder();
    void autoChangeStatusFilmOrder();
}
