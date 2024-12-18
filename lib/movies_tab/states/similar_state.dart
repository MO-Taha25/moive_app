import '../similar/similar_results.dart';

abstract class SimilarState {}

class SimilarInitial extends SimilarState {}

class SimilarLoading extends SimilarState {}

class SimilarLoaded extends SimilarState {
  final Map<String, List<SimilarResults>> similarResults;

  SimilarLoaded(this.similarResults);
}

class SimilarError extends SimilarState {
  final String message;

  SimilarError(this.message);
}
