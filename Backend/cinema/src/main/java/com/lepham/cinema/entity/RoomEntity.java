package com.lepham.cinema.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.springframework.cglib.core.Block;

import java.sql.Blob;
import java.util.Date;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "room")
public class RoomEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    long id;
    @Column(name = "number",nullable = false)
    int number;
    @Column(name = "row_of_seats",nullable = false)
    int row;
    @Column(name = "seat_amount",nullable = false)
    int column;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "theater_id", nullable = false)
    MovieTheaterEntity movieTheater;

    @OneToMany(mappedBy = "room")
    List<MovieScheduleEntity> schedules;



}
