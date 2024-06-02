import 'package:flutter/material.dart';

import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/pages/profile/components/mylist.dart';
import 'package:movie_booking_app/pages/profile/components/button.dart';

class GuestPage extends StatelessWidget {
  const GuestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: CustomScrollView(
        slivers: <Widget>[
          _buildSliverProfileBar(context),
          Builditem.buildSliverList(context),
          BuildButton.commonbutton(context, 'Continue Sign in or Sign up',
              () => _onPressSignIn(context)),
        ],
      ),
    );
  }

  Widget _buildSliverProfileBar(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: const Center(
          child: Column(
        children: [
          Text(
            "WELCOME TO",
            style: TextStyle(
                color: AppColors.darktextColor,
                fontWeight: FontWeight.bold,
                fontSize: AppFontSize.medium),
          ),
          Text(
            "MOVIE BOOKING APP",
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )),
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Container(
              color: Colors.black,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _onPressSignIn(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/login');
}
