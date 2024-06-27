import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';

Widget buttonDrawer(
    BuildContext context, IconData icon, String titleText, Widget pages) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => pages,
          ));
    },
    child: Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.0,
            color: AppColors.commonColor,
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              titleText,
              style: AppStyle.bodyText1,
            ),
          ),
        ],
      ),
    ),
  );
}
