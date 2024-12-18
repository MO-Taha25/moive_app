import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/firebase_functions.dart';
import 'package:movie_app/service_locator.dart';
import '../cubit/movie_cubit.dart';
import '../screens/movie_details_screen.dart';
import 'loading_indicator.dart';
import 'package:movie_app/shared/api_constant.dart';
import 'package:movie_app/shared/app_theme.dart';
import '../movie_state.dart';

class PopularMoviesWidget extends StatefulWidget {
  const PopularMoviesWidget({super.key});

  @override
  _PopularMoviesWidgetState createState() => _PopularMoviesWidgetState();
}

class _PopularMoviesWidgetState extends State<PopularMoviesWidget> {
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
            return FadeIn(
              duration: const Duration(milliseconds: 500),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.sizeOf(context).height * 0.32,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.2,
                  onPageChanged: (index, reason) {},
                ),
                items: state.moviesResult['popular']?.map(
                  (item) {
                    bool isAddedToWatchlist = addedMovies.contains(item.id);
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          key: const Key('openMovieMinimalDetail'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailsScreen(movieId: item.id!),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl: ApiConstant.imageUrl(
                                      item.backdropPath ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.sizeOf(context).width * 0.35,
                                    right: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.title ?? '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18,
                                                color: Colors.white,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text('${item.releaseDate}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              height: MediaQuery.sizeOf(context).height * 0.18,
                              width: MediaQuery.sizeOf(context).width * 0.25,
                              imageUrl:
                                  ApiConstant.imageUrl(item.posterPath ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.sizeOf(context).height * .13,
                          left: 8,
                          child: GestureDetector(
                            onTap: () {
                              if (!isAddedToWatchlist) {
                                final watchlistMovie = {
                                  'id': item.id,
                                  'title': item.title,
                                  'posterPath': 'assets/movie.jpeg',
                                };

                                saveToWatchlist(watchlistMovie);
                                setState(() {
                                  addedMovies.add(item.id!);
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
                                  isAddedToWatchlist ? Icons.check : Icons.add,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.play_circle_fill_outlined,
                            color: AppTheme.white,
                            size: 75,
                          ),
                        ),
                      ],
                    );
                  },
                ).toList(),
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
