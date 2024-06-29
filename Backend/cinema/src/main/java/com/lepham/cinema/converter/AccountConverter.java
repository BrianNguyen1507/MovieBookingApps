package com.lepham.cinema.converter;

import com.lepham.cinema.dto.request.AccountRequest;
import com.lepham.cinema.dto.response.AccountResponse;
import com.lepham.cinema.entity.AccountEntity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Mappings;
import org.springframework.stereotype.Component;

import java.text.ParseException;

@Mapper(componentModel = "spring")
public interface AccountConverter {
     AccountResponse toResponse(AccountEntity entity);

     AccountEntity toEntity(AccountRequest request);

     @Mappings({
             @Mapping(target = "vouchers", ignore = true),
             @Mapping(target = "email", ignore = true),
             @Mapping(target = "password", ignore = true),
             @Mapping(target = "active", ignore = true),
     })

     void updateAccount(@MappingTarget AccountEntity entity, AccountRequest request);

}
