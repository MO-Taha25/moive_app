import 'package:dio/dio.dart';
import '../models/results.dart';
import '../movie_datels/details_results.dart';
import '../similar/similar_results.dart';

import 'package:movie_app/shared/api_constant.dart';

class MovieRemoteData {
  final Dio dio = Dio(BaseOptions(baseUrl: ApiConstant.baseUrl));

  Future<List<Results>> getMoviesByEndpoint(String endpoint) async {
    final response = await dio
        .get(endpoint, queryParameters: {'api_key': ApiConstant.apiKey});
    return (response.data['results'] as List)
        .map((movie) => Results.fromJson(movie))
        .toList();
  }

  Future<List<SimilarResults>> getSimilarMovies(int movieId) async {
    final response = await dio.get(
      ApiConstant.similar(movieId),
      queryParameters: {'api_key': ApiConstant.apiKey},
    );
    return (response.data['results'] as List)
        .map((movie) => SimilarResults.fromJson(movie))
        .toList();
  }

  Future<DetailsResults> getMovieDetails(int movieId) async {
    final response = await dio.get(
      ApiConstant.details(movieId),
      queryParameters: {'api_key': ApiConstant.apiKey},
    );
    return DetailsResults.fromJson(response.data);
  }

  Future<List<Results>> getPopularMovies() =>
      getMoviesByEndpoint(ApiConstant.popular);

  Future<List<Results>> getUpcomingMovies() =>
      getMoviesByEndpoint(ApiConstant.upComing);

  Future<List<Results>> getTopRatedMovies() =>
      getMoviesByEndpoint(ApiConstant.topRated);
}
/* Future<List<Map<String , dynamic>>> getSimilarMovies( int movieId) async {
    final response = await dio
        .get(ApiConstant.similar(movieId), queryParameters: {'api_key': ApiConstant.apiKey});
     return List <Map<String , dynamic>>.from(response.data['result']);
    // (response.data['results'] as List)
    //     .map((movie) => SimilarResults.fromJson(movie))
    //     .toList();
  }
*/