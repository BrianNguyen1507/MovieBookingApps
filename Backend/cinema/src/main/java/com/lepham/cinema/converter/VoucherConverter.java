package com.lepham.cinema.converter;

import com.lepham.cinema.dto.request.VoucherRequest;
import com.lepham.cinema.dto.response.VoucherResponse;
import com.lepham.cinema.entity.VoucherEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

import java.text.ParseException;

@Mapper(componentModel = "spring")
public interface VoucherConverter {
    default VoucherEntity toEntity(VoucherRequest request) throws ParseException {
        VoucherEntity entity = new VoucherEntity();
        entity.setContent(request.getContent());
        entity.setDiscount(request.getDiscount());
        entity.setTitle(request.getTitle());
        entity.setQuantity(request.getQuantity());
        entity.setMinLimit(request.getMinLimit());
        entity.setTypeDiscount(request.getTypeDiscount());
        entity.setExpired(request.getExpired());
        return entity;
    }
    default VoucherResponse toResponse(VoucherEntity entity){
        VoucherResponse response = new VoucherResponse();
        response.setId(entity.getId());
        response.setContent(entity.getContent());
        response.setDiscount(entity.getDiscount());
        response.setTitle(entity.getTitle());
        response.setQuantity(entity.getQuantity());
        response.setMinLimit(entity.getMinLimit());
        response.setTypeDiscount(entity.getTypeDiscount());
        response.setExpired(entity.getExpired());
        return response;
    }
    default void updateVoucher(@MappingTarget VoucherEntity entity, VoucherRequest request) throws ParseException {
        entity.setContent(request.getContent());
        entity.setDiscount(request.getDiscount());
        entity.setTitle(request.getTitle());
        entity.setQuantity(request.getQuantity());
        entity.setMinLimit(request.getMinLimit());
        entity.setTypeDiscount(request.getTypeDiscount());
        entity.setExpired(request.getExpired());
    }
}
