package com.lepham.cinema.service.imp;

import com.google.zxing.WriterException;
import com.lepham.cinema.constant.ConstantVariable;
import com.lepham.cinema.converter.*;
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
import lombok.experimental.NonFinal;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Sort;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Objects;

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
    MovieScheduleConverter movieScheduleConverter;
    RatingFeedBackRepository ratingFeedBackRepository;

    @Value("${app.payment_key}")
    @NonFinal
    String paymentKey;

    @Override
    @PreAuthorize("hasRole('USER')")
    public SumTotalResponse sumTotalOrder(SumTotalRequest request) {
        double total = 0;
        double priceTicket = 0;
        if (request.getIdFilm() != -1 && request.getQuantitySeat()>0) {
            FilmEntity filmEntity = filmRepository.findById(request.getIdFilm())
                    .orElseThrow(() -> new AppException(ErrorCode.FILM_NOT_FOUND));

            priceTicket = (filmEntity.getBasePrice() * request.getQuantitySeat());
        }
        total += priceTicket;
        double priceFoodTotal = 0;
        if (!request.getFood().isEmpty()) {
            for (FoodOrderRequest foodRequest : request.getFood()) {
                FoodEntity foodEntity = foodRepository.findById(foodRequest.getId())
                        .orElseThrow(() -> new AppException(ErrorCode.FOOD_NOT_FOUND));
                if (foodRequest.getQuantity()<0) throw new AppException(ErrorCode.INVALID_FOOD_QUANTITY);
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
                .orElseThrow(() -> new AppException(ErrorCode.VOUCHER_NOT_FOUND));
        if(price<=0)return 0;
        if (voucher.getTypeDiscount() == ConstantVariable.direct) {
            price = price - voucher.getDiscount();
        } else if (voucher.getTypeDiscount() == ConstantVariable.percent) {
            price = price - (price * (voucher.getDiscount() / 100));
        }
        return price<0?0:price;
    }

    @Override
    @PreAuthorize("hasRole('USER')")
    @Transactional
    public OrderResponse order(OrderFilmRequest request) throws NoSuchAlgorithmException, InvalidKeyException {
        if(!Objects.equals(encodePaymentCode(paymentKey,request.getPaymentCode()),request.getPaymentHash())) throw new AppException(ErrorCode.INCORRECT_PAYMENT_HASH);
        if(request.getSumTotal()<0) throw new AppException(ErrorCode.NUMBER_NOT_NEGATIVE);

        OrderEntity order = orderConverter.toEntity(request);
        order.setSeat(null);
        if (request.getMovieScheduleId() != -1) {
            MovieScheduleEntity movieSchedule = movieScheduleRepository.findById(request.getMovieScheduleId()).orElseThrow();
            if (movieSchedule.getFilm().getActive() == ConstantVariable.FILM_STOP_RELEASE)
                throw new AppException(ErrorCode.FILM_NOT_FOUND);
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
        AccountVoucherEntity accountVoucher = new AccountVoucherEntity();
        if (request.getVoucherId() != -1) {
            VoucherEntity voucher = voucherRepository.findById(request.getVoucherId())
                    .orElseThrow(() -> new AppException(ErrorCode.VOUCHER_NOT_FOUND));
            accountVoucher = accountVoucherRepository.findByAccountAndVoucher(account, voucher);

            if (accountVoucher.getQuantity() <= 0) throw new AppException(ErrorCode.VOUCHER_NOT_ENOUGH);
            accountVoucher.setQuantity(accountVoucher.getQuantity() - 1);

        } else {
            if (accountVoucherRepository.findByAccountAndVoucher(account, null) != null) {
                accountVoucher = accountVoucherRepository.findByAccountAndVoucher(account, null);
            } else {
                accountVoucher.setVoucher(null);
                accountVoucher.setAccount(account);
                accountVoucher = accountVoucherRepository.save(accountVoucher);
            }
        }
        order.setAccountVoucher(accountVoucher);


        order = orderRepository.save(order);
        if (!request.getFood().isEmpty()) {
            for (FoodOrderRequest foodOrderRequest : request.getFood()) {
                FoodEntity food = foodRepository.findById(foodOrderRequest.getId())
                        .orElseThrow(() -> new AppException(ErrorCode.FOOD_NOT_FOUND));
                if (foodOrderRequest.getQuantity()<0) throw new AppException(ErrorCode.INVALID_FOOD_QUANTITY);
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
    public List<OrderResponse> listFilmOrder() {
        var context = SecurityContextHolder.getContext();
        String email = context.getAuthentication().getName();
        AccountEntity account = accountRepository.findByEmail(email)
                .orElseThrow(() -> new AppException(ErrorCode.ACCOUNT_NOT_EXIST));
        List<OrderEntity> orderEntities = orderRepository.findByAccountVoucher_AccountAndMovieScheduleNotNull(account, Sort.by(Sort.Direction.DESC, "date"));
        List<OrderResponse> orderResponses = new ArrayList<>();
        orderEntities.forEach(entity -> {
            FilmEntity film = entity.getMovieSchedule().getFilm();
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
        List<OrderEntity> orderEntities = orderRepository.findByAccountVoucher_AccountAndMovieScheduleNull(account, Sort.by(Sort.Direction.DESC, "date"));
        List<OrderResponse> orderResponses = new ArrayList<>();
        orderEntities.forEach(entity -> {

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
            if (order.getStatus() == ConstantVariable.ORDER_USED
                    && !ratingFeedBackRepository.existsByOrder(order)) {
                detailOrderResponse.setAllowedComment(movieTimeEnd.isBefore(LocalDateTime.now()));
            }

        }
        return detailOrderResponse;
    }

    @Override
    public OrderCheckResponse detailOrderByOrderCode(String orderCode) {
        OrderEntity order = orderRepository.findByOrderCode(orderCode)
                .orElseThrow(() -> new AppException(ErrorCode.ORDER_NOT_FOUND));
        if (order.getStatus() != ConstantVariable.ORDER_UNUSED)
            throw new AppException(ErrorCode.ORDER_CAN_NOT_USED);
        MovieScheduleEntity movieSchedule = order.getMovieSchedule();


        LocalDateTime now = LocalDateTime.now();
        OrderCheckResponse response = orderConverter.toOrderCheckResponse(order);
        response.setSumTotal(order.getSumTotal());
        if (movieSchedule != null) {
            MovieTheaterEntity movieTheater = movieSchedule.getRoom().getMovieTheater();

            LocalDateTime timeStart = movieSchedule.getTimeStart().minusMinutes(15);
            LocalDateTime timeEnd = movieSchedule.getTimeStart().plusMinutes(movieSchedule.getFilm().getDuration());

            //Check 15 minutes before start until finish
            response.setAllowUse(now.isAfter(timeStart) && now.isBefore(timeEnd));
            MovieScheduleResponse movieScheduleResponse = movieScheduleConverter
                    .toResponse(movieSchedule, filmConverter.toFilmScheduleResponse(movieSchedule.getFilm()));
            response.setMovieSchedule(movieScheduleResponse);
            response.setAddress(movieTheater.getAddress());
            response.setTheaterName(movieTheater.getName());

            response.setRoomNumber(movieSchedule.getRoom().getNumber());
        } else {
            //Check date order is today
            response.setAllowUse(order.getDate().toLocalDate().equals(LocalDate.now()));
            if (!order.getFoodOrders().isEmpty()) {
                response.setFoods(order.getFoodOrders()
                        .stream()
                        .map(foodOrderEntity -> {
                            FoodResponse foodResponse =foodConverter.toFoodResponse(foodOrderEntity.getFood());
                            foodResponse.setQuantity(foodOrderEntity.getQuantity());
                            return  foodResponse;
                        })
                        .toList());
            }
        }


        return response;
    }

    @Override
    public void changeOrderStatus(long id) {
        OrderEntity order = orderRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.ORDER_NOT_FOUND));

        MovieScheduleEntity movieSchedule = order.getMovieSchedule();
        if (order.getStatus() != ConstantVariable.ORDER_UNUSED)
            throw new AppException(ErrorCode.ORDER_CAN_NOT_USED);

        if(movieSchedule!=null){
            LocalDateTime timeStart = movieSchedule.getTimeStart().minusMinutes(15);
            LocalDateTime timeEnd = movieSchedule.getTimeStart().plusMinutes(movieSchedule.getFilm().getDuration());
            LocalDateTime now = LocalDateTime.now();
            //Check 15 minutes before start until finish
            if (now.isAfter(timeStart) && now.isBefore(timeEnd)) {
                order.setStatus(ConstantVariable.ORDER_USED);
                orderRepository.save(order);
                return;
            }
        }else{
            if(order.getDate().toLocalDate().equals(LocalDate.now())){
                order.setStatus(ConstantVariable.ORDER_USED);
                orderRepository.save(order);
                return;
            }
        }
        throw new AppException(ErrorCode.NOT_TIME_TO_USE);
    }

    @Override
    @Scheduled(cron = "0 0 1 * * ?")
    public void autoChangeStatusFoodOrder() {
        List<OrderEntity> orders = orderRepository.MovieScheduleIsNullByDate_Date(LocalDate.now(),ConstantVariable.ORDER_UNUSED);
        if (!orders.isEmpty()) {
            orders.forEach(order -> {
                //Schedule not null
                if (LocalDate.now().isAfter(order.getDate().toLocalDate())) {
                    order.setStatus(ConstantVariable.ORDER_EXPIRED_USED);
                    orderRepository.save(order);
                }
            });
        }
    }

    @Override
    @Transactional
    @Scheduled(fixedRate = 60000)
    public void autoChangeStatusFilmOrder() {
        List<OrderEntity> orders = orderRepository.findAllByMovieSchedule_TimeStart_Date(LocalDate.now());
        if (!orders.isEmpty()) {
            orders.forEach(order -> {
                if (order.getMovieSchedule()
                        .getTimeStart()
                        .plusMinutes(order.getMovieSchedule().getFilm().getDuration())
                        .isBefore(LocalDateTime.now())
                        && order.getStatus() == ConstantVariable.ORDER_UNUSED) {

                    order.setStatus(ConstantVariable.ORDER_EXPIRED_USED);
                    orderRepository.save(order);
                }
            });
        }
    }

    String getStatus(int statusInt) {
        String status = "";
        if (statusInt == 0) status = "Unused";
        else status = statusInt == 1 ? "Used" : "Expired";
        return status;
    }
    String encodePaymentCode(String key, String paymentCode) throws NoSuchAlgorithmException, InvalidKeyException {
        try {
            SecretKey secretKey = new SecretKeySpec(key.getBytes(), "HmacSHA512");
            Mac mac = Mac.getInstance("HmacSHA512");
            mac.init(secretKey);
            byte[] hmacSha512Bytes = mac.doFinal(paymentCode.getBytes());

            return Base64.getEncoder().encodeToString(hmacSha512Bytes);
        }catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
