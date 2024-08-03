import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/pages/movie-detail/movie_detail.dart';
import 'package:movie_booking_app/provider/consumer/translator.dart';
import 'package:movie_booking_app/utils/common/widgets.dart';

class MovieListingByMonth extends StatelessWidget {
  const MovieListingByMonth({
    super.key,
    required this.movies,
    required this.listTitle,
  });

  final Future<Map<int, List<Movie>>?> movies;
  final String listTitle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: Common.customAppbar(
            context, null, listTitle, AppColors.appbarColor, null),
        body: FutureBuilder<Map<int, List<Movie>>?>(
          future: movies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: loadingData(context));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: progressLoading);
            } else {
              final movieMap = snapshot.data!;
              final monthsWithMovies = movieMap.entries
                  .where((entry) => entry.value.isNotEmpty)
                  .toList();

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: monthsWithMovies.map(
                    (monthEntry) {
                      final month = monthEntry.key;
                      final movies = monthEntry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.month} ${month.toString()}',
                            style: AppStyle.bodyText1,
                          ),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: movies.length,
                              itemBuilder: (context, movieIndex) {
                                final movie = movies[movieIndex];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MovieDetailPage(movieId: movie.id),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  ContainerRadius.radius12,
                                              child: Image.memory(
                                                ConverterUnit.base64ToUnit8(
                                                    movie.poster),
                                                height: 150,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 5),
                                              decoration: BoxDecoration(
                                                color: ClassifyClass
                                                    .toFlutterColor(
                                                        ClassifyClass
                                                            .classifyType(movie
                                                                .classify)),
                                                borderRadius:
                                                    ContainerRadius.radius2,
                                              ),
                                              child: Text(
                                                  ClassifyClass.convertNamed(
                                                      movie.classify),
                                                  style: AppStyle.classifyText),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: 150,
                                          child: Text(movie.title,
                                              maxLines: 2,
                                              style: AppStyle.titleMovie),
                                        ),
                                        const SizedBox(height: 4),
                                        SizedBox(
                                          width: 150,
                                          child: TranslateConsumer()
                                              .translateProvider(
                                                  movie.categories
                                                      .map((category) =>
                                                          category.name)
                                                      .join(', '),
                                                  1,
                                                  AppStyle.smallText),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
