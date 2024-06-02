import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/modules/common/AutoScrolling.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:provider/provider.dart';

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
      child: Stack(
        children: [
          ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: 7,
            itemBuilder: (context, index) {
              if (index == 6) {
                return Container(
                    padding: const EdgeInsets.all(20),
                    child: const AutoScrollingBanner());
              }
              if (index == 0) {
                return const SizedBox(
                  height: 100,
                  child: DrawerHeader(
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
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.commonLightColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.abc_rounded),
                    title: Text('Item ${index}'),
                    onTap: () {},
                  ),
                );
              }
            },
          ),
          Positioned(
            bottom: -20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.version}: ${1.0}",
                    style: const TextStyle(
                      color: AppColors.darktextColor,
                      fontSize: AppFontSize.small,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          final provider = Provider.of<ThemeProvider>(context,
                              listen: false);
                          provider.toggleLanguage();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                isEnglish ? 'ENG  ' : '  VIE',
                                style: const TextStyle(
                                  color: AppColors.titleTextColor,
                                  fontSize: AppFontSize.small,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
