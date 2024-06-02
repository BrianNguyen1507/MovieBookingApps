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
@Table(name = "rooms")
public class RoomEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    long id;
    @Column(name = "number")
    int number;
    @Column(name = "seat",length = 1000)
    int[][] seat;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "theater_id", nullable = false)
    MovieTheaterEntity movieTheater;

    @OneToMany(mappedBy = "room")
    List<MovieScheduleEntity> schedules;

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
