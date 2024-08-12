import 'dart:async';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:movie_booking_app/pages/index/index.dart';
import 'package:movie_booking_app/utils/dialog/show_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimerController {
  static Timer? _periodicTimer;
  static Timer? _timer;
  static int remainingSeconds = 0;
  static StreamController<int> _streamController =
      StreamController<int>.broadcast();

  static Stream<int> get timerStream => _streamController.stream;

  static void timerHoldSeatStart(BuildContext context) {
    const int durationInSeconds = 300;
    remainingSeconds = durationInSeconds;

    if (_streamController.isClosed) {
      _streamController = StreamController<int>.broadcast();
    }

    _timer = Timer(Duration(seconds: remainingSeconds), () {});

    _periodicTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        if (!_streamController.isClosed) {
          _streamController.add(remainingSeconds);
        }
      } else {
        t.cancel();
        if (!_streamController.isClosed) {
          _streamController.add(remainingSeconds);
          _streamController.close();
        }

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
    if (!_streamController.isClosed) {
      _streamController.close();
    }
  }
}
