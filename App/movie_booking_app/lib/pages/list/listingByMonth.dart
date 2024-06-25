import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/detail/movieDetail.dart';

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
          title: Text(listTitle),
        ),
        body: FutureBuilder<Map<int, List<Movie>>>(
          future: movies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: loadingContent);
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
                  children: monthsWithMovies.map((monthEntry) {
                    final month = monthEntry.key;
                    final movies = monthEntry.value;

                    return Container(
                      height: isPortrait
                          ? monthsWithMovies.length *
                              AppSize.height(context) /
                              5
                          : monthsWithMovies.length *
                              AppSize.height(context) /
                              2.5,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Month ${month.toString()}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: isPortrait
                                ? AppSize.height(context) / 2
                                : AppSize.height(context),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
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
                                    width: AppSize.width(context) / 2,
                                    margin: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.memory(
                                            ConverterUnit.base64ToUnit8(
                                                movie.poster),
                                            height: 200,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          movie.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          movie.categories
                                              .map((category) => category.name)
                                              .join(', '),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: ClassifyClass.toFlutterColor(
                                                ClassifyClass.classifyType(
                                                    movie.classify)),
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                          ),
                                          child: Text(
                                            movie.classify,
                                            style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: AppColors.containerColor,
                                            ),
                                          ),
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
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
