package com.lepham.cinema.repository;

import com.lepham.cinema.entity.RoomEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository
public interface RoomRepository extends JpaRepository<RoomEntity,Long> {
    @Query(value = "select r from RoomEntity r where r.number=?1 and r.movieTheater.id =?2 and r.hide=false")
    RoomEntity checkExistsRoom(int number, long theaterId);
    @Query(value = "select r from RoomEntity r where r.number=?1 and r.movieTheater.id =?2 and r.hide=false and r.id != ?3")
    RoomEntity checkExistsRoomId(int number, long theaterId,long id);
    @Query(value = "select r from RoomEntity r where r.movieTheater.id =?1 and r.hide = false order by r.number asc")
    List<RoomEntity> findAllByMovieTheater_Id(long id);

    @Query(value = "select r from RoomEntity r where  r.hide = ?1 order by r.movieTheater.id,r.number asc")
    List<RoomEntity> findAllByHide(boolean hide);

    Optional<RoomEntity> findByIdAndHide(long id, boolean hide);

}
