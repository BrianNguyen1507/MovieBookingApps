package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.OrderFilmRequest;
import com.lepham.cinema.dto.request.SumTotalRequest;
import com.lepham.cinema.dto.response.OrderResponse;
import com.lepham.cinema.dto.response.SumTotalResponse;
import com.lepham.cinema.dto.response.VoucherResponse;

import java.util.List;

public interface IOrderService {
    SumTotalResponse sumTotalOrder(SumTotalRequest request);
    List<VoucherResponse> getAllVoucherByAccount(double price, long accountId);
    double applyVoucher(double price, long voucherId);

    OrderResponse createOrder(OrderFilmRequest request);

    void holeSeat(long id,String seat);
    void returnSeat(long id,String seat);
}