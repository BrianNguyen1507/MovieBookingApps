import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/models/user/user.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/sign-in-up/otp_pages.dart';
import 'package:movie_booking_app/pages/sign-in-up/reset_password.dart';
import 'package:movie_booking_app/services/Users/signup/sign_up_service.dart';

import 'package:movie_booking_app/services/Users/signup/valid_handle.dart';

class HandleSignupState {
  ValidInput valid = ValidInput();

  Future<void> validSignUp(context, String email, String password, String name,
      String gender, String phone, String dob) async {
    final user = User(
        email: email,
        password: password,
        fullName: name,
        gender: gender,
        phoneNumber: phone,
        dayOfBirth: dob);

    showLoadingDialog(context);
    final signup = await SignUpService.signup(context, user);
    Navigator.of(context).pop();
    if (signup) {
      valid.showMessage(context, 'Sign up successful!', AppColors.correctColor);
      Future.delayed(const Duration(seconds: 1)).then((_) {});
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OTPPage(email: email, method: AppStringMethod.register),
        ),
      );
    }
  }

  Future<void> validOTP(
      context, String email, String otp, String method) async {
    showLoadingDialog(context);
    final result = await OTPService.otpService(email, otp);
    if (result != true) {
      valid.showMessage(context, "Invalid OTP", AppColors.errorColor);
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pop();
    valid.showMessage(
        context, 'Activation successful!', AppColors.correctColor);
    if (method == AppStringMethod.register) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ResetPassword(email: email)));
    }
  }
}
