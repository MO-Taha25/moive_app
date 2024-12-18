import 'package:flutter_bloc/flutter_bloc.dart';
import '../movie_state.dart';
import '../widgets/remote_data_source.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRemoteData movieRemoteData;

  MovieCubit(this.movieRemoteData) : super(MovieInitial());

  Future<void> getMovies() async {
    emit(MovieLoading());
    try {
      final popular = await movieRemoteData.getPopularMovies();
      final upcoming = await movieRemoteData.getUpcomingMovies();
      final topRated = await movieRemoteData.getTopRatedMovies();

      emit(MovieLoaded({
        'popular': popular,
        'upcoming': upcoming,
        'topRated': topRated,
      }));
    } catch (error) {
      emit(MovieError('Failed to load movies'));
    }
  }
}
