package com.lepham.cinema.dto.response;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class VoucherResponse {
    long id;
    String title;
    String content;
    int typeDiscount;
    double minLimit;
    double discount;
    int quantity;
    String expired;
}
