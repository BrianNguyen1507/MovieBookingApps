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
@Table(name = "food")
public class FoodEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    long id;
    @Column(name = "image",length = 167777)
    @Lob
    byte[] image;
    @Column(name = "name",nullable = false)
    String name;
    @Column(name = "price", nullable = false)
    double price;
    @Column(name = "hide", nullable = false)
    boolean hide;

    @OneToMany(mappedBy = "food")
    List<FoodOrderEntity> foodOrders;
}
