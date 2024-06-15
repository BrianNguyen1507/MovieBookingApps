package com.lepham.cinema.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "film")
public class FilmEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    long id;
    @Column(name = "title")
    String title;
    @Column(name = "duration", length = 30,nullable = false)
    int duration;
    @Column(name = "description", length = 65535,nullable = false)
    @Lob
    byte[] description;
    @Column(name = "release_date")
    LocalDate releaseDate;
    @Column(name = "director",nullable = false)
    String director;
    @Column(name = "actor",nullable = false)
    String actor;
    @Column(name = "poster",length = 16777215,nullable = false)
    @Lob
    byte[] poster;
    @Column(name = "trailer")
    String trailer;
    @Column(name = "country", length = 30)
    String country;
    @Column(name = "language", length = 30)
    String language;
    @Column(name = "active",nullable = false)
    int active;
    @Column(name = "base_price",nullable = false)
    double basePrice;
    @Column(name = "hide",nullable = false)
    boolean hide;
    @Column(name = "classify",nullable = false,length = 5)
    String classify;

    @OneToMany(mappedBy = "film",cascade = CascadeType.ALL,fetch = FetchType.LAZY)
    List<MovieScheduleEntity> schedules;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "film_category",
        joinColumns = @JoinColumn(name = "film_id"),
        inverseJoinColumns = @JoinColumn(name = "category_id")
    )
    List<CategoryEntity> categories;

    @OneToMany(mappedBy = "films", fetch = FetchType.LAZY)
    List<OrderEntity> orders;
}
