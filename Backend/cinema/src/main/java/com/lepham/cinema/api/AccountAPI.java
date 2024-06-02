package com.lepham.cinema.api;

import com.lepham.cinema.dto.request.AccountRequest;
import com.lepham.cinema.dto.request.LoginRequest;
import com.lepham.cinema.dto.request.OTPRequest;
import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.dto.response.AccountResponse;
import com.lepham.cinema.dto.response.AuthenticationResponse;
import com.lepham.cinema.service.imp.AccountService;
import com.lepham.cinema.service.imp.AuthenticationService;
import jakarta.mail.MessagingException;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.io.UnsupportedEncodingException;
import java.text.ParseException;

@RestController
@RequestMapping("/cinema")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class AccountAPI {

    AccountService accountService;

    AuthenticationService authenticationService;

    @PostMapping(value = "/register")
    public APIResponse<AccountResponse> createAccount(@RequestBody AccountRequest request) throws ParseException, MessagingException, UnsupportedEncodingException {
        return APIResponse.<AccountResponse>builder()
                .result(accountService.createAccount(request))
                .build();
    }
    @PutMapping(value = "/activeAccount")
    public APIResponse<AccountResponse> activeAccount(@RequestBody OTPRequest request){
        return APIResponse.<AccountResponse>builder()
                .result(accountService.checkOTP(request))
                .build();
    }
    @PostMapping(value = "/login")
    public APIResponse<AuthenticationResponse> login(@RequestBody LoginRequest request){
        return APIResponse.<AuthenticationResponse>builder()
                .result(authenticationService.authenticate(request))
                .build();
    }
}
