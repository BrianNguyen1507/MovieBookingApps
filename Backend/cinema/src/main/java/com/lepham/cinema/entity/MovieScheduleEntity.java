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

    public boolean orderSeat(String seatOrder){
        String[] array = seatOrder.split(",");
        for (String string : array) {
            try {
                int rowIndex = string.charAt(0) - 'A';
                int columnIndex = Integer.parseInt(string.charAt(1)+"")-1;
                if(seat[rowIndex][columnIndex] == 1){
                    return false;
                }
                seat[rowIndex][columnIndex] = 1;
            } catch (NumberFormatException e) {
                return false;
            }
        }
        return true;
    }
    public boolean holdSeat(String seatOrder){
        String[] array = seatOrder.split(",");
        for (String string : array) {
            try {
                int rowIndex = string.charAt(0) - 'A';
                int columnIndex = Integer.parseInt(string.charAt(1)+"")-1;
                if(seat[rowIndex][columnIndex] == 1){
                    return false;
                }
                seat[rowIndex][columnIndex] = 2;
            } catch (NumberFormatException e) {
                return false;
            }
        }
        return true;
    }
    public boolean refundSeat(String seatOrder){
        String[] array = seatOrder.split(",");
        for (String string : array) {
            try {
                int rowIndex = string.charAt(0) - 'A';
                int columnIndex = Integer.parseInt(string.charAt(1)+"")-1;
                if(seat[rowIndex][columnIndex] != 2){
                    return false;
                }
                seat[rowIndex][columnIndex] = 0;
            } catch (NumberFormatException e) {
                return false;
            }
        }
        return true;
    }
}
