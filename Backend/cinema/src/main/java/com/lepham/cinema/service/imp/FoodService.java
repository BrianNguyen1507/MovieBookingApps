package com.lepham.cinema.service.imp;

import com.lepham.cinema.converter.FoodConverter;
import com.lepham.cinema.dto.request.FoodRequest;
import com.lepham.cinema.dto.response.FoodResponse;
import com.lepham.cinema.entity.FoodEntity;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.FoodRepository;
import com.lepham.cinema.service.IFoodService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class FoodService implements IFoodService {
    FoodRepository repository;
    FoodConverter converter;

    @Override
    public List<FoodResponse> getAllFood() {
        List<FoodEntity> entities = repository.findAllByHide(false);
        return entities.stream().map(converter::toFoodResponse).toList();
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public FoodResponse updateFood(long id, FoodRequest request) {
        FoodEntity foodEntity = repository.getReferenceById(id);
        foodEntity.setName(request.getName());
        foodEntity.setPrice(request.getPrice());
        foodEntity.setImage(request.getImage());
        FoodResponse foodResponse = converter.toFoodResponse(repository.save(foodEntity));
        foodResponse.setImage(foodEntity.getImage());
        return foodResponse;
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public FoodResponse addFood(FoodRequest request) {
        FoodEntity foodEntity = converter.toFoodEntity(request);
        foodEntity.setHide(false);
        foodEntity.setImage(request.getImage());
        FoodResponse foodResponse = converter.toFoodResponse(repository.save(foodEntity));
        foodResponse.setImage(foodEntity.getImage());
        return foodResponse;
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public void deleteFood(long id) {
        FoodEntity foodEntity = repository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.FOOD_NOT_FOUND));
        foodEntity.setHide(true);
        repository.save(foodEntity);
    }

    @Override
    public FoodResponse findFoodById(long id) {
        FoodEntity food = repository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.FOOD_NOT_FOUND));

        return converter.toFoodResponse(food);
    }
}
