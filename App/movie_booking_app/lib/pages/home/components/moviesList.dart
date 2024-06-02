import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NowShowingSection extends StatelessWidget {
  const NowShowingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.height(context) / 2,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              AppLocalizations.of(context)!.nowshowing,
              style: const TextStyle(
                color: AppColors.titleTextColor,
                fontSize: AppFontSize.medium,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          loadingContent,
        ],
      ),
    );
  }
}

class ComingSoonSection extends StatelessWidget {
  const ComingSoonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.height(context) / 2,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              AppLocalizations.of(context)!.comming,
              style: const TextStyle(
                color: AppColors.titleTextColor,
                fontSize: AppFontSize.medium,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          loadingContent,
        ],
      ),
    );
  }
}
