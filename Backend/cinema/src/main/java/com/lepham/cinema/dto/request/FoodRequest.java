package com.lepham.cinema.dto.request;

import com.lepham.cinema.validator.PriceConstraint;
import com.lepham.cinema.validator.StringConstraint;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FoodRequest {
    long id;
    @StringConstraint()
    String name;
    @PriceConstraint
    double price;
    byte[] image;
}
