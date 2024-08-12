import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/profile/components/mylist.dart';
import 'package:movie_booking_app/pages/profile/guest_view.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';
import 'package:movie_booking_app/pages/profile/components/button.dart';
import 'package:movie_booking_app/services/Users/puchased/get_order_info.dart';
import 'package:movie_booking_app/services/Users/signup/valid_handle.dart';
import 'package:movie_booking_app/utils/dialog/show_dialog.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ValidInput valid = ValidInput();
  Preferences pref = Preferences();

  dynamic token;
  late Future<Map<String, dynamic>> _userDataFuture;
  @override
  void initState() {
    super.initState();
    _userDataFuture = getData();
  }

  Future<Map<String, dynamic>> getData() async {
    dynamic token = await pref.getTokenUsers();
    if (token == null) {
      return {
        'getuserName': null,
        'getAvatar': null,
        'numberMovie': null,
        'numberReview': null,
      };
    }

    String? getuserName = await pref.getUserName();
    String? getAvatar = await pref.getAvatar();
    int? numberMovie = await GetOrderInfo.accountNumberMovieInfo(context);
    int? numberReview = await GetOrderInfo.accountNumberReviewInfo(context);

    return {
      'getuserName': getuserName,
      'getAvatar': getAvatar,
      'numberMovie': numberMovie,
      'numberReview': numberReview,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: _userDataFuture,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: progressLoading);
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData ||
              (snapshot.data!['getuserName'] == null &&
                  snapshot.data!['numberMovie'] == null)) {
            return const GuestPage();
          }

          final data = snapshot.data!;
          String avatar = data['getAvatar'];
          String userName = data['getuserName'];
          int numberMovie = data['numberMovie'];
          int numberReview = data['numberReview'];
          return Scaffold(
            backgroundColor: Colors.white,
            extendBody: true,
            body: CustomScrollView(
              slivers: <Widget>[
                _buildSliverProfileBar(
                    context, avatar, userName, numberMovie, numberReview),
                Builditem.buildSliverList(context),
                BuildButton.commonbutton(
                    context,
                    AppLocalizations.of(context)!.logout,
                    () => ShowDialog.showAlertCustom(
                        context,
                        true,
                        AppLocalizations.of(context)!.cofirm_logout_q,
                        AppLocalizations.of(context)!.confirm_logout,
                        true,
                        () => _onPressLogout(context),
                        DialogType.info)),
              ],
            ),
          );
        });
  }

  Widget _buildSliverProfileBar(BuildContext context, String avatar,
      String userEmail, int? numberMovie, int? numberReview) {
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
                    child: avatar.isEmpty
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
                              ConverterUnit.base64ToUnit8(avatar),
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
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                                Text(
                                  numberMovie.toString(),
                                  style: AppStyle.titleMovie,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.watched,
                                  style: AppStyle.smallText,
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
                                      width: 20,
                                      height: 20,
                                    )),
                                Text(
                                  numberReview.toString(),
                                  style: AppStyle.titleMovie,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.revw,
                                  style: AppStyle.smallText,
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
