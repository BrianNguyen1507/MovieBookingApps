import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/food/food.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/detail/movieDetail.dart';
import 'package:movie_booking_app/pages/detail/trailerScreen_webview.dart';
import 'package:movie_booking_app/provider/provider.dart';
import 'package:provider/provider.dart';

class ListMovie {
  static Widget buildListMovie(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailPage(movieId: movie.id),
            ));
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FutureBuilder<Uint8List>(
                    future: ConverterUnit.bytesToImage(movie.poster),
                    builder: (BuildContext context,
                        AsyncSnapshot<Uint8List> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return loadingContent;
                      } else if (snapshot.hasError) {
                        return loadingContent;
                      } else {
                        return Image.memory(
                          height: 220,
                          width: 160,
                          snapshot.data!,
                          fit: BoxFit.cover,
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        color: ClassifyClass.toFlutterColor(
                          ClassifyClass.classifyType(movie.classify),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(3.0),
                        )),
                    child: Text(
                      movie.classify,
                      style: AppStyle.classifyText,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: Center(
                    child: Consumer<ThemeProvider>(
                      builder: (context, provider, child) {
                        return FutureBuilder<String>(
                          future: provider.translateText(movie.title),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? movie.title,
                              maxLines: 2,
                              style: AppStyle.titleMovie,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 120.0,
                  child: Center(
                    child: Consumer<ThemeProvider>(
                      builder: (context, provider, child) {
                        return FutureBuilder<String>(
                          future: provider.translateText(
                            movie.categories
                                .map((category) => category.name)
                                .join(', '),
                          ),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ??
                                  movie.categories
                                      .map((category) => category.name)
                                      .join(', '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyle.smallText,
                            );
                          },
                        );
                      },
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

  static Widget buildItem(BuildContext context, Food food) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/foods');
      },
      child: Container(
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.all(5.0),
        decoration: const BoxDecoration(
          color: AppColors.commonLightColor,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Image.memory(
                ConverterUnit.base64ToUnit8(food.image),
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                food.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildVideo(BuildContext context, Movie movie) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
