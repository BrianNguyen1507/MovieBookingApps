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
@Table(name = "orders")
public class OrderEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    long id;
    @Column(name = "order_code",nullable = false)
    String orderCode;
    @Column(name = "seat",nullable = false)
    int seat;
    @Column(name = "sumtotal",nullable = false)
    int sumTotal;
    @Column(name = "date",nullable = false)
    Date date;
    @Column(name = "quantity_ticket",nullable = false)
    double quantityTicket;
    @Column(name = "payment_method",nullable = false)
    double paymentMethod;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "film_id", nullable = false)
    FilmEntity films;

    @ManyToMany(fetch = FetchType.LAZY,mappedBy = "orders")
    List<FoodEntity> foods;


    @OneToOne(mappedBy = "order")
    RatingFeedbackEntity ratingFeedback;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "account_voucher_id", nullable = false)
    AccountVoucher accountVoucher;
}
