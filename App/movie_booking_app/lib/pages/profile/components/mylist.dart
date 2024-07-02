import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/pages/ordered/listOrdered.dart';
import 'package:movie_booking_app/pages/profile/informationChoice.dart';

class Builditem {
  static Widget buildSliverList(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          switch (index) {
            case 0:
              return buildListItem(
                context,
                text: 'Information',
                onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const InformationChoice()));
                },
              );
            case 1:
              return buildListItem(
                context,
                text: 'My Details 2',
                onPressed: ()  {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ListOrdered()));
                },
              );

            default:
              return Container();
          }
        },
        childCount: 10,
      ),
    );
  }

  static Widget buildListItem(BuildContext context,
      {required String text, required VoidCallback onPressed}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
            color: Colors.white,
            height: 50,
            width: double.infinity,
            child: GestureDetector(
              onTap: onPressed,
              child: Row(
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: Color(0xFF181725),
                      fontSize: AppFontSize.small,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  IconButton(
                    onPressed: onPressed,
                    icon: Icon(AppIcon.arrowR),
                    iconSize: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          color: const Color(0xFFE2E2E2),
          height: 1,
          width: double.infinity,
          child: const SizedBox(),
        ),
      ],
    );
  }

  static Widget buildGuestSite(BuildContext context,
      {required String text, required VoidCallback onPressed}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
            color: Colors.white,
            height: 50,
            width: double.infinity,
            child: GestureDetector(
              onTap: onPressed,
              child: Row(
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: Color(0xFF181725),
                      fontSize: AppFontSize.small,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  IconButton(
                    onPressed: onPressed,
                    icon: Icon(AppIcon.arrowR),
                    iconSize: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          color: const Color(0xFFE2E2E2),
          height: 1,
          width: double.infinity,
          child: const SizedBox(),
        ),
      ],
    );
  }
}
