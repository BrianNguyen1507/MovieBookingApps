import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
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
          child: SvgPicture.asset('assets/svg/fail.svg'),
        ),
        Container(
          width: AppSize.width(context),
          decoration: BoxDecoration(borderRadius: ContainerRadius.radius12),
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
