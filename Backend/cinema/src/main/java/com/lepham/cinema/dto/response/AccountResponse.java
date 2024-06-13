package com.lepham.cinema.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class AccountResponse {
    String fullName;
    String phoneNumber;
    String gender;
    String email;
    LocalDate dayOfBirth;
    String role;
    int active;
}
