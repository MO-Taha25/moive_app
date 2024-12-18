import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/similar_state.dart';
import '../widgets/remote_data_source.dart';

class SimilarCubit extends Cubit<SimilarState> {
  final MovieRemoteData movieRemoteData;

  SimilarCubit(this.movieRemoteData) : super(SimilarInitial());

  Future<void> getSimilarMovies(
    int movieId,
  ) async {
    emit(SimilarLoading());
    try {
      final similarMovies = await movieRemoteData.getSimilarMovies(movieId);
      emit(SimilarLoaded({'similarMovies': similarMovies}));
    } catch (error) {
      emit(SimilarError('Failed to load movie details'));
    }
  }
}
