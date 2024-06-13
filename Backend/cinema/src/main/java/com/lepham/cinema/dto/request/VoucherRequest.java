package com.lepham.cinema.dto.request;

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
    @StringConstraint(message = "STRING_IS_EMPTY")
    String title;
    @StringConstraint(message = "STRING_IS_EMPTY")
    String content;
    int typeDiscount;
    double minLimit;
    double discount;
    int quantity;
    LocalDate expired;
}
