import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/detail/movieDetail.dart';
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
                          height: 200,
                          width: 150,
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
                              overflow: TextOverflow.ellipsis,
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
}
