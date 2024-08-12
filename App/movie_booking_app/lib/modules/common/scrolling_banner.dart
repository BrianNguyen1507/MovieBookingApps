import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/constant/app_config.dart';

class AutoScrollingBanner extends StatefulWidget {
  const AutoScrollingBanner({super.key});

  @override
  AutoScrollingBannerState createState() => AutoScrollingBannerState();
}

class AutoScrollingBannerState extends State<AutoScrollingBanner> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5.0),
          width: AppSize.width(context),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: CarouselSlider.builder(
            options: CarouselOptions(
              aspectRatio: 25 / 10,
              viewportFraction: 1.0,
              autoPlay: true,
              onPageChanged: (int index, CarouselPageChangedReason reason) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
            ),
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return ClipRRect(
                borderRadius: ContainerRadius.radius12,
                child: Image.asset(
                  images[index],
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (index) {
            return Container(
              width: 7.0,
              height: 7.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentImageIndex == index
                    ? AppColors.primaryColor
                    : AppColors.commonDarkColor,
              ),
            );
          }),
        ),
      ],
    );
  }
}

final List<String> images = [
  'assets/images/banner/banner1.jpg',
  'assets/images/banner/banner2.png',
  'assets/images/banner/banner3.jpg',
];
