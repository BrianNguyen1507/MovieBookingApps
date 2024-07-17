import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:movie_booking_app/modules/common/AutoScrolling.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/modules/loading/shimmer/shimmerloading.dart';
import 'package:movie_booking_app/pages/home/components/buildList.dart';
import 'package:movie_booking_app/pages/home/components/moviesList.dart';
import 'package:movie_booking_app/services/Users/movie/getListByMonth.dart';
import 'package:movie_booking_app/services/Users/movie/getListMovies.dart';

Future<List<Movie>>? movieRelease;
Future<List<Movie>>? movieFuture;
Future<Map<int, List<Movie>>>? movieByMonth;
Future<List<Movie>>? movieList;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    movieRelease ??= MovieList.getListReleased();
    movieFuture ??= MovieList.getListFutured();
    movieByMonth ??= GetListByMonth.getListByMonth();
    movieList ??= MovieList.getAllListMovie();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const ShimmerHomeLoading()
        : Scaffold(
            backgroundColor: AppColors.backgroundColor,
            extendBody: true,
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const AutoScrollingBanner(),
                  Stack(
                    children: [
                      CustomScrollView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        slivers: [
                          _buildNowShowingSliver(context),
                          _buildComingSoonSliver(context),
                          _buildMovieListByMonthSliver(context),
                          _buildItemsList(context),
                          _buildvideosList(context, movieList!)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  SliverToBoxAdapter _buildNowShowingSliver(BuildContext context) {
    return SliverToBoxAdapter(
      child: NowShowingSection(
        movieRelease: movieRelease!,
      ),
    );
  }

  SliverToBoxAdapter _buildComingSoonSliver(BuildContext context) {
    return SliverToBoxAdapter(
      child: ComingSoonSection(
        movieFuture: movieFuture!,
      ),
    );
  }

  SliverToBoxAdapter _buildMovieListByMonthSliver(BuildContext context) {
    return SliverToBoxAdapter(
      child: MovieFutureByMonth(
        movieByMonth: movieByMonth!,
      ),
    );
  }

  Widget _buildItemsList(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.containerColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Store',
                textAlign: TextAlign.center,
                style: AppStyle.headline1,
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: AppSize.height(context) * 0.15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ListMovie.buildItem(Icons.food_bank),
                      ListMovie.buildItem(Icons.fastfood),
                      ListMovie.buildItem(Icons.local_pizza),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildvideosList(BuildContext context, Future<List<Movie>> movies) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.containerColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Video trailer',
                textAlign: TextAlign.center,
                style: AppStyle.headline1,
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: AppSize.height(context) * 0.25,
                  child: FutureBuilder(
                    future: movies,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return loadingContent;
                      } else if (snapshot.hasError) {
                        return loadingContent;
                      } else {
                        final movies = snapshot.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            return ListMovie.buildVideo(context, movies[index]);
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
