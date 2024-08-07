import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movie_detail.dart';
import 'package:movie_booking_app/models/ratingfeedback/rating_feedback.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/movie-detail/components/detail_widgets.dart';
import 'package:movie_booking_app/pages/movie-detail/components/feedback_list.dart';
import 'package:movie_booking_app/pages/movie-detail/trailer_view.dart';
import 'package:movie_booking_app/pages/selection/theater_selection.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:movie_booking_app/services/Users/movie-detail/movie_detail_service.dart';
import 'package:movie_booking_app/services/Users/rating-feedback/rating_feedback_service.dart';
import 'package:movie_booking_app/utils/common/expandable.dart';
import 'package:movie_booking_app/utils/common/widgets.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Future<MovieDetail?> movieDetail;
  late Future<List<RatingFeedback>?> listFeedback;
  late String movieName;

  @override
  void initState() {
    movieDetail =
        MovieDetailService.deatailMovieService(context, widget.movieId);
    listFeedback =
        RatingFeedbackService.getAllRatingFeedback(context, widget.movieId);
    super.initState();
  }

  Widget renderBody(BuildContext context) {
    return FutureBuilder<MovieDetail?>(
      future: movieDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasError) {
          return loadingData(context);
        } else {
          MovieDetail detail = snapshot.data!;
          movieName = detail.title;
          return Expanded(
              child: Container(
            color: AppColors.containerColor,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: ContainerRadius.radius12,
                          child: FutureBuilder<Uint8List>(
                            future: ConverterUnit.bytesToImage(detail.poster),
                            builder: (BuildContext context,
                                AsyncSnapshot<Uint8List> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox();
                              } else if (snapshot.hasError) {
                                return const SizedBox();
                              } else {
                                return Image.memory(
                                  height: 150,
                                  width: 100,
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: AppSize.width(context) / 1.6,
                              child: Text(
                                detail.title,
                                style: AppStyle.nameMovie,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: AppSize.width(context) / 1.8,
                              child: Consumer<ThemeProvider>(
                                builder: (context, provider, child) =>
                                    FutureBuilder<String>(
                                  future:
                                      provider.translateText(detail.country),
                                  builder: (context, snapshot) {
                                    final countrytrans =
                                        snapshot.data ?? detail.country;
                                    return Text(
                                      "${AppLocalizations.of(context)!.country}: $countrytrans",
                                      style: AppStyle.smallText,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: AppSize.width(context) / 1.8,
                              child: Consumer<ThemeProvider>(
                                builder: (context, provider, child) =>
                                    FutureBuilder<String>(
                                  future: provider.translateText(
                                    detail.categories
                                        .map((category) => category.name)
                                        .join(', '),
                                  ),
                                  builder: (context, snapshot) {
                                    final categories = (snapshot.data ?? "")
                                        .split(', ')
                                        .map((e) => e.trim())
                                        .toList();
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          spacing: 5.0,
                                          runSpacing: 5.0,
                                          children: categories.map((category) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                  color: AppColors.transpanrent,
                                                  border: Border.all(
                                                      width: 1,
                                                      color: AppColors
                                                          .commonColor),
                                                  borderRadius:
                                                      ContainerRadius.radius5),
                                              child: Text(
                                                category,
                                                style: AppStyle.smallText,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: ClassifyClass.toFlutterColor(
                                        ClassifyClass.classifyType(
                                            detail.classify),
                                      ),
                                      borderRadius: ContainerRadius.radius2),
                                  padding: const EdgeInsets.all(1.5),
                                  child: Text(
                                    ClassifyClass.convertNamed(detail.classify),
                                    style: AppStyle.classifyText,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: SizedBox(
                                    width: AppSize.width(context) / 1.8,
                                    child: Text(
                                      ClassifyClass.contentClassify(
                                          context, detail.classify),
                                      style: AppStyle.smallText,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                releaseBox(context, detail.isRelease),
                                SizedBox(
                                  child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: ContainerRadius.radius5,
                                        ),
                                      ),
                                      minimumSize: WidgetStateProperty.all(
                                          const Size(10, 30)),
                                      foregroundColor: WidgetStateProperty.all(
                                          AppColors.primaryColor),
                                      backgroundColor: WidgetStateProperty.all(
                                          AppColors.containerColor),
                                      side: WidgetStateProperty.all(
                                          const BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 2,
                                      )),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TrailerScreen(
                                              urlResponse: (detail.trailer)),
                                        ),
                                      );
                                    },
                                    label: Text(
                                      'Trailer',
                                      style: AppStyle.buttonText,
                                    ),
                                    icon: Icon(AppIcon.playButton),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            detailContent(
                                AppLocalizations.of(context)!.releaseDate,
                                ConverterUnit.formatToDmY(
                                    detail.releaseDate.toString())),
                            const SizedBox(width: 10),
                            Container(
                              height: 50,
                              width: 1,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            detailContent(
                                AppLocalizations.of(context)!.duration,
                                '${detail.duration} ${AppLocalizations.of(context)!.minutes}'),
                            const SizedBox(width: 10),
                            Container(
                              height: 50,
                              width: 1,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            detailTitle(AppLocalizations.of(context)!.language,
                                detail.language),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: ContainerRadius.radius20,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.description,
                              style: AppStyle.bodyText1,
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 0.35,
                            ),
                            detail.description.length > 200
                                ? ExpandableText(
                                    text: ConverterUnit.uint8ToString(
                                      ConverterUnit.base64ToUnit8(
                                          detail.description),
                                    ),
                                  )
                                : Text(
                                    ConverterUnit.uint8ToString(
                                      ConverterUnit.base64ToUnit8(
                                          detail.description),
                                    ),
                                    style: AppStyle.detailTitle,
                                  ),
                          ]),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    height: 15,
                  ),
                  infMovie(
                      AppLocalizations.of(context)!.director, detail.director),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    height: 15,
                  ),
                  infMovie(AppLocalizations.of(context)!.actor, detail.actor),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    height: 15,
                  ),
                  RatingFeedbackWidget(
                    listFeedback: listFeedback,
                  ),
                ],
              ),
            ),
          ));
        }
      },
    );
  }

  Widget renderBooking(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      width: double.infinity,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: ContainerRadius.radius10,
            ),
            backgroundColor: AppColors.primaryColor,
          ),
          onPressed: () {
            _onBookingPress(context);
          },
          child: Text(
            AppLocalizations.of(context)!.booking,
            style: AppStyle.buttonNavigator,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: movieDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.containerColor,
            appBar: Common.customAppbar(
                context,
                null,
                AppLocalizations.of(context)!.movieDetail,
                AppColors.appbarColor,
                null),
            body: Center(
              child: loadingData(context),
            ),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: Common.customAppbar(
                context,
                null,
                AppLocalizations.of(context)!.movieDetail,
                AppColors.appbarColor,
                null),
            body: Center(
              child: loadingData(context),
            ),
          );
        } else {
          MovieDetail data = snapshot.data!;
          bool visibleBooking = data.isRelease;

          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.containerColor,
              appBar: Common.customAppbar(
                  context,
                  null,
                  AppLocalizations.of(context)!.movieDetail,
                  AppColors.appbarColor,
                  null),
              body: Container(
                constraints: const BoxConstraints.expand(),
                child: Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          children: [
                            renderBody(context),
                            visibleBooking
                                ? renderBooking(context)
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  _onBookingPress(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TheaterSelection(movieId: widget.movieId, name: movieName),
        ));
  }
}
