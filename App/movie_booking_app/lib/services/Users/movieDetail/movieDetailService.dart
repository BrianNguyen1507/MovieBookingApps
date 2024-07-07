import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:movie_booking_app/models/category/categories.dart';
import 'package:movie_booking_app/models/movie/movieDetail.dart';
import 'package:http/http.dart' as http;

class MovieDetailService {
  static Future<MovieDetail> deatailMovieService(int id) async {
    await dotenv.load();
    final getURL = dotenv.env['GET_MOVIE_BY_ID']!;
    final url = getURL + id.toString();

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['code'] != 1000) {
          throw Exception('Failed to fetch movie detail: ${data['message']}');
        }

        final detailData = data['result'];
        List<dynamic> categories = detailData['categories'];
        List<Categories> listCategory = categories
            .map((category) => Categories.fromJson(category))
            .toList();

        MovieDetail movieDetail = MovieDetail(
          id: detailData['id'],
          title: detailData['title'],
          classify: detailData['classify'],
          categories: listCategory,
          releaseDate: DateTime.parse(detailData['releaseDate']),
          price: detailData['basePrice'],
          actor: detailData['actor'],
          director: detailData['director'],
          description: detailData['description'],
          country: detailData['country'],
          duration: detailData['duration'],
          language: detailData['language'],
          poster: detailData['poster'],
          trailer: detailData['trailer'],
          isRelease: detailData['release'],
        );

        return movieDetail;
      } else {
        throw Exception('Failed to fetch movie detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
