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
import 'package:movie_booking_app/services/Users/movie/getListByMonth.dart';
import 'package:movie_booking_app/services/Users/movie/getListMovies.dart';

class NowShowingSection extends StatefulWidget {
  const NowShowingSection({super.key});

  @override
  State<NowShowingSection> createState() => _NowShowingSectionState();
}

late Future<List<Movie>> movieRelease;
late Future<List<Movie>> movieFuture;
late Future<Map<int, List<Movie>>> movieByMonth;

class _NowShowingSectionState extends State<NowShowingSection> {
  @override
  void initState() {
    super.initState();
    movieRelease = MovieList.getListReleased();
  }

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
                    style: const TextStyle(
                      color: AppColors.darktextColor,
                      fontSize: AppFontSize.medium,
                      fontWeight: FontWeight.bold,
                    ),
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
                        movies: movieFuture,
                      ),
                    ),
                  );
                },
                label: const Text(
                  'See all',
                  style: TextStyle(
                    color: AppColors.darktextColor,
                    fontSize: AppFontSize.small,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

class ComingSoonSection extends StatefulWidget {
  const ComingSoonSection({super.key});

  @override
  State<ComingSoonSection> createState() => _ComingSoonSectionState();
}

class _ComingSoonSectionState extends State<ComingSoonSection> {
  @override
  void initState() {
    super.initState();
    movieFuture = MovieList.getListFutured();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var isPortrait = orientation == Orientation.portrait;
    return Container(
      height:
          isPortrait ? AppSize.height(context) / 2 : AppSize.height(context),
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
                    style: const TextStyle(
                      color: AppColors.darktextColor,
                      fontSize: AppFontSize.medium,
                      fontWeight: FontWeight.bold,
                    ),
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
                label: const Text(
                  'See all',
                  style: TextStyle(
                    color: AppColors.darktextColor,
                    fontSize: AppFontSize.small,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
              future: movieFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: loadingContent);
                } else {
                  List<Movie> filmsFuture = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.all(5.0),
                    height: AppSize.height(context),
                    width: AppSize.width(context),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filmsFuture.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
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

class MovieFutureByMonth extends StatefulWidget {
  const MovieFutureByMonth({super.key});

  @override
  State<MovieFutureByMonth> createState() => _MovieFutureByMonthState();
}

class _MovieFutureByMonthState extends State<MovieFutureByMonth> {
  @override
  void initState() {
    super.initState();
    movieByMonth = GetListByMonth.getListByMonth();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.containerColor,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieListingByMonth(
                  movies: movieByMonth, listTitle: 'Movie By Month'),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(15.0),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.grayTextColor,
                blurRadius: 5.0,
              )
            ],
            color: AppColors.containerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: const Center(
              child: Text(
            'MOVIE LIST BY MONTH',
            style: AppStyle.headline1,
          )),
        ),
      ),
    );
  }
}
