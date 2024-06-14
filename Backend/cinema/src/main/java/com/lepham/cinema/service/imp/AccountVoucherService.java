package com.lepham.cinema.service.imp;

import com.lepham.cinema.converter.AccountVoucherConverter;
import com.lepham.cinema.dto.request.AccountVoucherRequest;
import com.lepham.cinema.entity.AccountEntity;
import com.lepham.cinema.entity.AccountVoucher;
import com.lepham.cinema.entity.VoucherEntity;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.AccountRepository;
import com.lepham.cinema.repository.AccountVoucherRepository;
import com.lepham.cinema.repository.VoucherRepository;
import com.lepham.cinema.service.IAccountVoucherService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class AccountVoucherService implements IAccountVoucherService {
    AccountVoucherRepository accountVoucherRepository;
    AccountRepository accountRepository;
    VoucherRepository voucherRepository;

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public void gift(AccountVoucherRequest request) {
        List<AccountEntity> activeUserIds = accountRepository.findAllByActiveAndRole(1, "USER");
        VoucherEntity voucher = voucherRepository.findById(request.getVoucherId())
                .orElseThrow(() -> new AppException(ErrorCode.NULL_EXCEPTION));

        for (AccountEntity account : activeUserIds) {
            AccountVoucher accountVoucherEntity = new AccountVoucher();
            accountVoucherEntity.setAccount(account);
            accountVoucherEntity.setQuantity(request.getQuantity());
            accountVoucherEntity.setVoucher(voucher);
            accountVoucherRepository.save(accountVoucherEntity);
        }


    }

    @Override
    public void delete(long id) {
    }
}
