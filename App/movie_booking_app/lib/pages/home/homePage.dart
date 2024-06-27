import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:movie_booking_app/modules/common/AutoScrolling.dart';
import 'package:movie_booking_app/modules/loading/shimmer/shimmerloading.dart';
import 'package:movie_booking_app/pages/home/components/moviesList.dart';
import 'package:movie_booking_app/services/Users/movie/getListByMonth.dart';
import 'package:movie_booking_app/services/Users/movie/getListMovies.dart';

Future<List<Movie>>? movieRelease;
Future<List<Movie>>? movieFuture;
Future<Map<int, List<Movie>>>? movieByMonth;

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
}
