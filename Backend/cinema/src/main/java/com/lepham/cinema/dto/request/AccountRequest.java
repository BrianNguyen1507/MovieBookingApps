package com.lepham.cinema.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class AccountRequest {
    String fullName;
    String phoneNumber;
    String gender;
    String email;
    String password;
    String dayOfBirth;

    @Builder.Default
    int active =0;
    @Builder.Default
    String role = "USER";
}
