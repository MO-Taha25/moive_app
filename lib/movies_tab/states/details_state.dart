import '../movie_datels/details_results.dart';

abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

class DetailsLoading extends DetailsState {}

class DetailsLoaded extends DetailsState {
  final DetailsResults detailsResults;

  DetailsLoaded(this.detailsResults);
}

class DetailsError extends DetailsState {
  final String message;

  DetailsError(this.message);
}
