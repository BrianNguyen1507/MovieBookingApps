import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/services/Users/signup/valid_handle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowMessage {
  static void noNetworkConnection(BuildContext context) {
    ValidInput().showMessage(context, AppLocalizations.of(context)!.no_internet,
        AppColors.errorColor);
  }

  static void unExpectedError(BuildContext context) {
    ValidInput().showMessage(context,
        AppLocalizations.of(context)!.error_message, AppColors.errorColor);
  }

  static void ratingSuccess(BuildContext context) {
    ValidInput().showMessage(context,
        AppLocalizations.of(context)!.rating_success, AppColors.correctColor);
  }
}
