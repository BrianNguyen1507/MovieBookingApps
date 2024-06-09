package com.lepham.cinema.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@NonNull
public class OTPRequest {
    String email;
    String otp;
}
