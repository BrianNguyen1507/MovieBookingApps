import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';

Widget detailTitle(String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Row(
      children: [
        Column(
          children: [
            Text(
              title,
              style: (AppStyle.detailTitle),
            ),
            Text(
              value,
              style: (AppStyle.detailText),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ],
    ),
  );
}

Widget infMovie(String title, String value) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppStyle.bodyText1),
        const Divider(
          color: Colors.grey,
          thickness: 0.35,
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: AppFontSize.small, color: AppColors.grayTextColor),
        ),
      ]),
    ),
  );
}

Widget releaseBox(bool detail) {
  return Container(
    padding: const EdgeInsets.all(3.0),
    margin: const EdgeInsets.all(3.0),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      border: Border.all(
        color: detail ? AppColors.primaryColor : AppColors.secondaryColor,
        width: 2.0,
      ),
    ),
    child: Text(
      Appdata.getReleased(detail),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: detail ? AppColors.primaryColor : AppColors.secondaryColor,
      ),
    ),
  );
}
