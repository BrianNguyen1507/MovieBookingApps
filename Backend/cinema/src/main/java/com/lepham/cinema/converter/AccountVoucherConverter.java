package com.lepham.cinema.converter;

import com.lepham.cinema.dto.request.AccountVoucherRequest;
import com.lepham.cinema.entity.AccountVoucherEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface AccountVoucherConverter {
    AccountVoucherEntity toAccountVoucherEntity(AccountVoucherRequest request);
}