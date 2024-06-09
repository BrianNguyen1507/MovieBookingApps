package com.lepham.cinema.dto.request;

import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@NonNull
public class VoucherRequest {
    String title;
    String content;
    int typeDiscount;
    double minLimit;
    double discount;
    int quantity;
    String expired;
}
