package com.lepham.cinema.converter;

import com.lepham.cinema.dto.request.OrderFilmRequest;
import com.lepham.cinema.dto.response.OrderResponse;
import com.lepham.cinema.entity.OrderEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Mappings;

import java.time.Instant;
import java.time.LocalDateTime;

@Mapper(componentModel = "spring")
public interface OrderConverter {
    default OrderEntity toEntity(OrderFilmRequest request){
        OrderEntity order = new OrderEntity();
        order.setDate(LocalDateTime.now());
        order.setOrderCode(Instant.now().toEpochMilli()+"");
        order.setPaymentCode(request.getPaymentCode());
        order.setPaymentMethod(request.getPaymentMethod());
        order.setSumTotal(request.getSumTotal());
        order.setSeat(request.getSeat());
        return order;
    }
//    @Mappings({
//            @Mapping(target = "movieSchedule", ignore = true),
//            @Mapping(target = "foodOrders", ignore = true),
//            @Mapping(target = "ratingFeedback", ignore = true),
//            @Mapping(target = "accountVoucher", ignore = true)
//    })
    OrderResponse toOrderFilmResponse( OrderEntity entity);
}
