import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';

class ValidInput {
  bool isValidEmail(String email, context) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    showMessage(context, 'Please enter a valid email', AppColors.errorColor);
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password, BuildContext context) {
    RegExp passwordRegex = RegExp(r'^.{6,50}$');
    showMessage(context, 'Please enter a valid password', AppColors.errorColor);
    return passwordRegex.hasMatch(password);
  }

  bool checkRepassword(String password, String repassword, context) {
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 1.0),
                    child: SizedBox(
                      width: AppSize.width(context) * 0.7,
                      child: Text(
                        message,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSize.small),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: colors,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void showAlertCustom(
    context,
    String content,
    String? buttonText,
    bool? cancelButton,
    VoidCallback? onPress,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(content),
          actions: <Widget>[
            cancelButton!
                ? TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                : const SizedBox.shrink(),
            TextButton(
              onPressed: onPress,
              child: Text(buttonText!),
            ),
          ],
        );
      },
    );
  }
}
