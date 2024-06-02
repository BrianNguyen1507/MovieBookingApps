package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.RoomRequest;
import com.lepham.cinema.dto.response.RoomResponse;

import java.util.List;

public interface IRoomService {

    List<RoomResponse> getAllRoom();
    List<RoomResponse> getAllRoomByTheater(long theaterId);
    RoomResponse addRoom(RoomRequest request);
    RoomResponse updateRoom(long roomId,RoomRequest request);
    void deleteRoom(long id);

}
