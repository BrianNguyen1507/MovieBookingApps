package com.lepham.cinema.entity;

import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;
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

    @OneToMany(mappedBy = "schedule", fetch = FetchType.LAZY)
    List<SeatHeldEntity> seatHeld;

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
        if(array.length>10) throw new AppException(ErrorCode.HOLD_SEAT_ABOVE_LIMIT);
        for (String stringSeat : array) {
            if(stringSeat.length()>2) throw new AppException(ErrorCode.STRING_SEAT_INCORRECT);
            try {
                int rowIndex = stringSeat.charAt(0) - 'A';
                int columnIndex = Integer.parseInt(stringSeat.charAt(1)+"")-1;
                if(seat[rowIndex][columnIndex] != 0 ){
                    return  false;
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
        if(array.length>10) throw new AppException(ErrorCode.HOLD_SEAT_ABOVE_LIMIT);

        for (String stringSeat : array) {
            if(stringSeat.length()>2)throw new AppException(ErrorCode.STRING_SEAT_INCORRECT);
            try {
                int rowIndex = stringSeat.charAt(0) - 'A';
                int columnIndex = Integer.parseInt(stringSeat.charAt(1)+"")-1;
                if(seat[rowIndex][columnIndex] == 1 || seat[rowIndex][columnIndex] == 2){
                    return false;
                }
                seat[rowIndex][columnIndex] = 2;
            } catch (NumberFormatException e) {
                return false;
            }
        }
        return true;
    }
    public boolean returnSeat(String seatOrder){
        String[] array = seatOrder.split(",");
        for (String stringSeat : array) {
            if(stringSeat.length()>2)throw new AppException(ErrorCode.STRING_SEAT_INCORRECT);
            try {
                int rowIndex = stringSeat.charAt(0) - 'A';
                int columnIndex = Integer.parseInt(stringSeat.charAt(1)+"")-1;
                if(seat[rowIndex][columnIndex] == 1){
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
