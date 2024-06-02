import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHomeLoading extends StatelessWidget {
  const ShimmerHomeLoading({super.key});

  Widget _buildShimmerContainer(double width, double height,
      {EdgeInsets? margin}) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerColor,
      highlightColor: AppColors.shimmerLightColor,
      child: Container(
        margin: margin ?? const EdgeInsets.all(5),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildShimmerColumn(BuildContext context) {
    return Column(
      children: [
        _buildShimmerContainer(120.0, 150.0,
            margin: const EdgeInsets.symmetric(horizontal: 10)),
        _buildShimmerContainer(60.0, 10.0, margin: const EdgeInsets.all(5.0)),
      ],
    );
  }

  Widget _buildShimmerRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildShimmerContainer(80.0, 110.0),
        _buildShimmerColumn(context),
        _buildShimmerContainer(80.0, 110.0),
      ],
    );
  }

  Widget _buildShimmerRowVariant(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            _buildShimmerContainer(250.0, 10.0),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _buildShimmerContainer(
                        double.infinity, AppSize.width(context) / 2.5),
                    _buildShimmerContainer(AppSize.width(context), 20.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20)),
                    _buildShimmerRow(context),
                    _buildShimmerContainer(AppSize.width(context), 20.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20)),
                    _buildShimmerRowVariant(context),
                    _buildShimmerRowVariant(context),
                  ],
                ),
              ),
            ],
          ),
        ),
        IgnorePointer(
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
