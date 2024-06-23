import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/modules/common/AutoScrolling.dart';

import 'package:movie_booking_app/pages/home/components/moviesList.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  ],
                ),
              ],
            ),
            CustomScrollView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                _buildComingSoonSliver(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildNowShowingSliver(BuildContext context) {
    return const SliverToBoxAdapter(
      child: NowShowingSection(),
    );
  }

  SliverToBoxAdapter _buildComingSoonSliver(BuildContext context) {
    return const SliverToBoxAdapter(
      child: ComingSoonSection(),
    );
  }
}
