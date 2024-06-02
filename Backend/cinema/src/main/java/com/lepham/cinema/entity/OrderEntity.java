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
    @Column(name = "order_code")
    String orderCode;
    @Column(name = "seat")
    int seat;
    @Column(name = "sumtotal")
    int sumTotal;
    @Column(name = "date")
    Date date;
    @Column(name = "quantity_ticket")
    double quantityTicket;
    @Column(name = "payment_method")
    double paymentMethod;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "film_id", nullable = false)
    FilmEntity films;

    @ManyToMany(fetch = FetchType.LAZY,mappedBy = "orders")
    List<FoodEntity> foods;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "ratingfeedback_id", referencedColumnName = "id")
    RatingFeedbackEntity ratingFeedback;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "account_id", nullable = false)
    AccountEntity account;
}
