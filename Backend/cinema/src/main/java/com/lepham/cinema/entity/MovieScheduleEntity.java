package com.lepham.cinema.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

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
    @Column(name = "time_start",nullable = false)
    LocalDateTime timeStart;

    @Column(name = "seat",length = 1000,nullable = false)
    int[][] seat;

    @ManyToOne
    @JoinColumn(name = "room_id" )
    RoomEntity room;

    @ManyToOne
    @JoinColumn(name = "film_id")
    FilmEntity film;

    @OneToMany(mappedBy = "movieSchedule", fetch = FetchType.LAZY)
    List<OrderEntity> orders;

    public int[][] generateSeat(int row, int column){
        int[][] seat = new int[row][column];
        for(int i=0;i<row;i++){
            for(int j=0;j<column;j++){
                seat[i][j]=0;
            }
        }
        return seat;
    }

    public boolean orderSeat(int[][] seat,int positionRow, int positionColumn){
        for(int i=1;i<=seat.length;i++){
            for(int j=1;j<seat[i].length;j++){
                if(seat[i][j]==0){
                    seat[i][j]=1;
                    return true;
                }
            }
        }
        return false;
    }
}
