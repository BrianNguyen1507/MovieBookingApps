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
    @Column(name = "time_start",nullable = false)
    Date timeStart;
    @Column(name = "seat",length = 1000,nullable = false)
    int[][] seat;

    @ManyToOne
    @JoinColumn(name = "room_id")
    RoomEntity room;

    @ManyToOne
    @JoinColumn(name = "film_id")
    FilmEntity film;
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
