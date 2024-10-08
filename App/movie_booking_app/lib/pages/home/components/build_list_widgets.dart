import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/food/food.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/movie-detail/movie_detail.dart';
import 'package:movie_booking_app/pages/movie-detail/trailer_view.dart';

class ListMovie {
  static Widget buildListMovie(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movieId: movie.id),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: ContainerRadius.radius10,
                  child: FutureBuilder<Uint8List>(
                    future: ConverterUnit.bytesToImage(movie.poster),
                    builder: (BuildContext context,
                        AsyncSnapshot<Uint8List> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return loadingContent;
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return loadingContent;
                      } else {
                        return SizedBox(
                          height: AppSize.height(context) / 3,
                          width: AppSize.width(context) / 2.5,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: ClassifyClass.toFlutterColor(
                        ClassifyClass.classifyType(movie.classify),
                      ),
                      borderRadius: ContainerRadius.radius5,
                    ),
                    child: Text(
                      ClassifyClass.convertNamed(movie.classify),
                      style: AppStyle.classifyText,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildItem(context, Food food) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/foods');
      },
      child: Container(
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: AppColors.containerColor,
            boxShadow: const [
              BoxShadow(
                blurRadius: 6.0,
                color: AppColors.shadowColor,
                offset: Offset(1, 1),
              ),
            ],
            borderRadius: ContainerRadius.radius12),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: ContainerRadius.radius12,
              child: Image.memory(
                ConverterUnit.base64ToUnit8(food.image),
                height: 100,
                width: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildVideo(context, Movie movie) {
    return GestureDetector(
      onTap: () {
        if (movie.trailer != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrailerScreen(urlResponse: movie.trailer!),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: ContainerRadius.radius10,
              child: Stack(
                children: [
                  SizedBox(
                    child: Image.memory(
                      ConverterUnit.base64ToUnit8(movie.poster),
                      height: 80,
                      width: 150,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    width: 150,
                    child: Center(
                      child: Icon(
                        AppIcon.playCircle,
                        color: AppColors.iconThemeColor,
                        size: 50.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
