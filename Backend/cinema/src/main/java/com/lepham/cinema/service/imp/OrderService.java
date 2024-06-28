package com.lepham.cinema.service.imp;

import com.lepham.cinema.constant.ConstantVariable;
import com.lepham.cinema.converter.VoucherConverter;
import com.lepham.cinema.dto.request.FoodOrderRequest;
import com.lepham.cinema.dto.request.FoodRequest;
import com.lepham.cinema.dto.request.SumTotalRequest;
import com.lepham.cinema.dto.response.SumTotalResponse;
import com.lepham.cinema.dto.response.VoucherResponse;
import com.lepham.cinema.entity.FilmEntity;
import com.lepham.cinema.entity.FoodEntity;
import com.lepham.cinema.entity.FoodOrderEntity;
import com.lepham.cinema.entity.VoucherEntity;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.*;
import com.lepham.cinema.service.IOrderService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class OrderService implements IOrderService {

    OrderRepository orderRepository;
    FilmRepository filmRepository;
    MovieScheduleRepository movieScheduleRepository;
    FoodRepository foodRepository;
    VoucherRepository voucherRepository;
    VoucherConverter voucherConverter;
    @Override
    @PreAuthorize("hasRole('USER')")
    public SumTotalResponse sumTotalOrder(SumTotalRequest request) {
        double total = 0;
        FilmEntity filmEntity = filmRepository.findById(request.getIdFilm())
                .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));
        double priceTicket=(filmEntity.getBasePrice()*request.getQuantitySeat());
        total+=priceTicket;
        double priceFoodTotal=0;
        if(!request.getFood().isEmpty()){
            for(FoodOrderRequest foodRequest : request.getFood()){
                FoodEntity foodEntity = foodRepository.findById(foodRequest.getId())
                        .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));
                double priceFood = (foodEntity.getPrice()*foodRequest.getQuantity());
                priceFoodTotal+=priceFood;
                total+=priceFood;
            }
        }
        return SumTotalResponse.builder()
                .total(total)
                .priceTicket(priceTicket)
                .priceFood(priceFoodTotal)
                .build();
    }

    @Override
    @PreAuthorize("hasRole('USER')")
    public List<VoucherResponse> getAllVoucherByAccount(double price,long accountId) {
        List<VoucherResponse> responses = new ArrayList<>();
        List<VoucherEntity> vouchers = voucherRepository.findAllByAllowVoucher(price,accountId);
        if(!vouchers.isEmpty()){
            vouchers.forEach(entity -> {
                VoucherResponse response = voucherConverter.toResponse(entity);
                response.setAllow(true);
                responses.add(response);
            });
        }
        vouchers = voucherRepository.findAllByNotAllowVoucher(price,accountId);
        if(!vouchers.isEmpty()){
            vouchers.forEach(entity -> {
                VoucherResponse response = voucherConverter.toResponse(entity);
                response.setAllow(false);
                responses.add(response);
            });
        }

        return responses;
    }

    @Override
    @PreAuthorize("hasRole('USER')")
    public double applyVoucher(double price,long voucherId) {
        VoucherEntity voucher = voucherRepository.findById(voucherId)
                .orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));
        if(voucher.getTypeDiscount()== ConstantVariable.direct){
            return price-voucher.getDiscount();
        }
        return price-(price*(voucher.getDiscount()/100));
    }
}
