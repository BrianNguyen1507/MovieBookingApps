import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/models/user/user.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/sign-in-up/otp_pages.dart';
import 'package:movie_booking_app/pages/sign-in-up/resetPassword.dart';
import 'package:movie_booking_app/services/Users/signUp/signUpService.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';

class HandleSignupState {
  ValidInput valid = ValidInput();

  Future<void> validSignUp(BuildContext context, String email, String password,
      String name, String gender, String phone, String dob) async {
    final user = User(
        email: email.trim(),
        password: password.trim(),
        fullName: name.trim(),
        gender: gender,
        phoneNumber: phone.trim(),
        dayOfBirth: dob.trim());

    showLoadingDialog(context);
    final result = await SignUpService.signup(user);
    if (result == null) {
      valid.showMessage(
          context, 'Invalid Sign up, Please try again.', AppColors.errorColor);
      return;
    }
    Navigator.of(context).pop();
    if (result != true) {
      valid.showMessage(context, result, AppColors.errorColor);
      return;
    }

    valid.showMessage(context, 'Sign up successful!', AppColors.correctColor);
    Future.delayed(const Duration(seconds: 1)).then((_) {});
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OTPPage(email: email, method: AppStringMethod.register),
        ));
  }

  Future<void> validOTP(
      BuildContext context, String email, String otp, String method) async {
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
