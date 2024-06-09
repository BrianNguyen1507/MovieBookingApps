import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/pages/profile/components/mylist.dart';
import 'package:movie_booking_app/pages/profile/guest.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:movie_booking_app/pages/profile/components/button.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Preferences pref = Preferences();
    return FutureBuilder<String?>(
      future: pref.getUserEmail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            extendBody: true,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.data == null) {
            return const GuestPage();
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              extendBody: true,
              body: CustomScrollView(
                slivers: <Widget>[
                  _buildSliverProfileBar(context, snapshot.data),
                  Builditem.buildSliverList(context),
                  BuildButton.commonbutton(
                      context, 'Log out', () => _onPressLogout(context)),
                ],
              ),
            );
          }
        }
      },
    );
  }

  Widget _buildSliverProfileBar(BuildContext context, String? userEmail) {
    String? email = userEmail;
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      expandedHeight: 270.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0),
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
                        color: AppColors.backgroundColor,
                        shape: BoxShape.circle),
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: AppColors.commonColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        AppIcon.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    email!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: AppFontSize.medium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.commonLightColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.iconThemeColor,
                                ),
                                child: Icon(
                                  AppIcon.watchedMovie,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const Text(
                                '0',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppFontSize.medium),
                              ),
                              Text(
                                AppLocalizations.of(context)!.watched,
                                style: const TextStyle(
                                    fontSize: AppFontSize.small,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.iconThemeColor,
                                ),
                                child: Icon(
                                  AppIcon.reviews,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const Text(
                                '0',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppFontSize.medium),
                              ),
                              Text(
                                AppLocalizations.of(context)!.revw,
                                style: const TextStyle(
                                    fontSize: AppFontSize.small,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressLogout(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false).logout();
    Navigator.pushReplacementNamed(context, '/login');
  }
}