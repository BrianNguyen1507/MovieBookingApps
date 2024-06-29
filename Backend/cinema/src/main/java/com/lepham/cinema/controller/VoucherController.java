package com.lepham.cinema.controller;

import com.lepham.cinema.dto.request.AccountVoucherRequest;
import com.lepham.cinema.dto.request.VoucherRequest;
import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.dto.response.VoucherResponse;
import com.lepham.cinema.service.imp.AccountVoucherService;
import com.lepham.cinema.service.imp.VoucherService;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.util.List;

@RestController
@RequestMapping("/cinema")
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class VoucherController {

    VoucherService voucherService;
    AccountVoucherService accountVoucherService;

    @GetMapping(value = "/getAllVoucher")
    APIResponse<List<VoucherResponse>> getAllVoucher() {
        return APIResponse.<List<VoucherResponse>>builder()
                .result(voucherService.getAllVoucher())
                .build();
    }

    @PostMapping(value = "/addVoucher")
    APIResponse<VoucherResponse> addVoucher(@RequestBody @Valid VoucherRequest request) throws ParseException {
        return APIResponse.<VoucherResponse>builder()
                .result(voucherService.addVoucher(request))
                .build();
    }

    @PutMapping(value = "/updateVoucher")
    APIResponse<VoucherResponse> updateVoucher(@RequestParam("id") long id
            , @RequestBody @Valid VoucherRequest request) throws ParseException {

        return APIResponse.<VoucherResponse>builder()
                .result(voucherService.updateVoucher(id, request))
                .build();

    }

    @DeleteMapping(value = "/deleteVoucher")
    APIResponse<?> deleteVoucher(@RequestParam("id") long id) {
        voucherService.deleteVoucher(id);
        return APIResponse.builder()
                .message("Delete successful")
                .build();
    }

    @PostMapping(value = "/giftVoucher")
    APIResponse<?> giftVoucher(@RequestBody @Valid AccountVoucherRequest request) {
        accountVoucherService.gift(request);
        return APIResponse.builder().message("Gift Voucher Success!").build();
    }

    @DeleteMapping(value = "/deleteGiftVoucher")
    APIResponse<?>deleteGiftVoucher(@RequestParam("id") long id) {
        accountVoucherService.deleteVoucher(id);
        return APIResponse.builder().message("Delete Gift Voucher successful").build();
    }


    @GetMapping(value = "/getVoucherByAccountId")
    APIResponse<List<VoucherResponse>> getVoucherByAccountId(@RequestParam("accountId") long accountId) {
        List<VoucherResponse> vouchers = accountVoucherService.getVouchersByAccountId(accountId);
        return APIResponse.<List<VoucherResponse>>builder().result(vouchers).build();
    }
    @GetMapping("/getAllVoucherByAccount")
    APIResponse<List<VoucherResponse>> getAllVoucherByAccount(@RequestParam("accountId") long accountId,
                                                              @RequestParam("price") double price){
        return APIResponse.<List<VoucherResponse>>builder()
                .result(voucherService.getAllVoucherByAccountAndMinLimit(price,accountId))
                .build();
    }
}
