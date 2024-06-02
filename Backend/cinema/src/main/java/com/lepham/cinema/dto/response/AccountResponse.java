package com.lepham.cinema.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class AccountResponse {
    String fullName;
    String phoneNumber;
    String gender;
    String email;
    String dayOfBirth;
    String role;
    int active;
}
