import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';

typedef OnPress = void Function();

class BuildButton {
  static Widget commonbutton(
      BuildContext context, String text, OnPress onPress) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: 350.0,
          height: 50.0,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.buttonColor),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: onPress,
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.iconThemeColor,
                fontSize: AppFontSize.small,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
