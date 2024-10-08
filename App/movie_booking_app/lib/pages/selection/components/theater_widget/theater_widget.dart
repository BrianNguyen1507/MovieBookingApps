import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/models/theater/theater.dart';
import 'package:movie_booking_app/pages/map/map_view.dart';
import 'package:movie_booking_app/pages/selection/schedule_selection.dart';
import 'package:movie_booking_app/provider/consumer/translator.dart';
import 'package:movie_booking_app/utils/dialog/show_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TheaterItems {
  static Widget theaterTag(
      BuildContext context, List<Theater> theaters, int index, int movieId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScheduleSelection(
                theaterId: theaters[index].id,
                theaterName: theaters[index].name,
                movieId: movieId,
              ),
            ));
      },
      child: Container(
        width: AppSize.width(context),
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            borderRadius: ContainerRadius.radius12,
            color: AppColors.containerColor,
            boxShadow: const [
              BoxShadow(
                blurRadius: 6.0,
                color: AppColors.shadowColor,
                offset: Offset(2, 1),
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.primaryColor, width: 2.0),
                        borderRadius: ContainerRadius.radius10,
                      ),
                      padding: const EdgeInsets.all(5.0),
                      margin: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        'assets/icons/ic_logo.png',
                        height: 30,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: AppSize.width(context) * 0.5,
                          child: Text(
                            theaters[index].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyle.titleTheater,
                          ),
                        ),
                        SizedBox(
                          width: AppSize.width(context) * 0.6,
                          child: TranslateConsumer().translateProvider(
                              theaters[index].address, 2, AppStyle.smallText),
                        ),
                      ],
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    ShowDialog.showAlertCustom(
                      context,
                      true,
                      AppLocalizations.of(context)!.find_cinema,
                      'Yes',
                      true,
                      () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return FractionallySizedBox(
                              child: MapTheater(
                                theaterName: theaters[index].name,
                              ),
                            );
                          },
                        );
                      },
                      DialogType.infoReverse,
                    );
                  },
                  child: ClipRRect(
                    borderRadius: ContainerRadius.radius20,
                    child: SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: SvgPicture.asset(
                        'assets/svg/map.svg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
