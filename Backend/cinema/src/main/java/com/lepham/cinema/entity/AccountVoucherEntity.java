package com.lepham.cinema.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "account_voucher")
public class AccountVoucherEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="id")
    long id;

    @Column(name = "quantity",nullable = false)
    int quantity;

    @Column(name = "hide", nullable = false)
    boolean hide;

    @ManyToOne
    @JoinColumn(name = "account_id")
    AccountEntity account;

    @ManyToOne
    @JoinColumn(name = "voucher_id")
    VoucherEntity voucher;

    @OneToMany(mappedBy = "accountVoucher")
    List<OrderEntity> orders;
}
