package com.lepham.cinema.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "movieTheater")
public class MovieTheaterEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    long id;
    @Column(name = "name",nullable = false)
    String name;
    @Column(name = "address",nullable = false)
    String address;
    @Column(name = "hide")
    boolean hide;

    @OneToMany(mappedBy = "movieTheater", fetch = FetchType.LAZY,cascade = CascadeType.ALL)
    List<RoomEntity> rooms = new ArrayList<RoomEntity>();
}
