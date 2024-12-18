import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/genre_model.dart';
import '../models/movie_model.dart';

class ApiService {
  static final String MyapiKey = 'db83f5544f7e3a70b452e6166519e838';

  Future<List<Genre>> fetchGenres() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/genre/movie/list?api_key=$MyapiKey&language=en-US'));

    if (response.statusCode == 200) {
      final List genres = json.decode(response.body)['genres'];
      return genres.map((genre) => Genre.fromJson(genre)).toList();
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<List<Movie>> fetchMovies({required int genreId}) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=$MyapiKey&language=en-US&with_genres=$genreId'));

    if (response.statusCode == 200) {
      final List movies = json.decode(response.body)['results'];
      return movies.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
