package com.lepham.cinema.dto.request;

import jakarta.validation.constraints.Size;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)public class ResetPasswordRequest {
    String email;
    @Size(min = 6,message = "PASSWORD_INVALID")
    String password;
}
