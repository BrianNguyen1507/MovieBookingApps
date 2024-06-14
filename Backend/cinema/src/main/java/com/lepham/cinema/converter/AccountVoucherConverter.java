package com.lepham.cinema.converter;

import com.lepham.cinema.dto.request.AccountVoucherRequest;
import com.lepham.cinema.entity.AccountVoucher;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface AccountVoucherConverter {
    AccountVoucher toAccountVoucherEntity(AccountVoucherRequest request);
}