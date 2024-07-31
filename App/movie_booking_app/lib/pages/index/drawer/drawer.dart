import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/modules/common/scrolling_banner.dart';
import 'package:movie_booking_app/pages/index/drawer/drawer_widget.dart';
import 'package:movie_booking_app/pages/index/index.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildDrawer extends StatefulWidget {
  const BuildDrawer(BuildContext context, {super.key});

  @override
  BuildDrawerState createState() => BuildDrawerState();
}

class BuildDrawerState extends State<BuildDrawer> {
  @override
  Widget build(BuildContext context) {
    bool isEnglish =
        Provider.of<ThemeProvider>(context).locale.languageCode == 'en';

    return Drawer(
      backgroundColor: AppColors.containerColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: AppSize.height(context) * 0.2,
            child: DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              curve: Curves.bounceOut,
              decoration: const BoxDecoration(
                color: AppColors.containerColor,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.containerColor,
                  ),
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/ic_logo.png',
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(10.0),
              physics: const BouncingScrollPhysics(),
              children: [
                buttonDrawer(
                    context,
                    SvgPicture.asset(
                      'assets/svg/tv.svg',
                      height: 35,
                    ),
                    AppLocalizations.of(context)!.cinema,
                    const IndexPage(initialIndex: 1)),
                buttonDrawer(
                    context,
                    SvgPicture.asset(
                      'assets/svg/popcorn.svg',
                      height: 35,
                    ),
                    AppLocalizations.of(context)!.store,
                    const IndexPage(initialIndex: 0)),
                buttonDrawer(
                    context,
                    SvgPicture.asset(
                      'assets/svg/user.svg',
                      height: 35,
                    ),
                    AppLocalizations.of(context)!.personal,
                    const IndexPage(initialIndex: 2)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/language.svg',
                          height: 35,
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            AppLocalizations.of(context)!.language,
                            style: AppStyle.bodyText1,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          final provider = Provider.of<ThemeProvider>(context,
                              listen: false);
                          provider.toggleLanguage();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: isEnglish
                              ? AppColors.primaryColor
                              : AppColors.commonColor,
                          borderRadius: ContainerRadius.radius20,
                        ),
                        child: Stack(
                          alignment: isEnglish
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          children: [
                            Container(
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                borderRadius: ContainerRadius.radius12,
                                color: AppColors.containerColor,
                              ),
                              child: ClipRRect(
                                borderRadius: ContainerRadius.radius12,
                                child: isEnglish
                                    ? SvgPicture.asset(
                                        'assets/svg/united-kingdom.svg',
                                        width: 24.0,
                                        height: 24.0,
                                        fit: BoxFit.cover,
                                      )
                                    : SvgPicture.asset(
                                        'assets/svg/vietnam.svg',
                                        width: 24.0,
                                        height: 24.0,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Container(
                              padding: isEnglish
                                  ? const EdgeInsets.only(right: 20.0)
                                  : const EdgeInsets.only(left: 25.0),
                              child: Text(
                                isEnglish ? 'EN ' : 'VN ',
                                style: AppStyle.buttonText2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const AutoScrollingBanner(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
