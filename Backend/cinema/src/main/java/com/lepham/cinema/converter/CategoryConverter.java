package com.lepham.cinema.converter;

import com.lepham.cinema.dto.request.CategoryRequest;
import com.lepham.cinema.dto.response.CategoryResponse;
import com.lepham.cinema.entity.CategoryEntity;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class CategoryConverter {

    public CategoryResponse toCategoryResponse(CategoryEntity entity) {
        CategoryResponse request = new CategoryResponse();
        request.setId(entity.getId());
        request.setName(entity.getName());
        return request;
    }

    public CategoryEntity toEntity(CategoryRequest request) {
        CategoryEntity entity = new CategoryEntity();
        entity.setId(request.getId());
        entity.setName(request.getName());
        return entity;
    }

    public List<CategoryResponse> toListCategoryRequest(List<CategoryEntity> entities) {
        List<CategoryResponse> DTOs = new ArrayList<CategoryResponse>();
        for (CategoryEntity entity : entities) {
            CategoryResponse dto = toCategoryResponse(entity);
            DTOs.add(dto);
        }
        return DTOs;
    }

    public List<CategoryEntity> toListEntities(List<CategoryRequest> requests) {
        List<CategoryEntity> entities = new ArrayList<CategoryEntity>();
        for (CategoryRequest request : requests) {
            CategoryEntity entity = toEntity(request);
            entities.add(entity);
        }
        return entities;
    }
}
