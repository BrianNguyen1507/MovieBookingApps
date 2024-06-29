package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.VoucherRequest;
import com.lepham.cinema.dto.response.VoucherResponse;

import java.text.ParseException;
import java.util.List;

public interface






IVoucherService {
    List<VoucherResponse> getAllVoucher();
    VoucherResponse addVoucher(VoucherRequest request) throws ParseException;
    VoucherResponse updateVoucher(long id, VoucherRequest request) throws ParseException;
    void deleteVoucher(long id);
    List<VoucherResponse> getAllVoucherByAccountAndMinLimit(double price, long accountId);

}
