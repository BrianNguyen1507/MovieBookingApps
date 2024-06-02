package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.CategoryRequest;
import com.lepham.cinema.dto.response.CategoryResponse;

import java.util.List;

public interface ICategoryService {
    List<CategoryResponse> getAllCategory();

    CategoryResponse create(CategoryRequest request);
    CategoryResponse update(CategoryRequest request);
    void delete(long id);
}
