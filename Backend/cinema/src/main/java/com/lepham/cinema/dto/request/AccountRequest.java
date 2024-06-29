package com.lepham.cinema.dto.request;

import com.lepham.cinema.validator.DobConstraint;
import jakarta.validation.constraints.Size;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@NonNull
public class AccountRequest {
    byte[] avatar;
    String fullName;
    String phoneNumber;
    String gender;
    String email;
    @Size(min = 6,message = "PASSWORD_INVALID")
    String password;

    @DobConstraint(min = 16,message = "INVALID_DOB")
    LocalDate dayOfBirth;

    @Builder.Default
    int active =0;
    @Builder.Default
    String role = "USER";
}
