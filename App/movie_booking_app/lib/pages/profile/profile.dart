import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/profile/components/mylist.dart';
import 'package:movie_booking_app/pages/profile/guest.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:movie_booking_app/pages/profile/components/button.dart';
import 'package:movie_booking_app/services/Users/ordered/getOrderInfo.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ValidInput valid = ValidInput();
  Preferences pref = Preferences();
  int numMovies = 0;
  int numReviews = 0;
  String? avatar;
  String? userName = 'Guest';
  dynamic token;
  bool _dataFetched = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    token = await pref.getTokenUsers();
    if (token == null) {
      setState(() {
        _dataFetched = true;
        userName = null;
      });
      return;
    }

    String? getuserName = await pref.getUserName();
    String? getavatar = await pref.getAvatar();
    int numberMovie = await GetOrderInfo.accountNumberMovieInfo();
    int numberReview = await GetOrderInfo.accountNumberReviewInfo();

    if (mounted) {
      setState(() {
        numReviews = numberReview;
        numMovies = numberMovie;
        userName = getuserName;
        avatar = getavatar;
        _dataFetched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_dataFetched) {
      return progressLoading;
    }
    if (token == null && userName == null) {
      return const GuestPage();
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        body: CustomScrollView(
          slivers: <Widget>[
            _buildSliverProfileBar(context, userName!, numMovies, numReviews),
            Builditem.buildSliverList(context),
            BuildButton.commonbutton(
                context,
                AppLocalizations.of(context)!.logout,
                () => valid.showAlertCustom(context, 'Are you sure to logout?',
                    'Yes, logout', true, () => _onPressLogout(context))),
          ],
        ),
      );
    }
  }

  Widget _buildSliverProfileBar(BuildContext context, String userEmail,
      int? numberMovie, int? numberReview) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.containerColor,
      expandedHeight: 250.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.containerColor),
                    child: (avatar ?? "") == ""
                        ? ClipOval(
                            child: Image.asset(
                              'assets/images/avatarDefault.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipOval(
                            child: Image.memory(
                              ConverterUnit.base64ToUnit8(avatar!),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Text(
                    userEmail,
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
                        decoration: BoxDecoration(
                          color: AppColors.commonLightColor,
                          borderRadius: ContainerRadius.radius20,
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
                                  child: SvgPicture.asset(
                                    'assets/svg/ticket.svg',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                                Text(
                                  numberMovie.toString(),
                                  style: const TextStyle(
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
                                    child: SvgPicture.asset(
                                      'assets/svg/feedback.svg',
                                      width: 30,
                                      height: 30,
                                    )),
                                Text(
                                  numberReview.toString(),
                                  style: const TextStyle(
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
    Provider.of<UserProvider>(context, listen: false).logout(context);
    pref.removeSinginInfo();
    pref.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> reloadData() async {
    getData();
  }
}
