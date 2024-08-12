package com.lepham.cinema.controller;

import com.lepham.cinema.dto.request.RatingFeedbackRequest;
import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.dto.response.RatingFeedbackResponse;
import com.lepham.cinema.service.imp.RatingFeedBackService;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("cinema")
@Slf4j
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class RatingFeedbackController {

    RatingFeedBackService ratingFeedBackService;

    @PostMapping(value = "/createRatingFeedBack")
    APIResponse<RatingFeedbackResponse> createRatingFeedBack(@RequestParam("orderId") long orderId,@Valid @RequestBody RatingFeedbackRequest request){
        return APIResponse.<RatingFeedbackResponse>builder()
                .result(ratingFeedBackService.creatingRatingFeedback(request,orderId))
                .build();
    }

    @GetMapping(value = "/getAllRatingFeedback")
    APIResponse<List<RatingFeedbackResponse>> getAllRatingFeedback(@RequestParam("filmId")long filmId){
    return APIResponse.<List<RatingFeedbackResponse>>builder()
            .result(ratingFeedBackService.getAllRatingFeedback(filmId))
            .build();
    }

    @GetMapping(value = "/getNumberOfReviews")
    APIResponse<Integer> getNumberOfReviews(){
        return APIResponse.<Integer>builder()
                .result(ratingFeedBackService.getNumberOfReviews())
                .build();
    }
}
