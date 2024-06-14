package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.AccountVoucherRequest;

public interface IAccountVoucherService {
   void gift(AccountVoucherRequest request);
   void delete (long id);
}
