package com.lepham.cinema.api;

import com.lepham.cinema.dto.request.VoucherRequest;
import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.dto.response.VoucherResponse;
import com.lepham.cinema.service.imp.VoucherService;
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
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class VoucherAPI {

    VoucherService voucherService;

    @GetMapping(value = "/getAllVoucher")
    APIResponse<List<VoucherResponse>> getAllVoucher(){
        return APIResponse.<List<VoucherResponse>>builder()
                .result(voucherService.getAllVoucher())
                .build();
    }

    @PostMapping(value = "/addVoucher")
    APIResponse<VoucherResponse> addVoucher(@RequestBody VoucherRequest request) throws ParseException {
        return APIResponse.<VoucherResponse>builder()
                .result(voucherService.addVoucher(request))
                .build();
    }

    @PutMapping(value = "/updateVoucher")
    APIResponse<VoucherResponse> updateVoucher(@RequestParam("id") long id
            ,@RequestBody VoucherRequest request) throws ParseException {

        return APIResponse.<VoucherResponse>builder()
                .result(voucherService.updateVoucher(id,request))
                .build();

    }

    @DeleteMapping(value = "/deleteVoucher")
    APIResponse<?> deleteVoucher(@RequestParam("id") long id){
        voucherService.deleteVoucher(id);
        return APIResponse.builder()
                .message("Delete successful")
                .build();
    }
}