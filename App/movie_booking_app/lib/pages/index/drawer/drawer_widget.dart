import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_booking_app/constant/app_style.dart';

Widget buttonDrawer(
    BuildContext context, SvgPicture icon, String titleText, Widget pages) {
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
          icon,
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
