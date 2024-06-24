import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';

import 'package:movie_booking_app/models/movie/movieDetail.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
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
          return loadingContent;
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
                                return loadingContent;
                              } else if (snapshot.hasError) {
                                return loadingContent;
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
                              width: AppSize.width(context) / 2,
                              child: Text(
                                detail.title,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: AppSize.width(context) / 2,
                              child: Text(
                                detail.categories
                                    .map((category) => category.name)
                                    .join(', '),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black45),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      minimumSize: WidgetStateProperty.all(
                                          const Size(100, 36)),
                                      foregroundColor: WidgetStateProperty.all(
                                          AppColors.primaryColor),
                                      overlayColor: WidgetStateProperty.all(
                                          AppColors.commonLightColor),
                                      side: WidgetStateProperty.all(
                                          const BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 1.5,
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
                                    label: const Text('Trailer'),
                                    icon: const Icon(Icons.play_arrow_rounded),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    margin: const EdgeInsets.only(top: 20.0),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              children: [
                                const Text(
                                  'Date release',
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                ),
                                Text(
                                  ConverterUnit.convertToDate(
                                      detail.releaseDate.toString()),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 50,
                            width: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              children: [
                                const Text(
                                  'Duration',
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                ),
                                Text(
                                  '${detail.duration.toString()} minutes',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 50,
                            width: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              children: [
                                const Text(
                                  'Language',
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                ),
                                Text(
                                  detail.language,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
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
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 0.35,
                            ),
                            ExpandableText(
                              text: ConverterUnit.uint8ToString(
                                ConverterUnit.base64ToUnit8(detail.description),
                              ),
                            )
                          ]),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    height: 15,
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
                            'Director & Actor',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 0.35,
                          ),
                          Text(
                            '${detail.director} - ${detail.actor}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
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
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.grey[400],
      ),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10.0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.black,
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            elevation: 15.0,
          ),
          onPressed: () {
            _onRegisterPress(context);
          },
          child: const Text(
            'BOOKING',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.containerColor,
      appBar: AppBar(
        title: const Text('Movie Detail'),
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

                    // : renderBooking(context),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _onRegisterPress(BuildContext context) {}
}
