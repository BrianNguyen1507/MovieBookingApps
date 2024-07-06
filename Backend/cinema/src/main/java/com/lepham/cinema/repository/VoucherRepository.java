package com.lepham.cinema.repository;

import com.lepham.cinema.dto.response.VoucherResponse;
import com.lepham.cinema.entity.VoucherEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface VoucherRepository extends JpaRepository<VoucherEntity,Long> {
    List<VoucherEntity> findAllByHide(boolean hide);
    @Query("SELECT v FROM AccountVoucher av " +
            "JOIN av.voucher v " +
            "WHERE av.account.id = :accountId AND av.hide = false")
    List<VoucherEntity> findAccountVoucherByAccount_IdAndNotHide(@Param("accountId") long accountId);

    Optional<VoucherEntity> findByIdAndHide(long id, boolean hide);

    @Query("SELECT v FROM AccountVoucher av JOIN av.voucher v WHERE av.account.id = ?2 AND av.hide = false and v.hide=false and v.minLimit<=?1 and av.quantity > 0 and v.expired > Now()")
    List<VoucherEntity> findAllByAllowVoucher(double price, long accountId);
    @Query("SELECT v FROM AccountVoucher av JOIN av.voucher v WHERE (av.account.id = ?2 AND av.hide = false and v.hide=false) and v.expired > Now() and v.minLimit>?1 or av.quantity<0")
    List<VoucherEntity> findAllByNotAllowVoucher(double price, long accountId);

    VoucherEntity findByTypeDiscount(int type);
}
