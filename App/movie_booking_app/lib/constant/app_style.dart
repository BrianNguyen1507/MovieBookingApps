import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_booking_app/constant/app_config.dart';

class AppStyle {
  static final TextStyle smallblackBold = GoogleFonts.roboto(
    fontSize: AppFontSize.superSmall,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 0, 0, 0),
  );
  static final TextStyle blackBold = GoogleFonts.roboto(
    fontSize: AppFontSize.small,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 0, 0, 0),
  );
  static final TextStyle primaryText = GoogleFonts.roboto(
    fontSize: AppFontSize.lowMedium,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );
  //payments
  static final TextStyle paymentInfoText = GoogleFonts.roboto(
    fontWeight: FontWeight.bold,
    fontSize: AppFontSize.small,
    color: AppColors.darktextColor,
  );
  //order
  static final TextStyle graySmallText = GoogleFonts.roboto(
    fontSize: AppFontSize.small,
    color: AppColors.grayTextColor,
  );
  static final TextStyle titleOrder = GoogleFonts.roboto(
    fontSize: AppFontSize.small,
    fontWeight: FontWeight.bold,
    color: AppColors.darktextColor,
  );
  //store
  static final TextStyle priceText = GoogleFonts.roboto(
    fontSize: AppFontSize.small,
    fontWeight: FontWeight.bold,
    color: AppColors.darktextColor,
  );
  //seat
  static final TextStyle seatText = GoogleFonts.roboto(
    fontSize: AppFontSize.superSmall,
    color: AppColors.textSeat,
  );
  //seat
  static final TextStyle screenText = GoogleFonts.roboto(
    fontSize: AppFontSize.small,
    color: AppColors.textSeat,
  );
  //theater
  static final TextStyle titleTheater = GoogleFonts.roboto(
    fontSize: AppFontSize.small,
    fontWeight: FontWeight.bold,
    color: AppColors.darktextColor,
  );
  static final TextStyle timerText = GoogleFonts.roboto(
    fontSize: AppFontSize.verySmall,
    fontWeight: FontWeight.bold,
    color: AppColors.lightTextColor,
  );
//home
  static final TextStyle titleMovie = GoogleFonts.roboto(
    fontSize: AppFontSize.small,
    fontWeight: FontWeight.bold,
    color: AppColors.darktextColor,
  );

  static final TextStyle commonText = GoogleFonts.roboto(
    fontSize: AppFontSize.midMedium,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static final TextStyle commonblueText = GoogleFonts.roboto(
    fontSize: AppFontSize.medium,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );
  static final TextStyle bannerText = GoogleFonts.roboto(
    fontSize: AppFontSize.medium,
    fontWeight: FontWeight.bold,
    color: AppColors.lightTextColor,
  );
//detail
  static final TextStyle headline3 = GoogleFonts.roboto(
    fontSize: AppFontSize.medium,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );
  static final TextStyle headline1 = GoogleFonts.roboto(
    fontSize: AppFontSize.medium,
    fontWeight: FontWeight.bold,
    color: AppColors.darktextColor,
  );
  static final TextStyle headline2 = GoogleFonts.roboto(
    fontSize: AppFontSize.medium,
    fontWeight: FontWeight.bold,
    color: AppColors.lightTextColor,
  );
  static final TextStyle nameMovie = GoogleFonts.roboto(
      fontSize: AppFontSize.medium,
      fontWeight: FontWeight.bold,
      color: AppColors.darktextColor);

  static final TextStyle smallText = GoogleFonts.roboto(
    fontSize: AppFontSize.verySmall,
    color: AppColors.grayTextColor,
  );
  static final TextStyle smallText2123 = GoogleFonts.roboto(
    fontSize: AppFontSize.verySmall,
    color: AppColors.grayTextColor,
  );
  static final TextStyle detailTitle = GoogleFonts.roboto(
    fontSize: AppFontSize.verySmall,
    color: AppColors.grayTextColor,
  );
  static final TextStyle detailText = GoogleFonts.roboto(
    fontSize: AppFontSize.small,
    fontWeight: FontWeight.bold,
    color: AppColors.grayTextColor,
  );
  static final TextStyle buttonText = GoogleFonts.roboto(
    fontSize: AppFontSize.verySmall,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );
  static final TextStyle smalldark = GoogleFonts.roboto(
    fontSize: AppFontSize.verySmall,
    fontWeight: FontWeight.bold,
    color: AppColors.backgroundColor,
  );
  static final TextStyle bodyText1 = GoogleFonts.roboto(
      fontSize: AppFontSize.lowMedium,
      fontWeight: FontWeight.bold,
      color: AppColors.grayTextColor);

  static final TextStyle classifyText = GoogleFonts.roboto(
    fontSize: AppFontSize.verySmall,
    fontWeight: FontWeight.bold,
    color: AppColors.lightTextColor,
  );

  static final TextStyle buttonNavigator = GoogleFonts.roboto(
    fontSize: AppFontSize.medium,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final TextStyle buttonText2 = GoogleFonts.roboto(
    fontSize: AppFontSize.small,
    fontWeight: FontWeight.bold,
    color: AppColors.lightTextColor,
  );
  static final TextStyle thinText = GoogleFonts.roboto(
    fontSize: AppFontSize.lowMedium,
    fontWeight: FontWeight.normal,
    color: AppColors.grayTextColor,
  );
  static final TextStyle showTimeText = GoogleFonts.roboto(
    fontSize: AppFontSize.lowMedium,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 1, 121, 219),
  );
  static final TextStyle mediumBlackText = GoogleFonts.roboto(
    fontSize: AppFontSize.medium,
    fontWeight: FontWeight.bold,
    color: AppColors.darktextColor,
  );
  static final TextStyle bigText = GoogleFonts.roboto(
    fontSize: AppFontSize.midlarge,
    fontWeight: FontWeight.bold,
    color: AppColors.darktextColor,
  );
  static final TextStyle primaryBigText = GoogleFonts.roboto(
    fontSize: AppFontSize.midlarge,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );
}
