package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.AccountRequest;
import com.lepham.cinema.dto.request.LoginRequest;
import com.lepham.cinema.dto.request.OTPRequest;
import com.lepham.cinema.dto.request.ResetPasswordRequest;
import com.lepham.cinema.dto.response.AccountResponse;
import com.lepham.cinema.entity.AccountEntity;
import jakarta.mail.MessagingException;

import java.io.UnsupportedEncodingException;
import java.text.ParseException;

public interface IAccountService {
    AccountResponse createAccount(AccountRequest request) throws ParseException, MessagingException, UnsupportedEncodingException;
    AccountResponse checkOTP(OTPRequest request);

    AccountEntity login(LoginRequest request);

    AccountResponse forgotPassWord(String email) throws MessagingException, UnsupportedEncodingException;
    AccountResponse resetPassword(ResetPasswordRequest request);
    AccountResponse getMyInfo();

    AccountResponse updateAccount(AccountRequest accountRequest) throws ParseException;
}
