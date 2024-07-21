import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/detail/movieDetail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:provider/provider.dart';

class MovieListingByMonth extends StatelessWidget {
  const MovieListingByMonth({
    super.key,
    required this.movies,
    required this.listTitle,
  });

  final Future<Map<int, List<Movie>>> movies;
  final String listTitle;

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var isPortrait = orientation == Orientation.portrait;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            listTitle,
            style: AppStyle.headline1,
          ),
        ),
        body: FutureBuilder<Map<int, List<Movie>>>(
          future: movies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: loadingData(context));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No movies found',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              );
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

                      return Container(
                        height: isPortrait
                            ? monthsWithMovies.length *
                                AppSize.height(context) /
                                3.5
                            : monthsWithMovies.length * AppSize.height(context),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.month} ${month.toString()}',
                              style: AppStyle.bodyText1,
                            ),
                            SizedBox(
                              height: isPortrait
                                  ? AppSize.height(context) * 0.5
                                  : AppSize.height(context),
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
                                          builder: (context) => MovieDetailPage(
                                              movieId: movie.id),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: AppSize.width(context) * 0.53,
                                      margin: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                ContainerRadius.radius12,
                                            child: Image.memory(
                                              ConverterUnit.base64ToUnit8(
                                                  movie.poster),
                                              height: 200,
                                              width: 150,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Consumer<ThemeProvider>(
                                            builder: (context, value, child) {
                                              return FutureBuilder(
                                                future: value
                                                    .translateText(movie.title),
                                                builder: (context, snapshot) =>
                                                    Text(
                                                        snapshot.data ??
                                                            movie.title,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: AppStyle
                                                            .titleMovie),
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 4),
                                          Consumer<ThemeProvider>(
                                            builder: (context, value, child) =>
                                                FutureBuilder(
                                              future: value.translateText(
                                                movie.categories
                                                    .map((category) =>
                                                        category.name)
                                                    .join(', '),
                                              ),
                                              builder: (context, snapshot) {
                                                final catTrans =
                                                    snapshot.data ??
                                                        movie.categories
                                                            .map((category) =>
                                                                category.name)
                                                            .join(', ');
                                                return Text(catTrans,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: AppStyle.smallText);
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 5),
                                            decoration: BoxDecoration(
                                              color:
                                                  ClassifyClass.toFlutterColor(
                                                      ClassifyClass
                                                          .classifyType(
                                                              movie.classify)),
                                              borderRadius:
                                             ContainerRadius.radius2,
                                            ),
                                            child: Text(movie.classify,
                                                style: AppStyle.classifyText),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
