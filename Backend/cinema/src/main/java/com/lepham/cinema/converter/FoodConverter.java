package com.lepham.cinema.converter;

import com.lepham.cinema.dto.request.FoodRequest;
import com.lepham.cinema.dto.response.FoodResponse;
import com.lepham.cinema.entity.FoodEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface FoodConverter {
    FoodEntity toFoodEntity(FoodRequest request);
    FoodResponse toFoodResponse(FoodEntity entity);
}