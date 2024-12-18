import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/details_state.dart';
import '../widgets/remote_data_source.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final MovieRemoteData movieRemoteData;

  DetailsCubit(this.movieRemoteData) : super(DetailsInitial());

  Future<void> getMovieDetails(
    int movieId,
  ) async {
    emit(DetailsLoading());
    try {
      final movieDetails = await movieRemoteData.getMovieDetails(movieId);
      emit(DetailsLoaded(movieDetails));
    } catch (error) {
      emit(DetailsError('Failed to load movie details'));
    }
  }
}
