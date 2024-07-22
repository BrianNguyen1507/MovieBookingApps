import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';

class ShowMessage {
  static void noNetworkConnection(BuildContext context) {
    ValidInput().showMessage(
        context,
        "No network connection. Please check your internet.",
        AppColors.errorColor);
  }

  static void unExpectedError(BuildContext context) {
    ValidInput().showMessage(
        context,
        "An unexpected error occurred. Please try again.",
        AppColors.errorColor);
  }

  static void ratingSuccess(BuildContext context) {
    ValidInput().showMessage(context, 'Rating feedBack successful! Thanks you',
        AppColors.correctColor);
  }
}
