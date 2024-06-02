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
@Table(name = "film")
public class FilmEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    long id;
    @Column(name = "title")
    String title;
    @Column(name = "duration", length = 30)
    String duration;
    @Column(name = "description", length = 65535)
    @Lob
    byte[] description;
    @Column(name = "release_date")
    Date releaseDate;
    @Column(name = "director")
    String director;
    @Column(name = "actor")
    String actor;
    @Column(name = "poster",length = 16777215)
    @Lob
    byte[] poster;
    @Column(name = "trailer")
    String trailer;
    @Column(name = "country", length = 30)
    String country;
    @Column(name = "language", length = 30)
    String language;
    @Column(name = "active")
    int active;
    @Column(name = "base_price")
    double basePrice;

    @ManyToMany(fetch = FetchType.LAZY,mappedBy = "films")
    List<RoomEntity> rooms;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "film_category",
        joinColumns = @JoinColumn(name = "film_id"),
        inverseJoinColumns = @JoinColumn(name = "category_id")
    )
    List<CategoryEntity> categories;

    @OneToMany(mappedBy = "films", fetch = FetchType.LAZY,cascade = CascadeType.ALL)
    List<OrderEntity> orders;
}
