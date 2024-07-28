import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/modules/common/AutoScrolling.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/home/components/buildList.dart';
import 'package:movie_booking_app/pages/home/homePage.dart';
import 'package:movie_booking_app/pages/list/Listings.dart';
import 'package:movie_booking_app/pages/list/listingByMonth.dart';
import 'package:movie_booking_app/provider/consumer/TranslateText.dart';

class NowShowingSection extends StatefulWidget {
  final Future<List<Movie>?> movieRelease;

  const NowShowingSection({super.key, required this.movieRelease});

  @override
  _NowShowingSectionState createState() => _NowShowingSectionState();
}

class _NowShowingSectionState extends State<NowShowingSection> {
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
      print('Error loading movies: $error');
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
                    style: ButtonStyle(
                      side: WidgetStateProperty.all<BorderSide>(
                        BorderSide(
                          color: AppColors.backgroundColor.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                    ),
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
                                            return TranslateConsumer()
                                                .translateProvider(
                                                    _films[value].title,
                                                    1,
                                                    AppStyle.headline1);
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
                  style: ButtonStyle(
                    side: WidgetStateProperty.all<BorderSide>(
                      BorderSide(
                        color: AppColors.backgroundColor.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                  ),
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
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ListMovie.buildListMovie(
                                      context, filmsFuture[index]),
                                ),
                                SizedBox(
                                  width: AppSize.width(context) / 2,
                                  child: Center(
                                    child: TranslateConsumer()
                                        .translateProvider(
                                            filmsFuture[index].title,
                                            1,
                                            AppStyle.titleMovie),
                                  ),
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
