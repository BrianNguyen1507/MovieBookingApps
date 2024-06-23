import 'package:movie_booking_app/config/ipconfig.dart';
import 'dart:convert';
import 'package:movie_booking_app/models/category/categories.dart';
import 'package:movie_booking_app/models/movie/movieDetail.dart';
import 'package:http/http.dart' as http;

class MovieDetailService {
  static Future<MovieDetail> deatailMovieService(int id) async {
    final url = 'http://${ipAddress}:8083/cinema/getFilmById?id=$id';

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
            .map((category) => Categories(
                  id: category['id'],
                  name: category['name'],
                ))
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
