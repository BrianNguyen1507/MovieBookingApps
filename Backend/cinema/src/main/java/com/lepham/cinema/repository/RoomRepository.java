package com.lepham.cinema.repository;

import com.lepham.cinema.entity.RoomEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface RoomRepository extends JpaRepository<RoomEntity,Long> {
    @Query(value = "select r from RoomEntity r where r.number=?1 and r.movieTheater.id =?2 and r.hide=false")
    RoomEntity checkExistsRoom(int number, long theaterId);
    @Query(value = "select r from RoomEntity r where r.movieTheater.id =?1 and r.hide = false")
    List<RoomEntity> findAllByMovieTheater_Id(long id);

    List<RoomEntity> findAllByHide(boolean hide);

}
