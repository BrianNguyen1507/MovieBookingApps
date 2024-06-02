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
@Table(name = "movie_schedule")
public class MovieScheduleEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    long id;
    @Column(name = "time")
    Date time;

    @ManyToOne
    @JoinColumn(name = "room_id")
    RoomEntity room;

    @ManyToOne
    @JoinColumn(name = "film_id")
    FilmEntity film;

}
