import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/modules/common/scrolling_banner.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/home/components/build_list_widgets.dart';
import 'package:movie_booking_app/pages/home/home.dart';
import 'package:movie_booking_app/pages/list/movie_list.dart';

import 'package:movie_booking_app/pages/list/movie_list_month.dart';
import 'package:movie_booking_app/provider/consumer/translator.dart';

class NowShowingSection extends StatefulWidget {
  final Future<List<Movie>?> movieRelease;

  const NowShowingSection({super.key, required this.movieRelease});

  @override
  NowShowingSectionState createState() => NowShowingSectionState();
}

class NowShowingSectionState extends State<NowShowingSection> {
  late PageController _pageController;
  late ValueNotifier<int> _currentPageNotifier;
  late List<Movie> _films;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _currentPageNotifier = ValueNotifier<int>(0);
    _films = [];
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    try {
      List<Movie>? movies = await widget.movieRelease;
      if (mounted) {
        setState(() {
          _films = movies!;
        });
      }
    } catch (error) {
      debugPrint('Error loading movies: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: AppSize.width(context),
        height: AppSize.height(context) / 2,
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
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieListings(
                            listTitle: AppLocalizations.of(context)!.nowshowing,
                            movies: movieRelease!,
                          ),
                        ),
                      );
                    },
                    label: Text(
                      AppLocalizations.of(context)!.seeAll,
                      style: AppStyle.smallblackBold,
                    ),
                    icon: Icon(
                      AppIcon.arrowR,
                      color: AppColors.backgroundColor.withOpacity(0.4),
                    ),
                    iconAlignment: IconAlignment.end,
                  ),
                ),
              ],
            ),
            Expanded(
              child: _films.isEmpty
                  ? progressLoading
                  : Column(
                      children: [
                        Expanded(
                          child: _films.isEmpty
                              ? progressLoading
                              : Column(
                                  children: [
                                    Expanded(
                                      child: CarouselSlider.builder(
                                        itemCount: _films.length,
                                        options: CarouselOptions(
                                          height:
                                              AppSize.height(context) * 0.50,
                                          viewportFraction: 0.45,
                                          enableInfiniteScroll: true,
                                          enlargeCenterPage: true,
                                          onPageChanged: (index, reason) {
                                            _currentPageNotifier.value = index;
                                          },
                                        ),
                                        itemBuilder: (BuildContext context,
                                            int index, int realIndex) {
                                          return ListMovie.buildListMovie(
                                            context,
                                            _films[index],
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: AppSize.width(context),
                                      child: Center(
                                        child: ValueListenableBuilder<int>(
                                          valueListenable: _currentPageNotifier,
                                          builder: (context, value, child) {
                                            return Center(
                                              child: Text(_films[value].title,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppStyle.titleMovie),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: AppSize.width(context),
                                      child: Center(
                                        child: ValueListenableBuilder<int>(
                                          valueListenable: _currentPageNotifier,
                                          builder: (context, value, child) {
                                            return TranslateConsumer()
                                                .translateProvider(
                                                    _films[value]
                                                        .categories
                                                        .map((category) =>
                                                            category.name)
                                                        .join(', '),
                                                    1,
                                                    AppStyle.smallText);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }
}

class ComingSoonSection extends StatelessWidget {
  final Future<List<Movie>?> movieFuture;
  const ComingSoonSection({super.key, required this.movieFuture});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.height(context) * 0.55,
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
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextButton.icon(
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
                  label: Text(
                    AppLocalizations.of(context)!.seeAll,
                    style: AppStyle.smallblackBold,
                  ),
                  icon: Icon(
                    AppIcon.arrowR,
                    color: AppColors.backgroundColor.withOpacity(0.4),
                  ),
                  iconAlignment: IconAlignment.end,
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Movie>?>(
              future: movieFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: progressLoading);
                } else if (snapshot.hasError) {
                  return Center(child: progressLoading);
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: progressLoading);
                } else {
                  List<Movie> filmsFuture = snapshot.data!;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filmsFuture.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ListMovie.buildListMovie(
                                      context, filmsFuture[index]),
                                ),
                                SizedBox(
                                  width: AppSize.width(context) / 2,
                                  child: Center(
                                      child: Text(
                                    filmsFuture[index].title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyle.titleMovie,
                                  )),
                                ),
                                SizedBox(
                                  width: AppSize.width(context) / 2,
                                  child: Center(
                                    child: TranslateConsumer()
                                        .translateProvider(
                                            filmsFuture[index]
                                                .categories
                                                .map(
                                                    (category) => category.name)
                                                .join(', '),
                                            1,
                                            AppStyle.smallText),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
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
  final Future<Map<int, List<Movie>>?> movieByMonth;
  const MovieFutureByMonth({super.key, required this.movieByMonth});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.containerColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.movie_by_month,
              textAlign: TextAlign.center,
              style: AppStyle.headline1,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieListingByMonth(
                      movies: movieByMonth,
                      listTitle: AppLocalizations.of(context)!.movie_by_month),
                ),
              );
            },
            child: const AutoScrollingBanner(),
          ),
        ],
      ),
    );
  }
}
