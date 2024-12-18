import 'package:flutter/material.dart';
import 'package:movie_app/shared/app_theme.dart';
import '../models/movie_model.dart';
import '../api/api_methods.dart';
import 'package:movie_app/movies_tab/widgets/loading_indicator.dart';

class MovieGrid extends StatefulWidget {
  final int genreId;
  final String genreName;

  MovieGrid({required this.genreId, required this.genreName});

  @override
  _MovieGridState createState() => _MovieGridState();
}

class _MovieGridState extends State<MovieGrid> {
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = ApiService().fetchMovies(genreId: widget.genreId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.lightBlack,
        title: Text(
          'Movies in ${widget.genreName}',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w600, color: AppTheme.white),
        ),
      ),
      body: FutureBuilder<List<Movie>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No movies found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final movie = snapshot.data![index];
                return GestureDetector(
                  onTap: () {},
                  child: Card(
                    color: AppTheme.black,
                    child: Row(
                      children: [
                        Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 150,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            movie.title,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
