import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/index/index.dart';
import 'package:movie_booking_app/services/Users/refresh/token_manager.dart';
import 'package:movie_booking_app/services/Users/signIn/sign_in_service.dart';
import 'package:movie_booking_app/services/Users/signup/valid_handle.dart';

class HandleSigninState {
  bool _isSubmitting = false;
  ValidInput valid = ValidInput();

  Future<bool> validSignIn(
    context,
    String email,
    String password,
  ) async {
    if (_isSubmitting) return false;

    if (email.isEmpty || password.isEmpty) {
      valid.showMessage(
          context, 'Email & password cannot be empty', AppColors.errorColor);
      return false;
    }

    _isSubmitting = true;
    showLoadingDialog(context);
    final result = await SignInService.signin(context, email, password);
    Navigator.of(context).pop();
    if (result != true) {
      valid.showMessage(
          context, 'invalid email or password', AppColors.errorColor);
      _isSubmitting = false;
      return false;
    }

    TokenManager.startTokenRefreshTimer(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const IndexPage(initialIndex: 1),
      ),
    );
    _isSubmitting = false;

    return true;
  }
}
