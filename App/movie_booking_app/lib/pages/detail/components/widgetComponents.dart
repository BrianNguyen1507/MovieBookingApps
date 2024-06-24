import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';

Widget detailTitle(String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: AppColors.commonDarkColor),
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: AppFontSize.small, color: AppColors.grayTextColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
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
        Text(
          title,
          style: const TextStyle(
              fontSize: AppFontSize.lowMedium,
              fontWeight: FontWeight.bold,
              color: AppColors.darktextColor),
        ),
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
