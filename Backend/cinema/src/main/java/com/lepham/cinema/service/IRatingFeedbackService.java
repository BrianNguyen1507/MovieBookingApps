package com.lepham.cinema.service;

import com.lepham.cinema.dto.request.RatingFeedbackRequest;
import com.lepham.cinema.dto.response.RatingFeedbackResponse;

import java.util.List;

public interface IRatingFeedbackService {
    RatingFeedbackResponse creatingRatingFeedback(RatingFeedbackRequest request, long orderId);
    List<RatingFeedbackResponse> getAllRatingFeedback(long id);
}
