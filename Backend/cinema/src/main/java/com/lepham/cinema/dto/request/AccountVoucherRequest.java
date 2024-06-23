package com.lepham.cinema.dto.request;

import com.lepham.cinema.validator.DurationConstraint;
import com.lepham.cinema.validator.IntegerConstraint;
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
public class AccountVoucherRequest {
    @IntegerConstraint()
    int quantity;
    long voucherId;
}
