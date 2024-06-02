import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';

class AutoScrollingBanner extends StatefulWidget {
  const AutoScrollingBanner({super.key});

  @override
  _AutoScrollingBannerState createState() => _AutoScrollingBannerState();
}

class _AutoScrollingBannerState extends State<AutoScrollingBanner> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: AppSize.width(context),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
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
              return Image.asset(
                images[index],
                width: double.infinity,
                fit: BoxFit.fill,
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (index) {
            return Container(
              width: 12.0,
              height: 5.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
                shape: BoxShape.rectangle,
                color: _currentImageIndex == index
                    ? AppColors.primaryColor
                    : AppColors.commonLightColor,
              ),
            );
          }),
        ),
      ],
    );
  }
}

final List<String> images = [
  'assets/images/image.png',
  'assets/images/image.png',
  'assets/images/image.png',
  'assets/images/image.png',
  'assets/images/image.png',
  'assets/images/image.png',
  'assets/images/image.png',
  'assets/images/image.png',
];
