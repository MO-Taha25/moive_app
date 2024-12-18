import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/firebase_functions.dart';
import 'package:movie_app/shared/api_constant.dart';
import '../cubit/movie_cubit.dart';
import '../screens/movie_details_screen.dart';
import 'loading_indicator.dart';
import 'package:movie_app/service_locator.dart';
import 'package:movie_app/shared/app_theme.dart';
import 'package:shimmer/shimmer.dart';

import '../movie_state.dart';

class TopRatedMoviesWidget extends StatefulWidget {
  const TopRatedMoviesWidget({super.key});

  @override
  _TopRatedMoviesWidgetState createState() => _TopRatedMoviesWidgetState();
}

class _TopRatedMoviesWidgetState extends State<TopRatedMoviesWidget> {
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
            final movies = state.moviesResult['topRated'] ?? [];
            return FadeIn(
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsetsDirectional.only(top: 15, start: 10),
                color: AppTheme.darkGray,
                height: MediaQuery.sizeOf(context).height * 0.20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommended',
                      style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          final imageUrl = movie.posterPath != null
                              ? ApiConstant.imageUrl(movie.posterPath!)
                              : null;
                          bool isAddedToWatchlist =
                              addedMovies.contains(movie.id);
                          return Column(
                            children: [
                              Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  Container(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.10,
                                    padding: const EdgeInsets.only(
                                        right: 5, left: 5),
                                    child: InkWell(
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
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            topLeft: Radius.circular(5)),
                                        child: imageUrl != null &&
                                                imageUrl.isNotEmpty
                                            ? CachedNetworkImage(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.23,
                                                fit: BoxFit.cover,
                                                imageUrl: imageUrl,
                                                placeholder: (context, url) =>
                                                    Shimmer.fromColors(
                                                  baseColor: Colors.grey[850]!,
                                                  highlightColor:
                                                      Colors.grey[800]!,
                                                  child: Container(
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        0.14,
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.23,
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                  Icons.broken_image,
                                                  color: Colors.red,
                                                  size: 36,
                                                ),
                                              )
                                            : Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.23,
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.10,
                                                color: Colors.grey,
                                                child: const Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.white,
                                                  size: 36,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.08,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.08,
                                        imageUrl: ApiConstant.imageUrl(
                                            movie.posterPath ?? ''),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (!isAddedToWatchlist) {
                                        final watchlistMovie = {
                                          'id': movie.id,
                                          'title': movie.title,
                                          'posterPath': 'assets/movie.jpeg',
                                        };

                                        saveToWatchlist(watchlistMovie);
                                        setState(() {
                                          addedMovies.add(movie.id!);
                                        });
                                      }
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.bookmark,
                                          size: 36,
                                          color: isAddedToWatchlist
                                              ? Colors.yellow
                                              : AppTheme.gray,
                                        ),
                                        Icon(
                                          isAddedToWatchlist
                                              ? Icons.check
                                              : Icons.add,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8)),
                                    color: AppTheme.darkGray,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.gray,
                                        spreadRadius: 0.5,
                                        blurRadius: 15,
                                        offset: Offset(2, 2),
                                      ),
                                    ]),
                                width: MediaQuery.sizeOf(context).width * 0.23,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 16,
                                          color: AppTheme.primary,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                            '${movie.voteAverage?.toStringAsFixed(1) ?? 'N/A'}',
                                            style: const TextStyle(
                                                color: AppTheme.white)),
                                      ],
                                    ),
                                    Text(
                                      '${movie.title ?? 'Unknown'}',
                                      style: const TextStyle(
                                          color: AppTheme.white,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Text(
                                      '${movie.releaseDate ?? 'N/A'}',
                                      style: const TextStyle(
                                          color: AppTheme.white, fontSize: 8),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
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
