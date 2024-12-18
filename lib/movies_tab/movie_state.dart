import 'models/results.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final Map<String, List<Results>> moviesResult;

  MovieLoaded(this.moviesResult);
}

class MovieError extends MovieState {
  final String message;

  MovieError(this.message);
}
