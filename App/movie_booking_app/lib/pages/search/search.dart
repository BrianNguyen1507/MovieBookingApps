import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/converter/converter.dart';
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
    movies = SearchMovieService.findAllMovieByKeyWord("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.commonColor,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Search"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: textFilter,
                    style: const TextStyle(
                      backgroundColor: Colors.red,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.purple, width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        movies = SearchMovieService.findAllMovieByKeyWord(
                            textFilter.text);
                      });
                    },
                    child: const Text("Search"))
              ],
            ),
            FutureBuilder(
              future: movies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No movies found.'));
                } else {
                  List<Movie> movieList = snapshot.data!;
                  return SizedBox(
                    width: 500,
                    height: 500,
                    child: ListView.builder(
                      itemCount: movieList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Image.memory(
                                        ConverterUnit.base64ToUnit8(
                                            movieList[index].poster)),
                                  ),
                                  Text(movieList[index].title),
                                  Text(
                                    movieList[index]
                                        .categories
                                        .map((category) => category.name)
                                        .join(', '),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            ],
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
    );
  }
}
