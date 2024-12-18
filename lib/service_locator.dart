import 'package:get_it/get_it.dart';

import 'package:movie_app/movies_tab/widgets/remote_data_source.dart';

final sl = GetIt.instance;
void setUp() {
  sl.registerLazySingleton(() => MovieRemoteData());
}
