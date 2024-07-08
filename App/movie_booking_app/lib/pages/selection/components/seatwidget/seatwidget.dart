import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget seatStateList(BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(3),
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: SeatClass.getSeatColor(0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.seat_available,
              style: AppStyle.seatText,
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(3),
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.seat_selected,
              style: AppStyle.seatText,
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(3),
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: SeatClass.getSeatColor(1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.seat_sold,
              style: AppStyle.seatText,
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(3),
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: SeatClass.getSeatColor(2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.seat_pending,
              style: AppStyle.seatText,
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(3),
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: SeatClass.getSeatColor(3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.seat_disable,
              style: AppStyle.seatText,
            ),
          ],
        ),
      ],
    ),
  );
}
