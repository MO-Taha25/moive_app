import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/details_cubit.dart';
import '../states/details_state.dart';
import 'loading_indicator.dart';
import 'package:movie_app/service_locator.dart';
import 'package:movie_app/shared/api_constant.dart';
import 'package:movie_app/shared/app_theme.dart';

import '../states/movie_state.dart';

class MovieDetails extends StatelessWidget {
  final int movieId;

  const MovieDetails({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsCubit(sl())..getMovieDetails(movieId),
      child: BlocBuilder<DetailsCubit, DetailsState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: LoadingIndicator());
          } else if (state is DetailsLoaded) {
            final genresName = state.detailsResults.genres
                    ?.map((genre) => genre.name)
                    .toList() ??
                [];
            final details = state.detailsResults;
            return Scaffold(
              backgroundColor: AppTheme.lightBlack,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * 0.27,
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                              ApiConstant.imageUrl(details.backdropPath ?? '')),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 5.0),
                      child: Text(details.title ?? '',
                          style: const TextStyle(
                              color: AppTheme.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 5.0),
                      child: Text(details.releaseDate ?? '',
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontSize: 10,
                          )),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      color: AppTheme.black,
                      height: MediaQuery.sizeOf(context).height * 0.30,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.30,
                              height: MediaQuery.sizeOf(context).height * 0.25,
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl: ApiConstant.imageUrl(
                                        details.backdropPath ?? '')),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  for (int i = 0; i < genresName.length; i += 3)
                                    Wrap(
                                      spacing: 8.0,
                                      runSpacing: 8.0,
                                      children: genresName
                                          .skip(i)
                                          .take(3)
                                          .map((genreName) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5.0),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 12.0),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppTheme.gray),
                                                    color: Colors.transparent,
                                                    // Background color
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0), // Rounded corners
                                                  ),
                                                  child: Text(
                                                    genreName ?? '',
                                                    style: const TextStyle(
                                                      color: AppTheme.lightGray,
                                                      // Text color
                                                      fontSize: 12.0,
                                                      // Text size
                                                      fontWeight: FontWeight
                                                          .w500, // Bold text
                                                    ),
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                    ),

                                  // Wrap(
                                  //   spacing: 8.0,
                                  //   runSpacing: 8.0,
                                  //   children: genresName.map((genreName) {
                                  //     return Container(
                                  //       padding: const EdgeInsets.symmetric(
                                  //           vertical: 8.0, horizontal: 12.0),
                                  //       decoration: BoxDecoration(
                                  //         border:
                                  //         Border.all(color: AppTheme.gray),
                                  //         color: Colors.transparent,
                                  //         // Background color
                                  //         borderRadius: BorderRadius.circular(
                                  //             8.0), // Rounded corners
                                  //       ),
                                  //       child: Text(
                                  //         genreName ?? '',
                                  //         style: const TextStyle(
                                  //           color: AppTheme.lightGray,
                                  //           // Text color
                                  //           fontSize: 12.0,
                                  //           // Text size
                                  //           fontWeight:
                                  //           FontWeight.w500, // Bold text
                                  //         ),
                                  //       ),
                                  //     );
                                  //   }).toList(),
                                  // ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.55,
                                    child: Text(
                                      maxLines: 12,
                                      overflow: TextOverflow.ellipsis,
                                      details.overview ?? '',
                                      style: const TextStyle(
                                        color: AppTheme.lightGray,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: AppTheme.primary,
                                      ),
                                      Text(
                                        '${details.voteAverage ?? ''}',
                                        style: const TextStyle(
                                            color: AppTheme.lightGray),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            );
          } else if (state is DetailsError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
