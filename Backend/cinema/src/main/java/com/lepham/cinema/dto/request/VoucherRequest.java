package com.lepham.cinema.dto.request;

import com.lepham.cinema.validator.DateConstraint;
import com.lepham.cinema.validator.IntegerConstraint;
import com.lepham.cinema.validator.PriceConstraint;
import com.lepham.cinema.validator.StringConstraint;
import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@NonNull
public class VoucherRequest {
    @StringConstraint()
    String title;
    @StringConstraint()
    String content;

    int typeDiscount;
    @PriceConstraint
    double minLimit;

    double discount;

    @IntegerConstraint()
    int quantity;

    @DateConstraint()
    LocalDate expired;
}
