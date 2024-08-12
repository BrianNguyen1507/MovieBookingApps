import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/models/food/food.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:movie_booking_app/modules/common/scrolling_banner.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/home/components/build_list_widgets.dart';
import 'package:movie_booking_app/pages/home/components/movie_section.dart';
import 'package:movie_booking_app/services/Users/food/food_service.dart';
import 'package:movie_booking_app/services/Users/movie/get_list_month.dart';
import 'package:movie_booking_app/services/Users/movie/get_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<List<Movie>?>? movieRelease;
Future<List<Movie>?>? movieFuture;
Future<Map<int, List<Movie>>?>? movieByMonth;
Future<List<Movie>?>? movieList;
Future<List<Food>?>? foodList;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    movieRelease = MovieList.getListReleased(context);
    movieFuture = MovieList.getListFutured(context);
    movieByMonth = GetListByMonth.getListByMonth(context);
    movieList = MovieList.getAllListMovie(context);
    foodList = FoodService.getAllFood(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AutoScrollingBanner(),
            Stack(
              children: [
                CustomScrollView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [
                    _buildNowShowingSliver(),
                    _buildComingSoonSliver(),
                    _buildMovieListByMonthSliver(),
                    _buildItemsList(foodList!),
                    _buildvideosList(movieList!)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildNowShowingSliver() {
    return SliverToBoxAdapter(
      child: NowShowingSection(
        movieRelease: movieRelease!,
      ),
    );
  }

  SliverToBoxAdapter _buildComingSoonSliver() {
    return SliverToBoxAdapter(
      child: ComingSoonSection(
        movieFuture: movieFuture!,
      ),
    );
  }

  SliverToBoxAdapter _buildMovieListByMonthSliver() {
    return SliverToBoxAdapter(
      child: MovieFutureByMonth(
        movieByMonth: movieByMonth!,
      ),
    );
  }

  Widget _buildItemsList(Future<List<Food>?> foods) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.containerColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.store,
                textAlign: TextAlign.center,
                style: AppStyle.headline1,
              ),
            ),
            FutureBuilder(
              future: foods,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return progressLoading;
                } else if (snapshot.hasError || snapshot.data == null) {
                  return progressLoading;
                } else {
                  final data = snapshot.data!;
                  return SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return ListMovie.buildItem(context, data[index]);
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildvideosList(Future<List<Movie>?> movies) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.containerColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.vid_trailer,
                textAlign: TextAlign.center,
                style: AppStyle.headline1,
              ),
            ),
            Column(
              children: [
                FutureBuilder(
                  future: movies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return progressLoading;
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return progressLoading;
                    } else {
                      final movies = snapshot.data!;
                      return SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            return ListMovie.buildVideo(context, movies[index]);
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
