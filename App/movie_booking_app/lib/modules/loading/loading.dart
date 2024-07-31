import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_data.dart';

final loadingContent = SpinKitSquareCircle(
  size: 60.0,
  itemBuilder: (context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: ContainerRadius.radius5,
        color: AppColors.primaryColor,
      ),
    );
  },
);
final progressLoading = SpinKitThreeBounce(
  size: 40.0,
  itemBuilder: (context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: ContainerRadius.radius100,
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

Widget loadingData(BuildContext context) {
  return AlertDialog(
    backgroundColor: AppColors.backgroundColor.withOpacity(0.5),
    content: SizedBox(
      height: AppSize.height(context) / 3,
      width: AppSize.height(context) / 2,
      child: loadingContent,
    ),
  );
}
