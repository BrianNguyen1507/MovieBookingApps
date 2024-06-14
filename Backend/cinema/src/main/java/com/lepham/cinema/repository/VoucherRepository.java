package com.lepham.cinema.repository;

import com.lepham.cinema.entity.VoucherEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface VoucherRepository extends JpaRepository<VoucherEntity,Long> {
    List<VoucherEntity> findAllByHide(boolean hide);
}
