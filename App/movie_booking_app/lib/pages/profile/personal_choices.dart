import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/pages/profile/change_password.dart';
import 'package:movie_booking_app/pages/profile/update_information.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InformationChoice extends StatelessWidget {
  const InformationChoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.personal_inf),
        backgroundColor: AppColors.appbarColor,
        titleTextStyle: AppStyle.headline2,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpdateInformation(),
                    ));
              },
              child: SizedBox(
                width: AppSize.width(context),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.update_info,
                      style: AppStyle.bodyText1,
                    ),
                    Icon(AppIcon.arrowR),
                  ],
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePassword()));
              },
              child: SizedBox(
                width: AppSize.width(context),
                height: 50,
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.change_pass,
                      style: AppStyle.bodyText1,
                    ),
                    const Expanded(child: SizedBox()),
                    Icon(AppIcon.arrowR),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
