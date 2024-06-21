package com.lepham.cinema.repository;

import com.lepham.cinema.dto.response.VoucherResponse;
import com.lepham.cinema.entity.VoucherEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface VoucherRepository extends JpaRepository<VoucherEntity,Long> {
    List<VoucherEntity> findAllByHide(boolean hide);
    @Query("SELECT v FROM AccountVoucher av " +
            "JOIN av.voucher v " +
            "WHERE av.account.id = :accountId AND av.hide = false")
    List<VoucherEntity> findAccountVoucherByAccount_IdAndNotHide(@Param("accountId") long accountId);
}
