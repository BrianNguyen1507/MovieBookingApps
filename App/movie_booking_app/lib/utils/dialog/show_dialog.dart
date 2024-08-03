import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowDialog {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor.withOpacity(0.5),
          content: SizedBox(
            height: AppSize.height(context) / 3,
            width: AppSize.height(context) / 2,
            child: loadingContent,
          ),
        );
      },
    );
  }

  static void showAlertCustom(context, String content, String? buttonText,
      bool? cancelButton, VoidCallback? onPress, DialogType type) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.scale,
      title: AppLocalizations.of(context)!.dialog_alert,
      desc: content,
      btnCancelOnPress: cancelButton ?? false ? () {} : null,
      btnOkOnPress: onPress,
      btnOkText: buttonText ?? 'OK',
      btnCancelText: 'Cancel',
    ).show();
  }
}
