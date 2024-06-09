package com.lepham.cinema.api;

import com.lepham.cinema.dto.request.CategoryRequest;
import com.lepham.cinema.dto.response.CategoryResponse;
import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.service.imp.CategoryService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/cinema")
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class CategoryAPI {

    CategoryService categoryService;

    @GetMapping(value = "/getAllCategory")
    APIResponse<List<CategoryResponse>> getAllCategory(){
        var authentication = SecurityContextHolder.getContext().getAuthentication();
        String role = authentication.getAuthorities().toString();
        return APIResponse.<List<CategoryResponse>>builder()
                .result(categoryService.getAllCategory())
                .build();
    }

    @PostMapping(value = "/addCategory")
    APIResponse<CategoryResponse> create(@RequestBody CategoryRequest request){
        return APIResponse.<CategoryResponse>builder()
                .result(categoryService.create(request))
                .build();
    }

    @PutMapping(value = "/updateCategory")
    APIResponse<CategoryResponse> update(@RequestBody CategoryRequest request){
        return APIResponse.<CategoryResponse>builder()
                .result(categoryService.update(request))
                .build();
    }

    @DeleteMapping(value = "/deleteCategory")
    APIResponse<?> delete(@RequestParam("id") long id){
        categoryService.delete(id);
        return APIResponse.builder()
                .message("Delete successful")
                .build();
    }
}