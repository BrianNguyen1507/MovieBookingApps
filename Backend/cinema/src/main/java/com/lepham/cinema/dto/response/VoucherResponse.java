package com.lepham.cinema.dto.response;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.lepham.cinema.validator.CustomDoubleSerializer;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

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
    LocalDate expired;
    boolean allow;
}       
