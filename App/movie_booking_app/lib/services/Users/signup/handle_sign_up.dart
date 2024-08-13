import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/models/user/user.dart';
import 'package:movie_booking_app/pages/forgot-password/reset_password.dart';
import 'package:movie_booking_app/pages/sign-in-up/otp_pages.dart';
import 'package:movie_booking_app/services/Users/signup/sign_up_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/services/Users/signup/valid_handle.dart';
import 'package:movie_booking_app/utils/dialog/show_dialog.dart';

class HandleSignupState {
  ValidInput valid = ValidInput();

  Future<void> validSignUp(context, String email, String password, String name,
      String gender, String phone, String dob) async {
    if (email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        gender.isEmpty ||
        phone.isEmpty ||
        dob.isEmpty) {
      valid.showMessage(context, AppLocalizations.of(context)!.code_1016,
          AppColors.errorColor);
      return;
    }

    final user = User(
        email: email,
        password: password,
        fullName: name,
        gender: gender,
        phoneNumber: phone,
        dayOfBirth: dob);

    ShowDialog.showLoadingDialog(context);
    final signup = await SignUpService.signup(context, user);
    Navigator.of(context).pop();
    if (signup) {
      valid.showMessage(context, AppLocalizations.of(context)!.sign_up_success,
          AppColors.correctColor);
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
    ShowDialog.showLoadingDialog(context);
    final result = await OTPService.otpService(email, otp,method);
    if (result != true) {
      valid.showMessage(context, AppLocalizations.of(context)!.code_1010,
          AppColors.errorColor);
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pop();
    valid.showMessage(context, AppLocalizations.of(context)!.active_success,
        AppColors.correctColor);
    if (method == AppStringMethod.register) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ResetPassword(email: email, otp: otp)));
    }
  }
}
