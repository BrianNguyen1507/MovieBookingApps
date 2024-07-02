import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/pages/index/index.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';

class TimerController {
  static Timer? _periodicTimer;
  static Timer? _timer;
  static int remainingSeconds = 0;

  static dynamic timerHoldSeatStart(int scheduleId, Set<String> selectedSeats,
      BuildContext context, bool isReturned) {
    const int durationInSeconds = 999;
    remainingSeconds = durationInSeconds;

    _timer = Timer(Duration(seconds: remainingSeconds), () {
      isReturned = true;
    });

    _periodicTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (remainingSeconds > 0) {
        remainingSeconds--;

        print('Remaining time: $remainingSeconds seconds');
      } else {
        t.cancel();
        ValidInput val = ValidInput();
        val.showAlertCustom(
          context,
          'Time order is ended. Please try again!',
          '',
          false,
          null,
        );
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
    return isReturned;
  }

  static void timerHoldSeatCancel() {
    _timer?.cancel();
    _periodicTimer?.cancel();
  }
}