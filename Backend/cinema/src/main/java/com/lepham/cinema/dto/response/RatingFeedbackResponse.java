package com.lepham.cinema.dto.response;

import com.lepham.cinema.validator.IntegerConstraint;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class RatingFeedbackResponse {

    String comment;
    int rating;
}
