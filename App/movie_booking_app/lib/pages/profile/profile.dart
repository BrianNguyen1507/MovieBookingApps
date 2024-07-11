import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/svgString.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/profile/components/mylist.dart';
import 'package:movie_booking_app/pages/profile/guest.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:movie_booking_app/pages/profile/components/button.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ValidInput valid = ValidInput();
  String? avatar;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    Preferences pref = Preferences();
    avatar = await pref.getAvatar();
  }

  @override
  Widget build(BuildContext context) {
    Preferences pref = Preferences();
    return FutureBuilder<String?>(
      future: pref.getUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            extendBody: true,
            body: Center(
              child: loadingContent,
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
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 50),
                  ),
                  Builditem.buildSliverList(context),
                  BuildButton.commonbutton(
                      context,
                      'Log out',
                      () => valid.showAlertCustom(
                          context,
                          'Are you sure to logout?',
                          'Yes, logout',
                          true,
                          () => _onPressLogout(context))),
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
                        color: AppColors.backgroundColor,
                        shape: BoxShape.circle),
                    padding: const EdgeInsets.all(5.0),
                    child: ClipOval(
                      child: (avatar ?? "") == ""
                          ? Image.asset(
                              'assets/images/avatarDefault.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.memory(
                              ConverterUnit.base64ToUnit8(avatar!),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
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
                  SizedBox(
                    child: Padding(
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
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.iconThemeColor,
                                  ),
                                  child: SvgPicture.string(
                                    svgTv,
                                    width: 30,
                                    height: 30,
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
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.iconThemeColor,
                                    ),
                                    child: SvgPicture.string(
                                      svgReview,
                                      width: 30,
                                      height: 30,
                                    )),
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
    Preferences pref = Preferences();
    Provider.of<UserProvider>(context, listen: false).logout();
    pref.removeSinginInfo();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> reloadData() async {
    getData();
  }
}
