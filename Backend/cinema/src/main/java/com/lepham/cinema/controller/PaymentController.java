package com.lepham.cinema.controller;

import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.dto.response.VnPayResponse;
import com.lepham.cinema.service.imp.VnPayService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("cinema")
@Slf4j
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class PaymentController {

    VnPayService vnPayService;

    @GetMapping("/paymentVnPay")
    APIResponse<VnPayResponse> paymentVnPay(@RequestParam("total") long total){
        return APIResponse.<VnPayResponse>builder()
                .result(vnPayService.getPay(total))
                .build();
    }
}
