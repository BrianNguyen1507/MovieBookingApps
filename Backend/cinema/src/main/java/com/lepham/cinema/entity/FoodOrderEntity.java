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
@Table(name = "food_order")
public class FoodOrderEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    long id;
    @Column(name = "quantity")
    int quantity;

    @ManyToOne
    @JoinColumn(name = "order_id")
    OrderEntity order;

    @ManyToOne
    @JoinColumn(name = "food_id")
    FoodEntity food;
}
