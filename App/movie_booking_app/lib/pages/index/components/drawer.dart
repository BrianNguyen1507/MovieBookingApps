import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/modules/common/AutoScrolling.dart';
import 'package:movie_booking_app/pages/index/components/buttonDrawer.dart';
import 'package:movie_booking_app/pages/index/index.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_booking_app/constant/svgString.dart';

class BuildDrawer extends StatefulWidget {
  const BuildDrawer(BuildContext context, {super.key});

  @override
  _BuildDrawerState createState() => _BuildDrawerState();
}

class _BuildDrawerState extends State<BuildDrawer> {
  @override
  Widget build(BuildContext context) {
    bool isEnglish =
        Provider.of<ThemeProvider>(context).locale.languageCode == 'en';

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: AppSize.height(context) / 10,
            child: const DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              curve: Curves.bounceOut,
              decoration: BoxDecoration(
                color: AppColors.containerColor,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  'MOVIES BOOKING APP',
                  style: AppStyle.bannerText,
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
                buttonDrawer(context, AppIcon.arrowR, 'Cinema',
                    const IndexPage(initialIndex: 2)),
                buttonDrawer(context, AppIcon.arrowR, 'Cinema',
                    const IndexPage(initialIndex: 2)),
                buttonDrawer(context, AppIcon.arrowR, 'Cinema',
                    const IndexPage(initialIndex: 2)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.language,
                          size: 20.0,
                          color: AppColors.commonColor,
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'Languages',
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
                          borderRadius: BorderRadius.circular(20.0),
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
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: isEnglish
                                    ? SvgPicture.string(
                                        svgEng,
                                        width: 24.0,
                                        height: 24.0,
                                        fit: BoxFit.cover,
                                      )
                                    : SvgPicture.string(
                                        svgVie,
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
