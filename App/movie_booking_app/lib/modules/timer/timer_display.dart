import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/modules/timer/timer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimerDisplay extends StatefulWidget {
  const TimerDisplay({super.key});

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: TimerController.timerStream,
        initialData: TimerController.remainingSeconds,
        builder: (context, snapshot) {
          return Text(
            snapshot.connectionState == ConnectionState.active
                ? '${snapshot.data}s'
                : '...',
            style: AppStyle.timerText,
          );
        });
  }
}

class TimmerWidget {
  static Widget timerDocked(context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Tooltip(
            message: AppLocalizations.of(context)!.hold_message,
            child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.time,
                      style: AppStyle.timerText,
                    ),
                    const TimerDisplay(),
                  ],
                ))),
      ],
    );
  }
}
