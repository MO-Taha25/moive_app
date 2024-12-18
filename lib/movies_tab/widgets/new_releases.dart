import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/firebase_functions.dart';
import '../cubit/movie_cubit.dart';
import '../movie_state.dart';
import '../screens/movie_details_screen.dart';
import 'loading_indicator.dart';
import 'package:movie_app/service_locator.dart';
import 'package:movie_app/shared/api_constant.dart';
import 'package:movie_app/shared/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class NewReleases extends StatefulWidget {
  const NewReleases({super.key});

  @override
  _NewReleasesState createState() => _NewReleasesState();
}

class _NewReleasesState extends State<NewReleases> {
  Set<int> addedMovies = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieCubit(sl())..getMovies(),
      child: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: LoadingIndicator());
          } else if (state is MovieLoaded) {
            final movies = state.moviesResult['upcoming'] ?? [];
            return FadeIn(
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsetsDirectional.only(top: 15, start: 10),
                color: AppTheme.darkGray,
                height: MediaQuery.sizeOf(context).height * 0.25,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New Releases',
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            bool isAddedToWatchlist =
                                addedMovies.contains(movie.id);

                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MovieDetailsScreen(
                                                movieId: movie.id!),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0)),
                                      child: CachedNetworkImage(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.23,
                                        height:
                                            MediaQuery.sizeOf(context).width *
                                                0.40,
                                        fit: BoxFit.cover,
                                        imageUrl: movie.posterPath != null &&
                                                movie.posterPath!.isNotEmpty
                                            ? ApiConstant.imageUrl(
                                                '${movie.posterPath}')
                                            : 'assets/movie.jpeg', // صورة افتراضية
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: Colors.grey[850]!,
                                          highlightColor: Colors.grey[800]!,
                                          child: Container(
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.40,
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.23,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/movie.jpeg', // صورة افتراضية عند الخطأ
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.23,
                                          height:
                                              MediaQuery.sizeOf(context).width *
                                                  0.40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0, // المسافة من أعلى الصورة
                                  left: 0, // المسافة من اليسار
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!isAddedToWatchlist) {
                                        final watchlistMovie = {
                                          'id': movie.id,
                                          'title': movie.title,
                                          'posterPath': 'assets/movie.jpeg',
                                        };

                                        saveToWatchlist(watchlistMovie);
                                        setState(() {
                                          addedMovies
                                              .add(movie.id!); // إضافة الفيلم
                                        });
                                      }
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // أيقونة "Bookmark" الرئيسية
                                        Icon(
                                          Icons.bookmark,
                                          size: 36,
                                          color: isAddedToWatchlist
                                              ? Colors
                                                  .yellow // لون أصفر عند الإضافة
                                              : AppTheme
                                                  .gray, // لون رمادي قبل الإضافة
                                        ),
                                        // الأيقونة العلوية (زائد أو صح)
                                        Icon(
                                          isAddedToWatchlist
                                              ? Icons
                                                  .check // علامة صح عند الإضافة
                                              : Icons
                                                  .add, // علامة زائد قبل الإضافة
                                          size: 18,
                                          color: Colors.white, // اللون الأبيض
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is MovieError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }

  void saveToWatchlist(Map<String, dynamic> movie) async {
    await FirebaseFunctions.saveMovieToWatchlist(movie);
  }
}
