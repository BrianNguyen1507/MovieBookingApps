package com.lepham.cinema.repository;

import com.lepham.cinema.entity.AccountEntity;
import com.lepham.cinema.entity.AccountVoucher;
import com.lepham.cinema.entity.VoucherEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AccountVoucherRepository extends JpaRepository<AccountVoucher, Long> {
    AccountVoucher findByAccountAndVoucher(AccountEntity account, VoucherEntity voucher);
}
