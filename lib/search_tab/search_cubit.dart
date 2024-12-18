import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:movie_app/shared/api_constant.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstant.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  SearchCubit() : super(SearchInitial());

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      emit(const SearchLoaded([]));
      return;
    }

    emit(SearchLoading());

    try {
      final response = await _dio.get(
        '/3/search/movie',
        queryParameters: {
          'api_key': ApiConstant.apiKey,
          'query': query,
        },
      );

      if (response.statusCode == 200) {
        final results = response.data['results'];
        emit(SearchLoaded(results));
      } else {
        emit(SearchError("Error: ${response.statusCode}"));
      }
    } catch (error) {
      emit(SearchError("Error occurred: $error"));
    }
  }
}
