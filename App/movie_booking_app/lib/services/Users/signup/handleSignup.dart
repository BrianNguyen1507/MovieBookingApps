import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/models/user/user.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/sign-in-up/otp_pages.dart';
import 'package:movie_booking_app/pages/sign-in-up/resetPassword.dart';
import 'package:movie_booking_app/services/Users/signUp/signUpService.dart';

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

class ValidInput {
  bool isValidEmail(String email, BuildContext context) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    showMessage(context, 'Please enter a valid email', AppColors.errorColor);
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password, BuildContext context) {
    RegExp passwordRegex = RegExp(r'^.{6,50}$');
    showMessage(context, 'Please enter a valid password', AppColors.errorColor);
    return passwordRegex.hasMatch(password);
  }

  bool checkRepassword(
      String password, String repassword, BuildContext context) {
    if (password != repassword) {
      return false;
    }
    return true;
  }

  String isValidGender(String gender) {
    return gender == '0' ? 'Nam' : 'Nữ';
  }

  void showMessage(BuildContext context, String message, Color colors) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 1.0),
                  child: Text(
                    message,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSize.small),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: colors,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void showAlertCustom(
    BuildContext context,
    String content,
    String buttonText,
    VoidCallback onPress,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: onPress,
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }
}
