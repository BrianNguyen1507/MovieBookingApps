package com.lepham.cinema.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.lepham.cinema.validator.IntegerConstraint;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class RatingFeedbackResponse {
    String comment;
    int rating;
    @JsonFormat(pattern = "HH:mm dd-MM-yyyy")
    LocalDateTime datetime;
    String fullName;
    byte[] avatar;
}
