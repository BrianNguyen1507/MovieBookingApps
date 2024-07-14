import 'package:flutter/material.dart';
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
          BuildButton.commonbutton(context, 'Continue Sign in or Sign up',
              () => _onPressSignIn(context)),
        ],
      ),
    );
  }
}

void _onPressSignIn(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/login');
}
