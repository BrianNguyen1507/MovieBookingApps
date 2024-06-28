package com.lepham.cinema.service.imp;

import com.lepham.cinema.converter.CategoryConverter;
import com.lepham.cinema.dto.request.CategoryRequest;
import com.lepham.cinema.dto.response.CategoryResponse;
import com.lepham.cinema.entity.CategoryEntity;
import com.lepham.cinema.entity.FilmEntity;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.CategoryRepository;
import com.lepham.cinema.service.ICategoryService;
import com.lepham.cinema.validator.StringValidator;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class CategoryService implements ICategoryService {

    CategoryRepository categoryRepository;

    CategoryConverter categoryConverter;


    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public List<CategoryResponse> getAllCategory() {
        List<CategoryEntity> entities = categoryRepository.findAll();
        return categoryConverter.toListCategoryRequest(entities) ;
    }


    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public CategoryResponse create(CategoryRequest request) {
        if (categoryRepository.findByName(request.getName()).isPresent()) throw new AppException(ErrorCode.CATEGORY_NAME_DUPLICATE);
        CategoryEntity entity = categoryConverter.toEntity(request);
        return categoryConverter.toCategoryResponse(categoryRepository.save(entity));
    }


    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public CategoryResponse update(CategoryRequest request) {
        if (categoryRepository.findByName(request.getName()).isPresent()) throw new AppException(ErrorCode.CATEGORY_NAME_DUPLICATE);
        CategoryEntity entity = categoryRepository.getReferenceById(request.getId());
        entity.setName(request.getName());
        return categoryConverter.toCategoryResponse(categoryRepository.save(entity));
    }


    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public void delete(long id) {
        CategoryEntity entity = categoryRepository.findById(id)
                .orElseThrow(()->new AppException(ErrorCode.CATEGORY_NOT_FOUND));
        List<FilmEntity> filmEntities = entity.getFilms();
        filmEntities.forEach(film->film.getCategories().remove(entity));
        entity.getFilms().clear();
        categoryRepository.deleteById(id);
    }
}
