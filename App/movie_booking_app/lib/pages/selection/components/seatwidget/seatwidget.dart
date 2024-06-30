import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';

Widget seatStateList() {
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
            const Text(
              'Available',
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
            const Text(
              'Selected',
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
            const Text(
              'Sold',
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
            const Text(
              'Pending',
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
            const Text(
              'Disable',
              style: AppStyle.seatText,
            ),
          ],
        ),
      ],
    ),
  );
}
