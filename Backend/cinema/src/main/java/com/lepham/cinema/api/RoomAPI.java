package com.lepham.cinema.api;

import com.lepham.cinema.dto.request.RoomRequest;
import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.dto.response.RoomResponse;
import com.lepham.cinema.service.imp.RoomService;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/cinema")
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class RoomAPI {

    RoomService roomService;

    @GetMapping(value = "/getAllRoom")
    APIResponse<List<RoomResponse>> getAllRoom(){
        return APIResponse.<List<RoomResponse>>builder()
                .result(roomService.getAllRoom())
                .build();
    }
    @GetMapping(value = "/getRoomById")
    APIResponse<RoomResponse> getRoomById(@RequestParam("id") long id){
        return APIResponse.<RoomResponse>builder()
                .result(roomService.getRoomById(id))
                .build();
    }
    @GetMapping(value = "/getAllRoomByTheaterId")
    APIResponse<List<RoomResponse>> getAllRoomByTheaterId(@RequestParam("theaterId") long theaterId){
        return APIResponse.<List<RoomResponse>>builder()
                .result(roomService.getAllRoomByTheater(theaterId))
                .build();
    }

    @PostMapping(value = "/addRoom")
    APIResponse<RoomResponse> addRoom(@RequestBody @Valid RoomRequest request){
        return APIResponse.<RoomResponse>builder()
                .result(roomService.addRoom(request))
                .build();
    }

    @PutMapping(value = "/updateRoom")
    APIResponse<RoomResponse> updateRoom(@RequestParam("id") long id
            , @RequestBody @Valid RoomRequest request){
        return APIResponse.<RoomResponse>builder()
                .result(roomService.updateRoom(id,request))
                .build();
    }

    @DeleteMapping(value = "/deleteRoom")
    APIResponse<?> deleteMovieTheater(@RequestParam("id") long id){
        roomService.deleteRoom(id);
        return APIResponse.builder()
                .message("Delete successful")
                .build();
    }
}
