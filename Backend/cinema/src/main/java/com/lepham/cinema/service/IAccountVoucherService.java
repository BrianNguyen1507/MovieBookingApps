package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.AccountVoucherRequest;
import com.lepham.cinema.dto.response.VoucherResponse;
import org.springframework.security.access.prepost.PreAuthorize;

import java.util.List;

public interface IAccountVoucherService {
   void gift(AccountVoucherRequest request);
   void deleteVoucher (long id);

   @PreAuthorize("hasRole('USER')")
   List<VoucherResponse> getVouchersByAccountId(long accountId);

}
