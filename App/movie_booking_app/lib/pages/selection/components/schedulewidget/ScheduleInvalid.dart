import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/constant/svgString.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget scheduleInvalid(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: SvgPicture.string(svgError),
        ),
        Container(
          width: AppSize.width(context),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.error_schedule,
                  style: AppStyle.thinText,
                ),
                Text(
                  AppLocalizations.of(context)!.error_schedule_bonus,
                  style: AppStyle.smallText,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
