import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/services/Users/movie/getListMovies.dart';

class NowShowingSection extends StatefulWidget {
  const NowShowingSection({super.key});

  @override
  State<NowShowingSection> createState() => _NowShowingSectionState();
}

class _NowShowingSectionState extends State<NowShowingSection> {
  late Future<List<Movie>> movieReleased;

  @override
  void initState() {
    super.initState();
    movieReleased = MovieList.getListReleased();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.height(context) / 1.3,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              AppLocalizations.of(context)!.nowshowing,
              style: const TextStyle(
                color: AppColors.containerColor,
                fontSize: AppFontSize.medium,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: movieReleased,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No movies available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                } else {
                  List<Movie> films = snapshot.data!;
                  return CarouselSlider.builder(
                    itemCount: films.length,
                    options: CarouselOptions(
                      aspectRatio: 16 / 20,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.5,
                      initialPage: 0,
                      enlargeCenterPage: true,
                    ),
                    itemBuilder: (BuildContext context, int index, _) {
                      return buildMovieItem(context, films[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMovieItem(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FutureBuilder<Uint8List>(
                    future: ConverterUnit.bytesToImage(movie.poster),
                    builder: (BuildContext context,
                        AsyncSnapshot<Uint8List> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return loadingContent;
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(2),
                        )),
                    child: Text(
                      movie.classify,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.containerColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    movie.categories
                        .map((category) => category.name)
                        .join(', '),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.commonColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ComingSoonSection extends StatelessWidget {
  const ComingSoonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.height(context) / 2,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              AppLocalizations.of(context)!.comming,
              style: const TextStyle(
                color: AppColors.darktextColor,
                fontSize: AppFontSize.medium,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          loadingContent,
        ],
      ),
    );
  }
}
