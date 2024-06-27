import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movieDetail.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/detail/components/widgetComponents.dart';
import 'package:movie_booking_app/pages/detail/trailerScreen.dart';
import 'package:movie_booking_app/services/Users/movieDetail/movieDetailService.dart';
import 'package:movie_booking_app/utils/expandable.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Future<MovieDetail> movieDetail;

  @override
  void initState() {
    movieDetail = MovieDetailService.deatailMovieService(widget.movieId);
    super.initState();
  }

  Widget renderBody(BuildContext context) {
    return FutureBuilder<MovieDetail>(
      future: movieDetail,
      builder: (BuildContext context, AsyncSnapshot<MovieDetail> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasError) {
          return loadingData(context);
        } else {
          MovieDetail detail = snapshot.data!;
          return Expanded(
              child: Container(
            color: Colors.white,
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
                          borderRadius: BorderRadius.circular(12),
                          child: FutureBuilder<Uint8List>(
                            future: ConverterUnit.bytesToImage(detail.poster),
                            builder: (BuildContext context,
                                AsyncSnapshot<Uint8List> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return loadingData(context);
                              } else if (snapshot.hasError) {
                                return loadingData(context);
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
                              width: AppSize.width(context) / 1.5,
                              child: Text(
                                detail.title,
                                style: AppStyle.nameMovie,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: AppSize.width(context) / 1.6,
                              child: Text(
                                detail.categories
                                    .map((category) => category.name)
                                    .join(', '),
                                style: AppStyle.smallText,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: AppSize.width(context) / 1.8,
                              child: Text(
                                "Country: ${detail.country}",
                                style: AppStyle.smallText,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
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
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(2),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(1.5),
                                  child: Text(
                                    detail.classify,
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
                                          detail.classify),
                                      style: AppStyle.smallText,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                releaseBox(detail.isRelease),
                                SizedBox(
                                  child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
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
                                          builder: (context) => VideoScreen(
                                              videoUrl: detail.trailer),
                                        ),
                                      );
                                    },
                                    label: const Text(
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
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    margin: const EdgeInsets.only(top: 20.0),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          detailTitle(
                              'Release Date',
                              ConverterUnit.formatToDmY(
                                  detail.releaseDate.toString())),
                          const SizedBox(width: 10),
                          Container(
                            height: 50,
                            width: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          detailTitle('Duration', '${detail.duration} minutes'),
                          const SizedBox(width: 10),
                          Container(
                            height: 50,
                            width: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          detailTitle('Language', detail.language),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description',
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
                  infMovie('Directors', detail.director),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    height: 15,
                  ),
                  infMovie('Actors', detail.actor),
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
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: AppColors.primaryColor,
          ),
          onPressed: () {
            _onBookingPress(context);
          },
          child: const Text(
            'BOOKING',
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
      builder: (context, AsyncSnapshot<MovieDetail> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: loadingData(context),
          );
        } else {
          MovieDetail data = snapshot.data!;
          bool visibleBooking = data.isRelease;

          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.containerColor,
              appBar: AppBar(
                title: const Text(
                  'Movie Detail',
                  style: AppStyle.headline1,
                ),
                iconTheme: const IconThemeData(
                  color: AppColors.backgroundColor,
                ),
                backgroundColor: Colors.transparent,
              ),
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

  _onBookingPress(BuildContext context) {}
}
