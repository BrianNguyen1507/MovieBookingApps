import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:movie_booking_app/pages/movie-detail/components/detail_widgets.dart';
import 'package:movie_booking_app/pages/movie-detail/movie_detail.dart';

import 'package:movie_booking_app/provider/consumer/translator.dart';

class MovieListings extends StatelessWidget {
  const MovieListings(
      {super.key, required this.movies, required this.listTitle});
  final Future<List<Movie>?> movies;
  final String listTitle;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.iconThemeColor),
          backgroundColor: AppColors.backgroundColor,
          title: Text(
            listTitle,
            style: AppStyle.bannerText,
          ),
        ),
        body: FutureBuilder(
          future: movies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text(
                'No movies found',
                style: TextStyle(color: AppColors.primaryColor),
              ));
            } else {
              List<Movie> movieList = snapshot.data!;
              return SizedBox(
                height: (movieList.length + 1) * 150,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: movieList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailPage(movieId: movieList[index].id),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 150,
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: ContainerRadius.radius12,
                                    child: Image.memory(
                                        ConverterUnit.base64ToUnit8(
                                            movieList[index].poster)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: AppSize.width(context) / 2,
                                        child: Text(movieList[index].title,
                                            maxLines: 2,
                                            style: AppStyle.titleMovie),
                                      ),
                                      SizedBox(
                                        width: AppSize.width(context) / 2,
                                        child: TranslateConsumer()
                                            .translateProvider(
                                                movieList[index]
                                                    .categories
                                                    .map((category) =>
                                                        category.name)
                                                    .join(', '),
                                                1,
                                                AppStyle.smallText),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: ClassifyClass.toFlutterColor(
                                            ClassifyClass.classifyType(
                                                movieList[index].classify),
                                          ),
                                          borderRadius: ContainerRadius.radius2,
                                        ),
                                        child: Text(
                                          ClassifyClass.convertNamed(
                                              movieList[index].classify),
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: AppColors.containerColor,
                                          ),
                                        ),
                                      ),
                                      releaseBox(
                                          context, movieList[index].isRelease),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
