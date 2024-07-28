import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/constant/svgString.dart';
import 'package:movie_booking_app/models/theater/theater.dart';
import 'package:movie_booking_app/pages/googlemap/googleMap.dart';
import 'package:movie_booking_app/pages/selection/scheduleSelection.dart';
import 'package:movie_booking_app/provider/consumer/TranslateText.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';

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
                      child: SvgPicture.string(svgTheater),
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
                    ValidInput val = ValidInput();
                    val.showAlertCustom(
                      context,
                      'Do you want to find your way to the cinema?',
                      'Yes, continue',
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
