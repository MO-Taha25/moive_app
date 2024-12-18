import 'package:flutter/material.dart';
import '../widgets/movie_details.dart';
import '../widgets/similar.dart';

import 'package:movie_app/shared/app_theme.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBlack,
      appBar: AppBar(
        title: const Text(
          'Movie Details Screen ',
          style: TextStyle(color: AppTheme.white, fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: MovieDetails(movieId: movieId)),
          SizedBox(
            height: 8,
          ),
          SimilarMovies(movieId: movieId),
        ],
      ),
    );
  }
}
