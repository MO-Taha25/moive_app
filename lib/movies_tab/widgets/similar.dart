import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/service_locator.dart';
import 'package:movie_app/shared/api_constant.dart';
import 'package:movie_app/shared/app_theme.dart';
import '../cubit/similar_cubit.dart';
import '../screens/movie_details_screen.dart';
import '../states/similar_state.dart';
import 'package:shimmer/shimmer.dart';
import 'loading_indicator.dart';

class SimilarMovies extends StatelessWidget {
  const SimilarMovies({super.key, required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SimilarCubit(sl())..getSimilarMovies(movieId),
      child: BlocBuilder<SimilarCubit, SimilarState>(
        builder: (context, state) {
          if (state is SimilarLoading) {
            return const Center(child: LoadingIndicator());
          } else if (state is SimilarLoaded) {
            final movies = state.similarResults['similarMovies'] ?? [];
            return FadeIn(
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsetsDirectional.only(top: 15, start: 10),
                color: AppTheme.darkGray,
                height: MediaQuery.sizeOf(context).height * 0.30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Similar ',
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
                          return Column(
                            children: [
                              Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  Container(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.14,
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
                                        child: CachedNetworkImage(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.23,
                                          fit: BoxFit.fill,
                                          imageUrl: ApiConstant.imageUrl(movie
                                                  .backdropPath ??
                                              'https://media-cache.cinematerial.com/p/500x/i9uqxo51/the-dummy-movie-poster.jpg?v=1607205144'),
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: Colors.grey[850]!,
                                            highlightColor: Colors.grey[800]!,
                                            child: Container(
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.14,
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.23,
                                              decoration: BoxDecoration(
                                                color: AppTheme.black,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.bookmark,
                                      size: 36,
                                      color: AppTheme.gray,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0, top: 6),
                                    child: Icon(
                                      Icons.add,
                                      color: AppTheme.white,
                                      size: 18,
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
                                        Text('${movie.voteAverage}',
                                            style: const TextStyle(
                                                color: AppTheme.white)),
                                      ],
                                    ),
                                    Text(
                                      '${movie.title}',
                                      style: const TextStyle(
                                          color: AppTheme.white,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Text(
                                      '${movie.releaseDate}',
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
          } else if (state is SimilarError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
