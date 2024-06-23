import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/detail/movieDetail.dart';

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
                  borderRadius: BorderRadius.circular(12),
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
                          height: 250,
                          width: 200,
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
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: ClassifyColors.toFlutterColor(
                          ClassifyColors.classifyType(movie.classify),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(3.0),
                        )),
                    child: Text(
                      movie.classify,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.containerColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: AppColors.darktextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  movie.categories.map((category) => category.name).join(', '),
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: AppColors.commonDarkColor,
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
