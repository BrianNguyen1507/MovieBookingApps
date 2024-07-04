package com.lepham.cinema.controller;

import com.lepham.cinema.dto.request.RatingFeedbackRequest;
import com.lepham.cinema.dto.response.APIResponse;
import com.lepham.cinema.dto.response.RatingFeedbackResponse;
import com.lepham.cinema.service.imp.RatingFeedBackService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("cinema")
@Slf4j
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class RatingFeedbackController {

    RatingFeedBackService ratingFeedBackService;

    @PostMapping(value = "/createRatingFeedBack")
    APIResponse<RatingFeedbackResponse> createRatingFeedBack(@RequestParam("orderId") long orderId, @RequestBody RatingFeedbackRequest request){
        return APIResponse.<RatingFeedbackResponse>builder()
                .result(ratingFeedBackService.creatingRatingFeedback(request,orderId))
                .build();
    }
}
