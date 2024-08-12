package com.lepham.cinema.service.imp;

import com.lepham.cinema.converter.VoucherConverter;
import com.lepham.cinema.dto.request.AccountVoucherRequest;
import com.lepham.cinema.dto.response.VoucherResponse;
import com.lepham.cinema.entity.AccountEntity;
import com.lepham.cinema.entity.AccountVoucherEntity;
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
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class AccountVoucherService implements IAccountVoucherService {
    AccountVoucherRepository accountVoucherRepository;
    AccountRepository accountRepository;
    VoucherRepository voucherRepository;
    VoucherConverter converter;

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public void gift(AccountVoucherRequest request) {
        List<AccountEntity> activeUserIds = accountRepository.findAllByActiveAndRole(1, "USER");
        VoucherEntity voucher = voucherRepository.findById(request.getVoucherId())
                .orElseThrow(() -> new AppException(ErrorCode.VOUCHER_NOT_FOUND));

        for (AccountEntity account : activeUserIds) {
            AccountVoucherEntity accountVoucherEntity = accountVoucherRepository.findByAccountAndVoucher(account,voucher);
            if(accountVoucherEntity!=null){
                accountVoucherEntity.setQuantity(accountVoucherEntity.getQuantity()+request.getQuantity());
            }
            else{
                accountVoucherEntity = new AccountVoucherEntity();
                accountVoucherEntity.setQuantity(request.getQuantity());
                accountVoucherEntity.setAccount(account);
                accountVoucherEntity.setVoucher(voucher);
            }
            accountVoucherRepository.save(accountVoucherEntity);
        }
    }

    @PreAuthorize("hasRole('ADMIN')")
    @Override
    public void deleteVoucher(long id) {
        AccountVoucherEntity entity = accountVoucherRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.VOUCHER_NOT_ENOUGH));
        entity.setHide(true);
        accountVoucherRepository.save(entity);
    }


    @Override
    @PreAuthorize("hasRole('USER')")
    public List<VoucherResponse> getVouchersByEmail(String email) {
        List<VoucherEntity> vouchers = voucherRepository.findAccountVoucherByEmail(email);
        return vouchers.stream()
                .map(converter::toResponse)
                .collect(Collectors.toList());
    }


}
