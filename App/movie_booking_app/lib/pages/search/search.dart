import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/pages/detail/movieDetail.dart';
import 'package:movie_booking_app/services/Users/search/searchMovie.dart';
import 'package:movie_booking_app/models/movie/movie.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<StatefulWidget> createState() {
    return SearchState();
  }
}

class SearchState extends State<Search> {
  late Future<List<Movie>> movies;
  TextEditingController textFilter = TextEditingController();

  @override
  void initState() {
    movies = SearchMovieService.findAllMovieByKeyWord(textFilter.text);
    super.initState();
  }

  @override
  void dispose() {
    textFilter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: AppColors.containerColor,
          ),
          title: const Text(
            'Search',
            style: TextStyle(
              color: AppColors.containerColor,
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
        ),
        backgroundColor: AppColors.commonLightColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        style: const TextStyle(color: AppColors.darktextColor),
                        controller: textFilter,
                        decoration: InputDecoration(
                          hintText: 'Search movies',
                          hintStyle: const TextStyle(
                              color: AppColors.commonDarkColor,
                              fontSize: AppFontSize.small),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: AppColors.backgroundColor)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.primaryColor, width: 2.0),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50.0,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          movies = SearchMovieService.findAllMovieByKeyWord(
                              textFilter.text);
                        });
                      },
                      child: Icon(
                        AppIcon.search,
                        color: AppColors.backgroundColor,
                      ),
                    ),
                  )
                ],
              ),
              FutureBuilder(
                future: movies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text(
                      'No movies found',
                      style: TextStyle(color: AppColors.primaryColor),
                    ));
                  } else {
                    List<Movie> movieList = snapshot.data!;
                    return SizedBox(
                      height: (movieList.length + 1) * 150,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: movieList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailPage(
                                        movieId: movieList[index].id),
                                  ));
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 150,
                                        width: 100,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.memory(
                                              ConverterUnit.base64ToUnit8(
                                                  movieList[index].poster)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: AppSize.width(context) / 2,
                                              child: Text(
                                                movieList[index].title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: AppSize.width(context) / 2,
                                              child: Text(
                                                movieList[index]
                                                    .categories
                                                    .map((category) =>
                                                        category.name)
                                                    .join(', '),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: ClassifyColors
                                                    .toFlutterColor(
                                                  ClassifyColors.classifyType(
                                                      movieList[index]
                                                          .classify),
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(3.0),
                                                ),
                                              ),
                                              child: Text(
                                                movieList[index].classify,
                                                style: const TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color:
                                                      AppColors.containerColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
