import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/home/components/buildList.dart';
import 'package:movie_booking_app/pages/list/Listings.dart';
import 'package:movie_booking_app/pages/list/listingByMonth.dart';

class NowShowingSection extends StatelessWidget {
  final Future<List<Movie>> movieRelease;
  const NowShowingSection({super.key, required this.movieRelease});

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var isPortrait = orientation == Orientation.portrait;
    return Container(
      height:
          isPortrait ? AppSize.height(context) / 2 : AppSize.height(context),
      decoration: const BoxDecoration(
        color: AppColors.containerColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.nowshowing,
                    textAlign: TextAlign.center,
                    style: AppStyle.headline1,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieListings(
                        listTitle: AppLocalizations.of(context)!.nowshowing,
                        movies: movieRelease,
                      ),
                    ),
                  );
                },
                label: Text(AppLocalizations.of(context)!.seeAll,
                    style: AppStyle.bodyText1),
                iconAlignment: IconAlignment.end,
                icon: Icon(
                  color: AppColors.darktextColor,
                  AppIcon.arrowR,
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: movieRelease,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: loadingContent);
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: loadingContent);
                } else {
                  List<Movie> films = snapshot.data!;

                  return SizedBox(
                    height: AppSize.height(context),
                    width: AppSize.width(context),
                    child: CarouselSlider.builder(
                      itemCount: films.length,
                      options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        aspectRatio: 16 / 20,
                        enableInfiniteScroll: true,
                        viewportFraction: 0.45,
                        initialPage: 0,
                        enlargeCenterPage: true,
                        padEnds: true,
                      ),
                      itemBuilder: (BuildContext context, int index, _) {
                        return ListMovie.buildListMovie(context, films[index]);
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ComingSoonSection extends StatelessWidget {
  final Future<List<Movie>> movieFuture;
  const ComingSoonSection({super.key, required this.movieFuture});

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var isPortrait = orientation == Orientation.portrait;
    return Container(
      height:
          isPortrait ? AppSize.height(context) / 1.8 : AppSize.height(context),
      decoration: const BoxDecoration(
        color: AppColors.containerColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.comming,
                    textAlign: TextAlign.center,
                    style: AppStyle.headline1,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieListings(
                        listTitle: AppLocalizations.of(context)!.comming,
                        movies: movieFuture,
                      ),
                    ),
                  );
                },
                label: Text(AppLocalizations.of(context)!.seeAll,
                    style: AppStyle.bodyText1),
                iconAlignment: IconAlignment.end,
                icon: Icon(
                  color: AppColors.grayTextColor,
                  AppIcon.arrowR,
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: movieFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: loadingContent);
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: loadingContent);
                } else {
                  List<Movie> filmsFuture = snapshot.data!;
                  return SizedBox(
                    height: AppSize.height(context),
                    width: AppSize.width(context),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filmsFuture.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: const EdgeInsets.all(10.0),
                          child: ListMovie.buildListMovie(
                              context, filmsFuture[index]),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MovieFutureByMonth extends StatelessWidget {
  final Future<Map<int, List<Movie>>> movieByMonth;
  const MovieFutureByMonth({super.key, required this.movieByMonth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.containerColor,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieListingByMonth(
                      movies: movieByMonth,
                      listTitle: 'Top Movies of the Month'),
                ),
              );
            },
            child: const Text('abc'),
          ),
        ),
      ],
    );
  }
}
