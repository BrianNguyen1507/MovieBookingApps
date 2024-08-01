package com.lepham.cinema.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "account")
public class AccountEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    long id;
    @Column(name = "avatar", length = 17777777)
    byte[] avatar;
    @Column(name = "full_name",nullable = false)
    String fullName;
    @Column(name = "phone",nullable = false)
    String phoneNumber;
    @Column(name = "gender")
    String gender;
    @Column(name = "day_of_birth")
    LocalDate dayOfBirth;
    @Column(name = "email",nullable = false)
    String email;
    @Column(name = "password" ,nullable = false)
    String password;
    @Column(name="role",nullable = false)
    String role;
    @Column(name = "one_time_password")
    String otp;
    @Column(name = "otp_request_time")
    LocalDateTime otpRequestTime;
    @Column(name = "active")
    int active;


    @OneToMany(mappedBy = "account")
    List<AccountVoucherEntity> vouchers;

}
