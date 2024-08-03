import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';

class Common {
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static customAppbar(context, TextStyle? appbarStyle, String title,
      Color color, Color? bgcolor) {
    return AppBar(
      backgroundColor: bgcolor ?? AppColors.containerColor,
      centerTitle: true,
      title: Text(title, style: appbarStyle ?? AppStyle.headline1),
      automaticallyImplyLeading: false,
      leading: leadingArrowPop(context, color),
    );
  }

  static leadingArrowPop(context, Color? color) {
    return IconButton(
      icon:
          Icon(Icons.arrow_back_ios, color: color ?? AppColors.iconThemeColor),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
