import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';

final loadingContent = SpinKitSquareCircle(
  size: 60.0,
  itemBuilder: (BuildContext context, int index) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
      ),
    );
  },
);

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.backgroundColor.withOpacity(0.5),
        content: SizedBox(
          height: AppSize.height(context) / 3,
          width: AppSize.height(context) / 2,
          child: loadingContent,
        ),
      );
    },
  );
}
