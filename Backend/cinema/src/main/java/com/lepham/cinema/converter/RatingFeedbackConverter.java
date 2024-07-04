package com.lepham.cinema.converter;

import com.lepham.cinema.dto.request.RatingFeedbackRequest;
import com.lepham.cinema.dto.response.RatingFeedbackResponse;
import com.lepham.cinema.entity.RatingFeedbackEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface RatingFeedbackConverter {
    RatingFeedbackEntity toEntity(RatingFeedbackRequest request);
    RatingFeedbackResponse toResponse(RatingFeedbackEntity entity);
}
