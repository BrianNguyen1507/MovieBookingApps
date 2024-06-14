package com.lepham.cinema.api;

import com.lepham.cinema.dto.request.FoodRequest;
import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.dto.response.FoodResponse;
import com.lepham.cinema.service.imp.FoodService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/cinema")
@Slf4j
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class FoodAPI {
    FoodService service;

    @GetMapping(value = "/getAllFood")
    APIResponse<List<FoodResponse>> getAllFood() {
        return APIResponse.<List<FoodResponse>>builder()
                .result(service.getAllFood())
                .build();
    }


    @PostMapping("/addFood")
    APIResponse<FoodResponse> addFood(@RequestBody FoodRequest request) throws Exception {
        return APIResponse.<FoodResponse>builder()
                .result(service.addFood(request))
                .build();
    }


    @PutMapping("/hideFood")
    APIResponse<?> hideFood(@RequestParam("id") long id) throws Exception {
        service.deleteFood(id);
        return APIResponse.builder()
                .message("Delete food successful")
                .build();
    }
}
