package com.lepham.cinema.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "ratingfeedback")
public class RatingFeedbackEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    long id;
    @Column(name = "rating",nullable = false)
    int rating;
    @Column(name = "comment",nullable = false)
    String price;
    @Column(name = "datetime",nullable = false)
    Date datetime;

    @OneToOne(mappedBy = "ratingFeedback")
    OrderEntity order;
}
