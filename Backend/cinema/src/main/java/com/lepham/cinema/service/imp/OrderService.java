package com.lepham.cinema.service.imp;

import com.lepham.cinema.constant.ConstantVariable;
import com.lepham.cinema.converter.OrderConverter;
import com.lepham.cinema.converter.VoucherConverter;
import com.lepham.cinema.dto.request.FoodOrderRequest;
import com.lepham.cinema.dto.request.FoodRequest;
import com.lepham.cinema.dto.request.OrderFilmRequest;
import com.lepham.cinema.dto.request.SumTotalRequest;
import com.lepham.cinema.dto.response.OrderResponse;
import com.lepham.cinema.dto.response.SumTotalResponse;
import com.lepham.cinema.dto.response.VoucherResponse;
import com.lepham.cinema.entity.*;
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
    AccountVoucherRepository accountVoucherRepository;
    AccountRepository accountRepository;
    OrderConverter orderConverter;
    FoodOrderRepository foodOrderRepository;
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
        else if(voucher.getTypeDiscount()== ConstantVariable.percent)
        {
            return price-(price*(voucher.getDiscount()/100));
        }
        return price;
    }

    @Override
    @PreAuthorize("hasRole('USER')")
    public OrderResponse createOrder(OrderFilmRequest request) {
        OrderEntity order = orderConverter.toEntity(request);
        MovieScheduleEntity movieSchedule = movieScheduleRepository.findById(request.getMovieScheduleId())
                .orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));
        AccountEntity account =  accountRepository.findById(request.getAccountId())
                .orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));
        AccountVoucher accountVoucher = new AccountVoucher();
        if(request.getVoucherId()!=-1){
            VoucherEntity voucher = voucherRepository.findById(request.getVoucherId())
                    .orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));
            accountVoucher = accountVoucherRepository.findByAccountAndVoucher(account,voucher);
            accountVoucher.setQuantity(accountVoucher.getQuantity()-1);
            if(accountVoucher.getQuantity()<=0) throw new AppException(ErrorCode.VOUCHER_NOY_ENOUGH);

        }
        else{
            VoucherEntity voucher = voucherRepository.findByTypeDiscount(3);
            if(accountVoucherRepository.findByAccountAndVoucher(account,voucher)==null){
                accountVoucher.setAccount(account);
                accountVoucher.setVoucher(voucher);
                accountVoucher = accountVoucherRepository.save(accountVoucher);
            }
            else{
                accountVoucher =accountVoucherRepository.findByAccountAndVoucher(account,voucher);
            }
        }
        order.setAccountVoucher(accountVoucher);
        order.setMovieSchedule(movieSchedule);
        if(!movieSchedule.orderSeat(request.getSeat()))throw new AppException(ErrorCode.SEAT_WAS_ORDERED);
        movieScheduleRepository.save(movieSchedule);
        order = orderRepository.save(order);
        if(!request.getFood().isEmpty()){
            for (FoodOrderRequest foodOrderRequest : request.getFood()){
                FoodEntity food = foodRepository.findById(foodOrderRequest.getId())
                        .orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));
                FoodOrderEntity foodOrder = new FoodOrderEntity();
                foodOrder.setOrder(order);
                foodOrder.setFood(food);
                foodOrder.setQuantity(foodOrderRequest.getQuantity());
                foodOrderRepository.save(foodOrder);
            }
        }
        return orderConverter.toOrderFilmResponse(order);
    }

    @Override
    @PreAuthorize("hasRole('USER')")
    public void holeSeat(long id,String seat) {
        MovieScheduleEntity schedule = movieScheduleRepository.findById(id)
                .orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));
        if(!schedule.holdSeat(seat)) throw  new AppException(ErrorCode.SEAT_WAS_ORDERED);
        movieScheduleRepository.save(schedule);
    }

    @Override
    @PreAuthorize("hasRole('USER')")
    public void returnSeat(long id, String seat) {
        MovieScheduleEntity schedule = movieScheduleRepository.findById(id)
                .orElseThrow(()->new AppException(ErrorCode.NULL_EXCEPTION));
        if(!schedule.refundSeat(seat)) throw  new AppException(ErrorCode.SEAT_NOT_ORDERED);
        movieScheduleRepository.save(schedule);
    }


}
