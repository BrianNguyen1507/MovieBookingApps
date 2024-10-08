package com.lepham.cinema.controller;

import com.lepham.cinema.dto.request.FoodRequest;
import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.dto.response.FoodResponse;
import com.lepham.cinema.service.imp.FoodService;
import jakarta.validation.Valid;
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
public class FoodController {
    FoodService service;

    @GetMapping(value = "/getAllFood")
    APIResponse<List<FoodResponse>> getAllFood() {
        return APIResponse.<List<FoodResponse>>builder()
                .result(service.getAllFood())
                .build();
    }


    @PostMapping("/addFood")
    APIResponse<FoodResponse> addFood(@RequestBody @Valid FoodRequest request) throws Exception {
        return APIResponse.<FoodResponse>builder()
                .result(service.addFood(request))
                .build();
    }

    @PutMapping("/updateFood")
    APIResponse<FoodResponse> updateFood(@RequestParam("id") long id,@RequestBody  @Valid FoodRequest request) throws Exception {
        return APIResponse.<FoodResponse>builder()
                .result(service.updateFood(id,request))
                .build();
    }

    @DeleteMapping("/deleteFood")
    APIResponse<?> hideFood(@RequestParam("id") long id) throws Exception {
        service.deleteFood(id);
        return APIResponse.builder()
                .message("Delete food successful")
                .build();
    }
    @GetMapping(value = "/getFoodById")
    APIResponse<FoodResponse> findFoodById(@RequestParam("id") long id) {
        return APIResponse.<FoodResponse>builder()
                .result(service.findFoodById(id))
                .build();
    }
}
