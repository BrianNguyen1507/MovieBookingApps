import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';

class AppStyle {
  //payments
  static const TextStyle paymentInfoText = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontSize: AppFontSize.small,
    color: AppColors.primaryColor,
  );
  //order
  static const TextStyle graySmallText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.small,
    color: AppColors.grayTextColor,
  );
  static const TextStyle titleOrder = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.small,
    fontWeight: FontWeight.bold,
    color: AppColors.darktextColor,
  );
  //store
  static const TextStyle priceText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.small,
    fontWeight: FontWeight.bold,
    color: AppColors.darktextColor,
  );
  //seat
  static const TextStyle seatText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.superSmall,
    color: AppColors.textSeat,
  );
  //seat
  static const TextStyle screenText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.small,
    color: AppColors.textSeat,
  );
  //theater
  static const TextStyle titleTheater = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.small,
    fontWeight: FontWeight.bold,
    color: AppColors.darktextColor,
  );
  static const TextStyle timerText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.verySmall,
    fontWeight: FontWeight.bold,
    color: AppColors.lightTextColor,
  );
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
    color: AppColors.lightTextColor,
    overflow: TextOverflow.ellipsis,
  );
//detail
  static const TextStyle headline1 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.medium,
    fontWeight: FontWeight.bold,
    color: AppColors.darktextColor,
  );
  static const TextStyle headline2 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: AppFontSize.medium,
    fontWeight: FontWeight.bold,
    color: AppColors.lightTextColor,
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
