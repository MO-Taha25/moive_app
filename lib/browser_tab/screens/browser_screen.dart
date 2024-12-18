import 'package:flutter/material.dart';
import 'package:movie_app/movies_tab/widgets/loading_indicator.dart';
import 'package:movie_app/shared/app_theme.dart';
import '../api/api_methods.dart';
import '../models/genre_model.dart';
import 'movie_list_genres.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({super.key});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  late Future<List<Genre>> futureGenres;

  @override
  void initState() {
    super.initState();
    futureGenres = ApiService().fetchGenres();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Genre>>(
      future: futureGenres,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: LoadingIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No category found'));
        } else {
          return Scaffold(
              backgroundColor: AppTheme.black,
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "Browser Category",
                        style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 5 / 3,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 8),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final genre = snapshot.data![index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieGrid(
                                      genreId: genre.id, genreName: genre.name),
                                ),
                              );
                            },
                            child: Card(
                              child: Stack(
                                children: [
                                  Image(
                                    image: AssetImage("assets/darkbanner.jpg"),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      genre.name,
                                      style: TextStyle(
                                        color: AppTheme.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ));
        }
      },
    );
  }
}
