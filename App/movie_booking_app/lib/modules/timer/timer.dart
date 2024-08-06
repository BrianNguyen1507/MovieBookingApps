import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/pages/index/index.dart';
import 'package:movie_booking_app/utils/dialog/show_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimerController {
  static Timer? _periodicTimer;
  static Timer? _timer;
  static int remainingSeconds = 0;

  static dynamic timerHoldSeatStart(BuildContext context) {
    const int durationInSeconds = 300;
    remainingSeconds = durationInSeconds;

    _timer = Timer(Duration(seconds: remainingSeconds), () {});

    _periodicTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        print(remainingSeconds);
      } else {
        t.cancel();

        ShowDialog.showAlertCustom(
            context,
            false,
            AppLocalizations.of(context)!.time_end_noti,
            '',
            false,
            null,
            DialogType.warning);
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const IndexPage(initialIndex: 1);
              },
            ),
            (Route<dynamic> route) => false,
          );
        });
      }
    });
  }

  static void timerHoldSeatCancel() {
    _timer?.cancel();
    _periodicTimer?.cancel();
  }
}
