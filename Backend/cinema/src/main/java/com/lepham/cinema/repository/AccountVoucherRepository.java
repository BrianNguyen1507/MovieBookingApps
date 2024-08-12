package com.lepham.cinema.repository;

import com.lepham.cinema.entity.AccountEntity;
import com.lepham.cinema.entity.AccountVoucherEntity;
import com.lepham.cinema.entity.VoucherEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AccountVoucherRepository extends JpaRepository<AccountVoucherEntity, Long> {
    AccountVoucherEntity findByAccountAndVoucher(AccountEntity account, VoucherEntity voucher);
}
