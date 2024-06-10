package com.lepham.cinema.converter;

import com.lepham.cinema.dto.request.AccountRequest;
import com.lepham.cinema.dto.response.AccountResponse;
import com.lepham.cinema.entity.AccountEntity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.text.ParseException;

@Component
@RequiredArgsConstructor
@Slf4j
public class AccountConverter {
    public AccountResponse toResponse(AccountEntity entity) {
        AccountResponse response = new AccountResponse();
        response.setEmail(entity.getEmail());
        response.setGender(entity.getGender());
        response.setFullName(entity.getFullName());
        response.setPhoneNumber(entity.getPhone());
        response.setDayOfBirth(DateConverter.toStringDMY(entity.getDayOfBirth()));
        response.setActive(entity.getActive());
        response.setRole(entity.getRole());
        return response;
    }

    public AccountEntity toEntity(AccountRequest request) throws ParseException {
        AccountEntity entity = new AccountEntity();

        entity.setGender(request.getGender());
        entity.setEmail(request.getEmail());
        entity.setFullName(request.getFullName());
        entity.setDayOfBirth(DateConverter.stringParseYMD(request.getDayOfBirth()));
        entity.setPhone(request.getPhoneNumber());
        entity.setActive(request.getActive());
        entity.setRole(request.getRole());
        return entity;
    }
}
