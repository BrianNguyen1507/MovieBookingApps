package com.lepham.cinema.converter;

import com.lepham.cinema.dto.request.OrderFilmRequest;
import com.lepham.cinema.dto.response.DetailOrderResponse;
import com.lepham.cinema.dto.response.OrderCheckResponse;
import com.lepham.cinema.dto.response.OrderResponse;
import com.lepham.cinema.entity.OrderEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Mappings;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Mapper(componentModel = "spring")
public interface OrderConverter {
    default OrderEntity toEntity(OrderFilmRequest request){
        OrderEntity order = new OrderEntity();
        order.setDate(LocalDateTime.now());
        order.setOrderCode(generateOrderCode());
        order.setPaymentCode(request.getPaymentCode());
        order.setPaymentMethod(request.getPaymentMethod());
        order.setSumTotal(request.getSumTotal());
        order.setSeat(request.getSeat());
        return order;
    }
    @Mapping(target = "orderCode",ignore = true)
    OrderResponse toOrderFilmResponse( OrderEntity entity);

    @Mapping(target = "orderCode",ignore = true)
    DetailOrderResponse toDetailOrderResponse( OrderEntity entity);
    private static String generateOrderCode() {

        String dateStr = Instant.now().toEpochMilli()+"";

        String uniqueId = UUID.randomUUID().toString().replace("-", "")
                .substring(0, 6).toUpperCase();

        return "ORD" + dateStr + uniqueId;
    }
    OrderCheckResponse toOrderCheckResponse(OrderEntity entity);
}
