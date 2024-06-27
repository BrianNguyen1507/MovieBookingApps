import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
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
          child: Text(
        'Hi! WelCome to Movie Booking App',
        style: AppStyle.commonblueText,
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
