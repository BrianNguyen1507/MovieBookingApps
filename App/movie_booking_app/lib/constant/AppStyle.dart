import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';

class AppStyle {
//home
  static const TextStyle titleMovie = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.lowMedium,
    fontWeight: FontWeight.bold,
    color: AppColors.darktextColor,
  );

  static const TextStyle commonText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.midMedium,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const TextStyle commonblueText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.medium,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );
  static const TextStyle bannerText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.medium,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
    overflow: TextOverflow.ellipsis,
  );
//detail
  static const TextStyle headline1 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.medium,
    fontWeight: FontWeight.bold,
    color: AppColors.darktextColor,
  );

  static const TextStyle nameMovie = TextStyle(
      fontFamily: 'Roboto',
      fontSize: AppFontSize.medium,
      fontWeight: FontWeight.bold,
      color: AppColors.darktextColor);

  static const TextStyle smallText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.verySmall,
    color: AppColors.grayTextColor,
  );

  static const TextStyle detailTitle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.verySmall,
    color: AppColors.grayTextColor,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle detailText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.small,
    fontWeight: FontWeight.bold,
    color: AppColors.grayTextColor,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle buttonText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.verySmall,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle bodyText1 = TextStyle(
      fontFamily: 'Roboto',
      fontSize: AppFontSize.lowMedium,
      fontWeight: FontWeight.bold,
      color: AppColors.grayTextColor);

  static const TextStyle classifyText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.verySmall,
    fontWeight: FontWeight.bold,
    color: AppColors.lightTextColor,
  );

  static const TextStyle buttonNavigator = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.medium,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle buttonText2 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.small,
    fontWeight: FontWeight.bold,
    color: AppColors.lightTextColor,
  );
}
