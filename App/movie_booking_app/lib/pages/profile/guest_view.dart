import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/pages/profile/components/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GuestPage extends StatelessWidget {
  const GuestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
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
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: AppColors.iconThemeColor,
                              shape: BoxShape.circle),
                          child: ClipOval(
                              child: Image.asset(
                            'assets/images/avatarDefault.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          BuildButton.commonbutton(
              context,
              AppLocalizations.of(context)!.logout_noti,
              () => _onPressSignIn(context)),
        ],
      ),
    );
  }
}

void _onPressSignIn(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/login');
}
