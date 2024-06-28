package com.lepham.cinema.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.time.LocalDateTime;
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

    @Lob
    @Column(name = "seat",nullable = false)
    int[] seat;
    @Column(name = "sumtotal",nullable = false)
    int sumTotal;
    @Column(name = "date",nullable = false)
    LocalDateTime date;
    @Column(name = "payment_method",nullable = false)
    double paymentMethod;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "movie_schedule_id", nullable = false)
    MovieScheduleEntity movieSchedule;

    @OneToMany(mappedBy = "order")
    List<FoodOrderEntity> foodOrders;


    @OneToOne(mappedBy = "order")
    RatingFeedbackEntity ratingFeedback;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "account_voucher_id", nullable = false)
    AccountVoucher accountVoucher;
}
