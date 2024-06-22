import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/models/user/user.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/sign-in-up/otp_pages.dart';
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
          builder: (context) => OTPPage(email: email),
        ));
  }

  Future<void> validOTP(BuildContext context, String email, String otp) async {
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
    Navigator.pushReplacementNamed(context, '/login');
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
          content: SizedBox(
            child: Row(
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
                const Spacer(),
                Container(
                  height: 40,
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () =>
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.white)),
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
}
