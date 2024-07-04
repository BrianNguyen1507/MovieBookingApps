package com.lepham.cinema.service.imp;

import com.google.zxing.WriterException;
import com.lepham.cinema.constant.ConstantVariable;
import com.lepham.cinema.converter.FilmConverter;
import com.lepham.cinema.converter.FoodConverter;
import com.lepham.cinema.converter.OrderConverter;
import com.lepham.cinema.converter.VoucherConverter;
import com.lepham.cinema.dto.request.FoodOrderRequest;
import com.lepham.cinema.dto.request.OrderFilmRequest;
import com.lepham.cinema.dto.request.SumTotalRequest;
import com.lepham.cinema.dto.response.*;
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
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class OrderService implements IOrderService {

    OrderRepository orderRepository;
    FilmRepository filmRepository;
    FilmConverter filmConverter;
    MovieScheduleRepository movieScheduleRepository;
    FoodRepository foodRepository;
    VoucherRepository voucherRepository;
    VoucherConverter voucherConverter;
    AccountVoucherRepository accountVoucherRepository;
    AccountRepository accountRepository;
    OrderConverter orderConverter;
    FoodOrderRepository foodOrderRepository;
    QRCodeService qrCodeService;
    FoodConverter foodConverter;

    @Override
    @PreAuthorize("hasRole('USER')")
    public SumTotalResponse sumTotalOrder(SumTotalRequest request) {
        double total = 0;
        double priceTicket = 0;
        if (request.getIdFilm() != -1) {
            FilmEntity filmEntity = filmRepository.findById(request.getIdFilm())
                    .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));
            priceTicket = (filmEntity.getBasePrice() * request.getQuantitySeat());
        }


        total += priceTicket;
        double priceFoodTotal = 0;
        if (!request.getFood().isEmpty()) {
            for (FoodOrderRequest foodRequest : request.getFood()) {
                FoodEntity foodEntity = foodRepository.findById(foodRequest.getId())
                        .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));
                double priceFood = (foodEntity.getPrice() * foodRequest.getQuantity());
                priceFoodTotal += priceFood;
                total += priceFood;
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
    public double applyVoucher(double price, long voucherId) {
        VoucherEntity voucher = voucherRepository.findById(voucherId)
                .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));
        if (voucher.getTypeDiscount() == ConstantVariable.direct) {
            return price - voucher.getDiscount();
        } else if (voucher.getTypeDiscount() == ConstantVariable.percent) {
            return price - (price * (voucher.getDiscount() / 100));
        }
        return price;
    }

    @Override
    @PreAuthorize("hasRole('USER')")
    public OrderResponse order(OrderFilmRequest request) {
        OrderEntity order = orderConverter.toEntity(request);
        order.setSeat(null);
        if (request.getMovieScheduleId()!=-1){
            MovieScheduleEntity movieSchedule = movieScheduleRepository.findById(request.getMovieScheduleId()).orElseThrow();
            order.setMovieSchedule(movieSchedule);
            if (LocalDateTime.now().plusMinutes(30).isAfter(movieSchedule.getTimeStart()))
                throw new AppException(ErrorCode.SHOWTIME_IS_COMING_SOON);
            if (!movieSchedule.orderSeat(request.getSeat())) throw new AppException(ErrorCode.SEAT_WAS_ORDERED);
            order.setSeat(request.getSeat());
            movieScheduleRepository.save(movieSchedule);
        }

        var context = SecurityContextHolder.getContext();
        String email = context.getAuthentication().getName();
        AccountEntity account = accountRepository.findByEmail(email)
                .orElseThrow(() -> new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
        AccountVoucher accountVoucher = new AccountVoucher();
        if (request.getVoucherId() != -1) {
            VoucherEntity voucher = voucherRepository.findById(request.getVoucherId())
                    .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));
            accountVoucher = accountVoucherRepository.findByAccountAndVoucher(account, voucher);
            accountVoucher.setQuantity(accountVoucher.getQuantity() - 1);
            if (accountVoucher.getQuantity() <= 0) throw new AppException(ErrorCode.VOUCHER_NOY_ENOUGH);

        } else {
            if (accountVoucherRepository.findByAccountAndVoucher(account, null) != null) {
                accountVoucher = accountVoucherRepository.findByAccountAndVoucher(account, null);
            } else {
                accountVoucher.setVoucher(null);
                accountVoucher.setAccount(account);
                accountVoucherRepository.save(accountVoucher);
            }
        }
        order.setAccountVoucher(accountVoucher);


        order = orderRepository.save(order);
        if (!request.getFood().isEmpty()) {
            for (FoodOrderRequest foodOrderRequest : request.getFood()) {
                FoodEntity food = foodRepository.findById(foodOrderRequest.getId())
                        .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));
                FoodOrderEntity foodOrder = new FoodOrderEntity();
                foodOrder.setOrder(order);
                foodOrder.setFood(food);
                foodOrder.setQuantity(foodOrderRequest.getQuantity());
                foodOrderRepository.save(foodOrder);
            }
        }
        return getOrderResponse(order);
    }

    private OrderResponse getOrderResponse(OrderEntity order) {
        OrderResponse response = orderConverter.toOrderFilmResponse(order);
        try {
            byte[] image = qrCodeService.generateQRCode(order.getOrderCode());
            String qrcode = Base64.getEncoder().encodeToString(image);
            response.setOrderCode(qrcode);
        } catch (WriterException | IOException e) {
            throw new RuntimeException(e);
        }
        return response;
    }

    @Override
    @PreAuthorize("hasRole('USER')")
    public void holeSeat(long id, String seat) {
        MovieScheduleEntity schedule = movieScheduleRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));
        if (!schedule.holdSeat(seat)) throw new AppException(ErrorCode.SEAT_WAS_ORDERED);
        movieScheduleRepository.save(schedule);
    }

    @Override
    @PreAuthorize("hasRole('USER')")
    public void returnSeat(long id, String seat) {
        MovieScheduleEntity schedule = movieScheduleRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));
        if (!schedule.refundSeat(seat)) throw new AppException(ErrorCode.SEAT_NOT_ORDERED);
        movieScheduleRepository.save(schedule);
    }


    @Override
    @PreAuthorize("hasRole('USER')")
    public List<OrderResponse> listFilmOrder() {
        var context = SecurityContextHolder.getContext();
        String email = context.getAuthentication().getName();
        AccountEntity account = accountRepository.findByEmail(email)
                .orElseThrow(() -> new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
        List<OrderEntity> orderEntities = orderRepository.findByAccountVoucher_AccountAndMovieScheduleNotNull(account);
        List<OrderResponse> orderResponses = new ArrayList<>();
        orderEntities.forEach(entity -> {
            FilmEntity film = entity.getMovieSchedule().getFilm();
            if (entity.getMovieSchedule().getTimeStart().plusMinutes(film.getDuration()).isBefore(LocalDateTime.now())
                    && entity.getStatus() == ConstantVariable.ORDER_UNUSED) {
                entity.setStatus(ConstantVariable.ORDER_EXPIRED_USED);
                entity = orderRepository.save(entity);
            }
            OrderResponse response = orderConverter.toOrderFilmResponse(entity);
            response.setStatus(getStatus(entity.getStatus()));
            response.setFilm(filmConverter.toFilmResponse(film));
            orderResponses.add(response);

        });
        return orderResponses;
    }

    @Override
    @PreAuthorize("hasRole('USER')")
    public List<OrderResponse> listFoodOrder() {
        var context = SecurityContextHolder.getContext();
        String email = context.getAuthentication().getName();
        AccountEntity account = accountRepository.findByEmail(email)
                .orElseThrow(() -> new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
        List<OrderEntity> orderEntities = orderRepository.findByAccountVoucher_AccountAndMovieScheduleNull(account);
        List<OrderResponse> orderResponses = new ArrayList<>();
        orderEntities.forEach(entity -> {
            if (LocalDate.now().isAfter(entity.getDate().toLocalDate())
                    && entity.getStatus() == ConstantVariable.ORDER_UNUSED) {
                entity.setStatus(ConstantVariable.ORDER_EXPIRED_USED);
                entity = orderRepository.save(entity);
            }
            OrderResponse response = orderConverter.toOrderFilmResponse(entity);

            response.setStatus(getStatus(entity.getStatus()));
            orderResponses.add(response);

        });
        return orderResponses;
    }

    @Override
    @PreAuthorize("hasRole('USER')")
    public DetailOrderResponse detailOrder(long id) {
        var context = SecurityContextHolder.getContext();
        String email = context.getAuthentication().getName();
        AccountEntity account = accountRepository.findByEmail(email)
                .orElseThrow(() -> new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
        OrderEntity order = orderRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.ORDER_NOT_FOUND));
        if (!Objects.equals(account, order.getAccountVoucher().getAccount()))
            throw new AppException(ErrorCode.ORDER_NOT_BELONG_ACCOUNT);
        DetailOrderResponse detailOrderResponse = orderConverter.toDetailOrderResponse(order);
        try {
            byte[] image = qrCodeService.generateQRCode(order.getOrderCode());
            String qrcode = Base64.getEncoder().encodeToString(image);
            detailOrderResponse.setOrderCode(qrcode);
        } catch (WriterException | IOException e) {
            throw new RuntimeException(e);
        }
        if (order.getAccountVoucher().getVoucher() != null) {
            VoucherResponse voucherResponse = voucherConverter.toResponse(order.getAccountVoucher().getVoucher());
            detailOrderResponse.setVoucher(voucherResponse);
        }
        if (order.getFoodOrders() != null) {
            List<FoodResponse> food = new ArrayList<>();
            order.getFoodOrders().forEach(foodOrderEntity -> {
                FoodResponse foodResponse = foodConverter.toFoodResponse(foodOrderEntity.getFood());
                foodResponse.setQuantity(foodOrderEntity.getQuantity());
                food.add(foodResponse);
            });
            detailOrderResponse.setFood(food);
        }
        detailOrderResponse.setStatus(getStatus(order.getStatus()));
        detailOrderResponse.setAllowedComment(false);
        if (order.getMovieSchedule() != null) {

            MovieScheduleEntity movieSchedule = order.getMovieSchedule();
            FilmEntity film = movieSchedule.getFilm();
            RoomEntity room = movieSchedule.getRoom();
            MovieTheaterEntity theater = room.getMovieTheater();
            detailOrderResponse.setTheaterName(theater.getName());
            detailOrderResponse.setFilm(filmConverter.toFilmResponse(film));
            detailOrderResponse.setRoomNumber(room.getNumber());
            detailOrderResponse.setMovieTimeStart(movieSchedule.getTimeStart());
            detailOrderResponse.setMovieTimeEnd(movieSchedule.getTimeStart().plusMinutes(film.getDuration()));
            LocalDateTime movieTimeEnd = detailOrderResponse.getMovieTimeStart()
                    .plusMinutes(detailOrderResponse.getFilm().getDuration());
            if (order.getStatus() == ConstantVariable.ORDER_USED) {
                detailOrderResponse.setAllowedComment(movieTimeEnd.isBefore(LocalDateTime.now()));
            }

        }

        return detailOrderResponse;
    }

    String getStatus(int statusInt) {
        String status = "";
        if (statusInt == 0) status = "Unused";
        else status = statusInt == 1 ? "Used" : "Expired";
        return status;
    }
}
