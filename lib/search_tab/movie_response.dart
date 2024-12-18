import 'movie.dart';

class MovieResponse {
  final List<Movie> results;

  MovieResponse({required this.results});

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      results: List<Movie>.from(json['results'].map((movie) => Movie.fromJson(movie))),
    );
  }
}

