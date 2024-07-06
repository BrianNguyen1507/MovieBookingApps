package com.lepham.cinema.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;


@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "seat_held")
public class SeatHeldEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    long id;

    String seat;
    @Column(name = "held_date")
    LocalDateTime heldDateTime;
    @Column(name = "status")
    int status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "movie_schedule_id",nullable = false)
    MovieScheduleEntity schedule;
}
