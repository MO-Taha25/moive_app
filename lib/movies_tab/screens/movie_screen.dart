import 'package:flutter/material.dart';
import '../widgets/new_releases.dart';
import '../widgets/popular.dart';

import '../widgets/top_rated.dart';
import 'package:movie_app/shared/app_theme.dart';

class MovieScreen extends StatelessWidget {
  const MovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.lightBlack,
      body: SafeArea(
        child: Column(
          children: [
            PopularMoviesWidget(),
            SizedBox(
              height: 10,
            ),
            Expanded(child: NewReleases()),
            SizedBox(
              height: 12,
            ),
            Expanded(child: TopRatedMoviesWidget()),
          ],
        ),
      ),
    );
  }
}
