package com.lepham.cinema.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.Date;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "voucher")
public class VoucherEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    long id;
    @Column(name = "title",nullable = false)
    String title;
    @Column(name = "content")
    String content;
    @Column(name = "type_discount",nullable = false)
    int typeDiscount;
    @Column(name = "min_limit",nullable = false)
    double minLimit;
    @Column(name = "discount",nullable = false)
    double discount;
    @Column(name = "quantity",nullable = false)
    int quantity;
    @Column(name = "expired_date",nullable = false)
    Date expired;

    @OneToMany(mappedBy = "voucher")
    List<AccountVoucher> accounts;
}
