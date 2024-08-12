package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.FoodRequest;
import com.lepham.cinema.dto.response.FoodResponse;

import java.util.List;

public interface IFoodService {
    List<FoodResponse> getAllFood();
    FoodResponse updateFood(long id,FoodRequest request);
    FoodResponse addFood(FoodRequest request);
    void deleteFood(long id);

    FoodResponse findFoodById(long id);
}
