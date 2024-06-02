package com.lepham.cinema.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "account_voucher")
public class AccountVoucher {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="id")
    long id;
    @Column(name = "quantity",nullable = false)
    int quantity;

    @ManyToOne
    @JoinColumn(name = "account_id")
    AccountEntity account;

    @ManyToOne
    @JoinColumn(name = "voucher_id")
    VoucherEntity voucher;
}
