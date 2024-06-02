package com.lepham.cinema.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.Date;
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
    @Column(name = "avatar")
    byte[] avatar;
    @Column(name = "full_name")
    String fullName;
    @Column(name = "phone")
    String phone;
    @Column(name = "gender")
    String gender;
    @Column(name = "day_of_birth")
    Date dayOfBirth;
    @Column(name = "email")
    String email;
    @Column(name = "password")
    String password;
    @Column(name="role")
    String role;
    @Column(name = "one_time_password")
    String otp;
    @Column(name = "otp_request_time")
    Date otpRequestTime;
    @Column(name = "active")
    int active;

    @OneToMany(mappedBy = "account", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    List<OrderEntity> orders;

    @ManyToMany(fetch = FetchType.LAZY,mappedBy = "accounts")
    List<VoucherEntity> vouchers;

}
