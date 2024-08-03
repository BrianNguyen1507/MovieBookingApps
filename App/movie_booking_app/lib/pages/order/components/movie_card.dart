import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movie_detail.dart';
import 'package:movie_booking_app/provider/consumer/translator.dart';

Widget movieCard(context, MovieDetail getMovie) {
  return SizedBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(AppLocalizations.of(context)!.movieDetail,
              style: AppStyle.bodyText1),
        ),
        SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                width: AppSize.width(context),
                decoration: BoxDecoration(
                  borderRadius: ContainerRadius.radius12,
                  color: AppColors.containerColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: ContainerRadius.radius10,
                        child: Image.memory(
                            height: 90,
                            width: 60,
                            ConverterUnit.base64ToUnit8(getMovie.poster)),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 2.0),
                              decoration: BoxDecoration(
                                color: ClassifyClass.toFlutterColor(
                                  ClassifyClass.classifyType(getMovie.classify),
                                ),
                                borderRadius: ContainerRadius.radius2,
                              ),
                              padding: const EdgeInsets.all(1.5),
                              child: Text(
                                ClassifyClass.convertNamed(getMovie.classify),
                                style: AppStyle.classifyText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: AppSize.width(context) - 150,
                              child: Text(
                                getMovie.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyle.titleOrder,
                              ),
                            )
                          ],
                        ),
                        TranslateConsumer().translateProvider(
                            getMovie.categories
                                .map((category) => category.name)
                                .join(', '),
                            1,
                            AppStyle.smallText),
                        Text(
                          '${AppLocalizations.of(context)!.duration}: ${getMovie.duration.toString()} ${AppLocalizations.of(context)!.minutes}',
                          style: AppStyle.smallText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.country}:',
                              style: AppStyle.smallText,
                            ),
                            TranslateConsumer().translateProvider(
                                getMovie.country, 1, AppStyle.smallText),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.language}: ',
                              style: AppStyle.smallText,
                            ),
                            TranslateConsumer().translateProvider(
                                getMovie.language, 1, AppStyle.smallText),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
